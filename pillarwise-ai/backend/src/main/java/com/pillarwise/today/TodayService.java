package com.pillarwise.today;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.ai.StructuredAiGenerator;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
import com.pillarwise.config.AppProperties;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import java.time.Clock;
import java.time.Instant;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class TodayService {
  private final JdbcTemplate jdbcTemplate;
  private final Jsons jsons;
  private final Clock clock;
  private final BirthProfileRepository birthProfiles;
  private final BaziService baziService;
  private final InsightMapper insightMapper;
  private final AppProperties properties;
  private final StructuredAiGenerator aiGenerator;

  public TodayService(
      JdbcTemplate jdbcTemplate,
      Jsons jsons,
      Clock clock,
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      InsightMapper insightMapper,
      AppProperties properties,
      StructuredAiGenerator aiGenerator
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.jsons = jsons;
    this.clock = clock;
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.insightMapper = insightMapper;
    this.properties = properties;
    this.aiGenerator = aiGenerator;
  }

  public Map<String, Object> today(String userId, String birthProfileId, String dateText) {
    String profileId = birthProfileId == null || birthProfileId.isBlank()
        ? birthProfiles.findPrimaryByUser(userId).orElseThrow(() -> AppException.notFound("Create your blueprint first.")).id()
        : birthProfileId;
    LocalDate date = dateText == null || dateText.isBlank() ? LocalDate.now(clock) : LocalDate.parse(dateText);
    List<Map<String, Object>> existing = jdbcTemplate.queryForList(
        "SELECT id, content_json FROM daily_insights WHERE user_id = ? AND birth_profile_id = ? AND insight_date = ? LIMIT 1",
        userId,
        profileId,
        date.toString()
    );
    if (!existing.isEmpty()) {
      Map<String, Object> content = new LinkedHashMap<>(jsons.readMap(existing.getFirst().get("content_json").toString()));
      content.put("id", existing.getFirst().get("id"));
      return content;
    }
    BirthProfile profile = birthProfiles.findByIdForUser(profileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    BaziChart chart = baziService.chartForProfile(profile);
    InsightMapper.MappedInsight insight = insightMapper.map(chart);
    Map<String, Object> content = aiToday(date, profile, chart, insight)
        .orElseGet(() -> generate(date, insight, chart));
    String id = Ids.newId("day");
    jdbcTemplate.update(
        """
        INSERT INTO daily_insights(id, user_id, birth_profile_id, insight_date, content_json, prompt_version, model_version, created_at)
        VALUES (?, ?, ?, ?, ?, 'daily-v1.0.0', ?, ?)
        """,
        id,
        userId,
        profile.id(),
        date.toString(),
        jsons.write(content),
        modelVersion(),
        Instant.now(clock).toString()
    );
    content = new LinkedHashMap<>(content);
    content.put("id", id);
    return content;
  }

  private java.util.Optional<Map<String, Object>> aiToday(LocalDate date, BirthProfile profile, BaziChart chart, InsightMapper.MappedInsight insight) {
    Map<String, Object> context = Map.of(
        "date", date.toString(),
        "profile", Map.of(
            "birthProfileId", profile.id(),
            "timezone", profile.timezone(),
            "birthTimePrecision", profile.birthTimePrecision()
        ),
        "chart", Map.of(
            "dayMaster", chart.dayMaster(),
            "elementDistribution", chart.elementDistribution(),
            "confidence", chart.confidence()
        ),
        "mappedInsight", Map.of(
            "strengths", insight.strengths(),
            "blindSpots", insight.blindSpots(),
            "currentPhase", insight.currentPhase()
        )
    );
    String prompt = """
        Generate today's PillarWise daily insight as valid JSON only.
        Keep it practical, non-fatalistic, and safe. Context:
        %s

        Required JSON shape:
        {
          "date": "%s",
          "greeting": "string",
          "focus": {"title": "string", "body": "string"},
          "challenge": {"title": "string", "body": "string"},
          "opportunity": {"title": "string", "body": "string"},
          "action": "string",
          "reflectionQuestion": "string",
          "weeklyTheme": "string",
          "confidence": {}
        }
        """.formatted(aiGenerator.write(context), date);
    return aiGenerator.generate(systemPrompt(), prompt, 1400).flatMap(raw -> normalizeToday(raw, date, chart));
  }

  private java.util.Optional<Map<String, Object>> normalizeToday(Map<String, Object> raw, LocalDate date, BaziChart chart) {
    Map<String, Object> focus = objectMap(raw.get("focus"));
    Map<String, Object> challenge = objectMap(raw.get("challenge"));
    Map<String, Object> opportunity = objectMap(raw.get("opportunity"));
    if (focus.isEmpty() || challenge.isEmpty() || opportunity.isEmpty()) {
      return java.util.Optional.empty();
    }
    String action = text(raw.get("action"), "");
    String reflectionQuestion = text(raw.get("reflectionQuestion"), "");
    if (action.isBlank() || reflectionQuestion.isBlank()) {
      return java.util.Optional.empty();
    }
    Map<String, Object> normalized = new LinkedHashMap<>();
    normalized.put("date", date.toString());
    normalized.put("greeting", text(raw.get("greeting"), "Good morning"));
    normalized.put("focus", titledBody(focus));
    normalized.put("challenge", titledBody(challenge));
    normalized.put("opportunity", titledBody(opportunity));
    normalized.put("action", action);
    normalized.put("reflectionQuestion", reflectionQuestion);
    normalized.put("weeklyTheme", text(raw.get("weeklyTheme"), ""));
    normalized.put("confidence", chart.confidence());
    return java.util.Optional.of(normalized);
  }

  private static String systemPrompt() {
    return """
        You are PillarWise AI. Use BaZi symbolism only as a reflective framework.
        Do not make deterministic predictions or give medical, legal, investment, or emergency advice.
        Return JSON only.
        """;
  }

  private static Map<String, Object> titledBody(Map<String, Object> map) {
    String title = text(map.get("title"), "");
    String body = text(map.get("body"), "");
    if (title.isBlank() || body.isBlank()) {
      return Map.of();
    }
    return Map.of("title", title, "body", body);
  }

  private static Map<String, Object> objectMap(Object value) {
    if (!(value instanceof Map<?, ?> source)) {
      return Map.of();
    }
    Map<String, Object> map = new LinkedHashMap<>();
    source.forEach((key, item) -> map.put(String.valueOf(key), item));
    return map;
  }

  private static String text(Object value, String fallback) {
    return value instanceof String text && !text.isBlank() ? text.trim() : fallback;
  }

  private static Map<String, Object> generate(LocalDate date, InsightMapper.MappedInsight insight, BaziChart chart) {
    int weekday = date.getDayOfWeek().getValue();
    String focusTitle = switch (weekday % 5) {
      case 0 -> "Choose clarity over guessing.";
      case 1 -> "Build the container before the leap.";
      case 2 -> "Let one honest signal be enough.";
      case 3 -> "Finish what is quietly draining you.";
      default -> "Protect your attention from scattered urgency.";
    };
    String strength = insight.strengths().getFirst();
    return new LinkedHashMap<>(Map.of(
        "date", date.toString(),
        "greeting", "Good morning",
        "focus", Map.of(
            "title", focusTitle,
            "body", "Your pattern suggests today is better for one grounded choice than several half-open possibilities."
        ),
        "challenge", Map.of(
            "title", "Over-carrying the outcome",
            "body", insight.blindSpots().getFirst()
        ),
        "opportunity", Map.of(
            "title", "A cleaner next step",
            "body", strength
        ),
        "action", "Choose one direct action and complete it before widening the plan.",
        "reflectionQuestion", "Where are you turning uncertainty into a story?",
        "weeklyTheme", insight.currentPhase(),
        "confidence", chart.confidence()
    ));
  }

  private String modelVersion() {
    if (properties.ai() == null || properties.ai().model() == null || properties.ai().model().isBlank()) {
      return "qwen-plus";
    }
    return properties.ai().model();
  }
}
