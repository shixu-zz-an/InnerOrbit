package com.pillarwise.ai;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
import com.pillarwise.config.AppProperties;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import com.pillarwise.subscription.EntitlementService;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class AiService {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;
  private final Jsons jsons;
  private final BirthProfileRepository birthProfiles;
  private final BaziService baziService;
  private final InsightMapper insightMapper;
  private final SafetyGuard safetyGuard;
  private final EntitlementService entitlementService;
  private final AppProperties properties;
  private final List<AiProvider> providers;
  private final AiAnswerValidator answerValidator;

  public AiService(
      JdbcTemplate jdbcTemplate,
      Clock clock,
      Jsons jsons,
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      InsightMapper insightMapper,
      SafetyGuard safetyGuard,
      EntitlementService entitlementService,
      AppProperties properties,
      List<AiProvider> providers,
      AiAnswerValidator answerValidator
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
    this.jsons = jsons;
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.insightMapper = insightMapper;
    this.safetyGuard = safetyGuard;
    this.entitlementService = entitlementService;
    this.properties = properties;
    this.providers = providers;
    this.answerValidator = answerValidator;
  }

  public Map<String, Object> createConversation(String userId, AiConversationRequest request) {
    String birthProfileId = normalizeProfileId(userId, request.birthProfileId());
    String id = Ids.newId("conv");
    Instant now = Instant.now(clock);
    jdbcTemplate.update(
        "INSERT INTO conversations(id, user_id, birth_profile_id, topic, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
        id,
        userId,
        birthProfileId,
        blankDefault(request.topic(), "general"),
        now.toString(),
        now.toString()
    );
    return Map.of("conversationId", id, "birthProfileId", birthProfileId, "topic", blankDefault(request.topic(), "general"));
  }

  public Map<String, Object> sendMessage(String userId, AiMessageRequest request) {
    if (request.message() == null || request.message().isBlank()) {
      throw AppException.validation("Message is required.", Map.of("message", "Ask your guide a question first."));
    }
    if (!entitlementService.premiumActive(userId) && freeQuestionsUsedToday(userId) >= 1) {
      throw AppException.entitlement("ai_unlimited");
    }
    String conversationId = request.conversationId();
    if (conversationId == null || conversationId.isBlank()) {
      conversationId = createConversation(userId, new AiConversationRequest(request.birthProfileId(), "general")).get("conversationId").toString();
    }
    String birthProfileId = normalizeProfileId(userId, request.birthProfileId());
    ensureConversation(userId, conversationId);
    saveMessage(conversationId, "user", request.message().trim(), null, "pending");

    String locale = localeFrom(request.context());
    SafetyGuard.SafetyDecision decision = safetyGuard.precheck(request.message());
    GeneratedAnswer generated = decision.allowed()
        ? answer(userId, birthProfileId, request.message(), locale)
        : new GeneratedAnswer(decision.fallbackAnswer(), null, decision.label());
    Map<String, Object> answer = generated.answer();
    if (!safetyGuard.outputSafe(answer)) {
      answer = safetyFallback(locale);
      generated = new GeneratedAnswer(answer, generated.completion(), "output_safety_fallback");
    }
    String messageId = saveMessage(conversationId, "assistant", generated.completion() == null ? "" : generated.completion().content(), answer, generated.safetyLabel(), generated.completion());
    jdbcTemplate.update("UPDATE conversations SET updated_at = ? WHERE id = ?", Instant.now(clock).toString(), conversationId);
    return Map.of(
        "messageId", messageId,
        "conversationId", conversationId,
        "answer", answer,
        "quota", Map.of(
            "remainingToday", entitlementService.premiumActive(userId) ? 99 : Math.max(0, 1 - freeQuestionsUsedToday(userId)),
            "premiumRequired", false
        )
    );
  }

  public Map<String, Object> conversation(String userId, String conversationId) {
    ensureConversation(userId, conversationId);
    List<Map<String, Object>> messages = jdbcTemplate.query(
        "SELECT * FROM messages WHERE conversation_id = ? ORDER BY created_at",
        (rs, rowNum) -> {
          Map<String, Object> map = new LinkedHashMap<>();
          map.put("id", rs.getString("id"));
          map.put("role", rs.getString("role"));
          map.put("content", rs.getString("content"));
          map.put("answer", jsons.readMap(rs.getString("answer_json")));
          map.put("safetyLabel", rs.getString("safety_label"));
          map.put("createdAt", rs.getString("created_at"));
          return map;
        },
        conversationId
    );
    return Map.of("conversationId", conversationId, "messages", messages);
  }

  private GeneratedAnswer answer(String userId, String birthProfileId, String message, String locale) {
    BirthProfile profile = birthProfiles.findByIdForUser(birthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    BaziChart chart = baziService.chartForProfile(profile);
    InsightMapper.MappedInsight insight = insightMapper.map(chart);
    AiProvider provider = activeProvider();
    AiCompletion completion = provider.complete(new AiRequest(
        systemPrompt(locale),
        List.of(new AiMessage("user", userPrompt(profile, chart, insight, message, locale))),
        "json_object",
        0.6,
        null
    ));
    try {
      return new GeneratedAnswer(answerValidator.parseAndValidate(completion.content()), completion, "safe");
    } catch (IllegalArgumentException ex) {
      return new GeneratedAnswer(schemaFallback(chart, insight, locale), completion, "schema_fallback");
    }
  }

  private String systemPrompt(String locale) {
    return """
        You are PillarWise AI, a warm and grounded self-discovery guide.
        You use Chinese BaZi / Four Pillars symbolism only as a reflective framework.
        Do not present any insight as deterministic fate.
        Do not use Chinese metaphysical jargon unless the user asks for it.
        Do not provide medical, legal, investment, or emergency mental health advice.
        Do not predict death, illness, disasters, pregnancy, marriage dates, or guaranteed wealth.
        Use %s.
        Every user-facing JSON string must be written in that language.
        Always include one practical next step and one reflection question.
        If the user asks for deterministic prediction, reframe into patterns, timing themes, and choices.
        Return valid JSON only.
        """.formatted(answerLanguage(locale));
  }

  private String userPrompt(BirthProfile profile, BaziChart chart, InsightMapper.MappedInsight insight, String message, String locale) {
    Map<String, Object> context = Map.of(
        "user", Map.of(
            "birthProfileId", profile.id(),
            "locale", locale
        ),
        "chart", Map.of(
            "calcVersion", chart.calcVersion(),
            "dayMaster", chart.dayMaster(),
            "fourPillars", Map.of(
                "year", Map.of("stem", chart.yearStem(), "branch", chart.yearBranch()),
                "month", Map.of("stem", chart.monthStem(), "branch", chart.monthBranch()),
                "day", Map.of("stem", chart.dayStem(), "branch", chart.dayBranch()),
                "hour", chart.hourStem() == null ? Map.of() : Map.of("stem", chart.hourStem(), "branch", chart.hourBranch())
            ),
            "elementDistribution", chart.elementDistribution(),
            "confidence", chart.confidence()
        ),
        "mappedInsight", Map.of(
            "coreArchetype", insight.coreArchetype(),
            "strengths", insight.strengths(),
            "blindSpots", insight.blindSpots(),
            "relationshipPattern", insight.relationshipPattern(),
            "careerStyle", insight.careerStyle(),
            "moneyStyle", insight.moneyStyle(),
            "currentPhase", insight.currentPhase()
        ),
        "currentQuestion", message
    );
    return """
        The user asks: %s

        Use the structured profile context below. Do not calculate or change the Four Pillars.
        Context JSON:
        %s

        Return JSON with this schema:
        {
          "headline": "string",
          "summary": "string",
          "sections": [{"title": "string", "body": "string"}],
          "practicalStep": "string",
          "reflectionQuestion": "string",
          "safetyNote": "optional string"
        }
        """.formatted(message, jsons.write(context));
  }

  private Map<String, Object> schemaFallback(BaziChart chart, InsightMapper.MappedInsight insight, String locale) {
    if (isChineseLocale(locale)) {
      return Map.of(
          "headline", "我们把这件事放回现实。",
          "summary", "你的 " + chart.dayMaster() + " 模式更适合作为反思镜头，而不是固定预测。",
          "sections", List.of(
              Map.of("title", "当前模式", "body", insight.currentPhase()),
              Map.of("title", "可用优势", "body", insight.strengths().getFirst()),
              Map.of("title", "需要留意", "body", insight.blindSpots().getFirst())
          ),
          "practicalStep", "今天只选择一个你能掌控的具体行动。",
          "reflectionQuestion", "当你不再需要一个保证的答案时，什么会变得更轻？"
      );
    }
    return Map.of(
        "headline", "Let’s keep this useful and grounded.",
        "summary", "Your " + chart.dayMaster() + " pattern is best used as a reflection lens, not a fixed prediction.",
        "sections", List.of(
            Map.of("title", "The pattern", "body", insight.currentPhase()),
            Map.of("title", "What helps", "body", insight.strengths().getFirst()),
            Map.of("title", "What to watch", "body", insight.blindSpots().getFirst())
        ),
        "practicalStep", "Choose one action you can complete without needing certainty first.",
        "reflectionQuestion", "What changes when you treat this as a pattern instead of a verdict?"
    );
  }

  private Map<String, Object> safetyFallback(String locale) {
    if (isChineseLocale(locale)) {
      return Map.of(
          "headline", "我们把这件事放回现实。",
          "summary", "我可以帮助你反思模式和选择，但不会做确定性预测。",
          "sections", List.of(Map.of("title", "一个有用的框架", "body", "专注于下一个你可以清楚做出的选择。")),
          "practicalStep", "今天选择一个你能掌控的具体行动。",
          "reflectionQuestion", "当你不再需要一个保证的答案时，什么会改变？"
      );
    }
    return Map.of(
        "headline", "Let’s keep this grounded.",
        "summary", "I can help you reflect on patterns and choices without making fixed predictions.",
        "sections", List.of(Map.of("title", "A useful frame", "body", "Focus on the next choice you can make with clarity.")),
        "practicalStep", "Choose one concrete action you control today.",
        "reflectionQuestion", "What changes when you stop needing a guaranteed answer?"
    );
  }

  private static String localeFrom(Map<String, Object> context) {
    if (context == null) {
      return "en";
    }
    Object locale = context.get("locale");
    return locale == null || locale.toString().isBlank() ? "en" : locale.toString();
  }

  private static boolean isChineseLocale(String locale) {
    return locale != null && locale.toLowerCase().startsWith("zh");
  }

  private static String answerLanguage(String locale) {
    return isChineseLocale(locale)
        ? "polished, concise Simplified Chinese suitable for a mature iOS app; translate all archetype names, labels, and section titles into Chinese, and avoid English parenthetical labels unless the user explicitly asks"
        : "modern, emotionally intelligent English";
  }

  private AiProvider activeProvider() {
    String provider = properties.ai() == null || properties.ai().provider() == null || properties.ai().provider().isBlank()
        ? "qwen"
        : properties.ai().provider();
    return providers.stream()
        .filter(candidate -> candidate.supports(provider))
        .findFirst()
        .orElseThrow(() -> AppException.validation("AI provider is not supported.", Map.of("provider", provider)));
  }

  private String normalizeProfileId(String userId, String birthProfileId) {
    if (birthProfileId != null && !birthProfileId.isBlank()) {
      return birthProfileId;
    }
    return birthProfiles.findPrimaryByUser(userId)
        .orElseThrow(() -> AppException.notFound("Create your blueprint first."))
        .id();
  }

  private int freeQuestionsUsedToday(String userId) {
    String start = LocalDate.now(clock).atStartOfDay().toInstant(java.time.ZoneOffset.UTC).toString();
    Integer count = jdbcTemplate.queryForObject(
        """
        SELECT COUNT(*)
        FROM messages m
        JOIN conversations c ON c.id = m.conversation_id
        WHERE c.user_id = ? AND m.role = 'user' AND m.created_at >= ?
        """,
        Integer.class,
        userId,
        start
    );
    return count == null ? 0 : count;
  }

  private void ensureConversation(String userId, String conversationId) {
    Integer count = jdbcTemplate.queryForObject(
        "SELECT COUNT(*) FROM conversations WHERE id = ? AND user_id = ?",
        Integer.class,
        conversationId,
        userId
    );
    if (count == null || count == 0) {
      throw AppException.notFound("Conversation was not found.");
    }
  }

  private String saveMessage(String conversationId, String role, String content, Map<String, Object> answer, String safetyLabel) {
    return saveMessage(conversationId, role, content, answer, safetyLabel, null);
  }

  private String saveMessage(String conversationId, String role, String content, Map<String, Object> answer, String safetyLabel, AiCompletion completion) {
    String id = Ids.newId("msg");
    jdbcTemplate.update(
        """
        INSERT INTO messages(id, conversation_id, role, content, answer_json, safety_label, tokens_input, tokens_output, cost_usd, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        id,
        conversationId,
        role,
        content,
        answer == null ? null : jsons.write(answer),
        safetyLabel,
        completion == null ? (role.equals("user") ? Math.max(1, content.length() / 4) : 0) : completion.inputTokens(),
        completion == null ? (answer == null ? 0 : Math.max(1, answer.toString().length() / 4)) : completion.outputTokens(),
        completion == null ? 0.0 : completion.costUsd(),
        Instant.now(clock).toString()
    );
    return id;
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }

  private record GeneratedAnswer(
      Map<String, Object> answer,
      AiCompletion completion,
      String safetyLabel
  ) {}
}
