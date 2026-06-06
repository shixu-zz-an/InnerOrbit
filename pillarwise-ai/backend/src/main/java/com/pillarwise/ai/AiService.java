package com.pillarwise.ai;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziRepository;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
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
  private final BaziRepository charts;
  private final InsightMapper insightMapper;
  private final SafetyGuard safetyGuard;
  private final EntitlementService entitlementService;

  public AiService(
      JdbcTemplate jdbcTemplate,
      Clock clock,
      Jsons jsons,
      BirthProfileRepository birthProfiles,
      BaziRepository charts,
      InsightMapper insightMapper,
      SafetyGuard safetyGuard,
      EntitlementService entitlementService
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
    this.jsons = jsons;
    this.birthProfiles = birthProfiles;
    this.charts = charts;
    this.insightMapper = insightMapper;
    this.safetyGuard = safetyGuard;
    this.entitlementService = entitlementService;
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

    SafetyGuard.SafetyDecision decision = safetyGuard.precheck(request.message());
    Map<String, Object> answer = decision.allowed() ? answer(userId, birthProfileId, request.message()) : decision.fallbackAnswer();
    if (!safetyGuard.outputSafe(answer)) {
      answer = Map.of(
          "headline", "Let’s keep this grounded.",
          "summary", "I can help you reflect on patterns and choices without making fixed predictions.",
          "sections", List.of(Map.of("title", "A useful frame", "body", "Focus on the next choice you can make with clarity.")),
          "practicalStep", "Choose one concrete action you control today.",
          "reflectionQuestion", "What changes when you stop needing a guaranteed answer?"
      );
    }
    String messageId = saveMessage(conversationId, "assistant", "", answer, decision.label());
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

  private Map<String, Object> answer(String userId, String birthProfileId, String message) {
    BirthProfile profile = birthProfiles.findByIdForUser(birthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    BaziChart chart = charts.findLatestByBirthProfileId(profile.id())
        .orElseThrow(() -> AppException.notFound("Chart was not found."));
    InsightMapper.MappedInsight insight = insightMapper.map(chart);
    String topic = message.toLowerCase().contains("career") ? insight.careerStyle()
        : message.toLowerCase().contains("relationship") || message.toLowerCase().contains("love") ? insight.relationshipPattern()
        : insight.currentPhase();
    return Map.of(
        "headline", "You may be craving clarity before your foundation feels settled.",
        "summary", "Your " + chart.dayMaster() + " pattern suggests that the answer becomes clearer when you turn pressure into one grounded next step.",
        "sections", List.of(
            Map.of("title", "The pattern", "body", topic),
            Map.of("title", "What to watch", "body", insight.blindSpots().getFirst()),
            Map.of("title", "Your useful strength", "body", insight.strengths().getFirst())
        ),
        "practicalStep", "Pick one unfinished commitment and close it before starting a new one.",
        "reflectionQuestion", "What would feel lighter if it were finished this week?"
    );
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
        role.equals("user") ? Math.max(1, content.length() / 4) : 0,
        answer == null ? 0 : Math.max(1, answer.toString().length() / 4),
        0.0,
        Instant.now(clock).toString()
    );
    return id;
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }
}
