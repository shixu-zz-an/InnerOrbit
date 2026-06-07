package com.pillarwise.relationship;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
import com.pillarwise.ai.StructuredAiGenerator;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import com.pillarwise.profile.BirthProfileRequest;
import com.pillarwise.profile.BirthProfileService;
import com.pillarwise.report.Report;
import com.pillarwise.report.ReportRepository;
import com.pillarwise.subscription.EntitlementService;
import java.time.Clock;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class RelationshipService {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;
  private final BirthProfileService birthProfileService;
  private final BirthProfileRepository birthProfiles;
  private final BaziService baziService;
  private final ReportRepository reports;
  private final EntitlementService entitlementService;
  private final StructuredAiGenerator aiGenerator;

  public RelationshipService(
      JdbcTemplate jdbcTemplate,
      Clock clock,
      BirthProfileService birthProfileService,
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      ReportRepository reports,
      EntitlementService entitlementService,
      StructuredAiGenerator aiGenerator
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
    this.birthProfileService = birthProfileService;
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.reports = reports;
    this.entitlementService = entitlementService;
    this.aiGenerator = aiGenerator;
  }

  public Map<String, Object> create(String userId, RelationshipRequest request) {
    if (request.targetName() == null || request.targetName().isBlank()) {
      throw AppException.validation("Name is required.", Map.of("targetName", "Enter a name or nickname."));
    }
    BirthProfileService.CreateBirthProfileResult target = birthProfileService.createSecondary(
        userId,
        new BirthProfileRequest(
            request.targetName(),
            request.birthDate(),
            request.birthTime(),
            request.birthTimePrecision(),
            request.birthPlaceText(),
            request.latitude(),
            request.longitude(),
            request.timezone(),
            "prefer_not_to_say",
            true,
            false
        )
    );
    String id = Ids.newId("rel");
    Instant now = Instant.now(clock);
    jdbcTemplate.update(
        """
        INSERT INTO relationship_profiles(id, user_id, target_name, relationship_type, target_birth_profile_id, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
        """,
        id,
        userId,
        request.targetName().trim(),
        blankDefault(request.relationshipType(), "romantic_partner"),
        target.profile().id(),
        now.toString(),
        now.toString()
    );
    return get(userId, id);
  }

  public List<Map<String, Object>> list(String userId) {
    return jdbcTemplate.query(
        "SELECT * FROM relationship_profiles WHERE user_id = ? ORDER BY created_at DESC",
        (rs, rowNum) -> relationship(
            rs.getString("id"),
            rs.getString("target_name"),
            rs.getString("relationship_type"),
            rs.getString("target_birth_profile_id"),
            rs.getString("created_at")
        ),
        userId
    );
  }

  public Map<String, Object> get(String userId, String id) {
    return jdbcTemplate.query(
        "SELECT * FROM relationship_profiles WHERE id = ? AND user_id = ?",
        (rs, rowNum) -> relationship(
            rs.getString("id"),
            rs.getString("target_name"),
            rs.getString("relationship_type"),
            rs.getString("target_birth_profile_id"),
            rs.getString("created_at")
        ),
        id,
        userId
    ).stream().findFirst().orElseThrow(() -> AppException.notFound("Relationship profile was not found."));
  }

  public Map<String, Object> report(String userId, String relationshipId, RelationshipReportRequest request) {
    Map<String, Object> relationship = get(userId, relationshipId);
    BirthProfile userProfile = birthProfiles.findPrimaryByUser(userId)
        .orElseThrow(() -> AppException.notFound("Create your blueprint first."));
    String targetBirthProfileId = relationship.get("targetBirthProfileId").toString();
    BaziChart userChart = baziService.chartForProfile(userProfile);
    BirthProfile targetProfile = birthProfiles.findByIdForUser(targetBirthProfileId, userId)
        .orElseThrow(() -> AppException.notFound("Their chart was not found."));
    BaziChart targetChart = baziService.chartForProfile(targetProfile);
    Map<String, Object> preview = aiCompatibility(relationship, userChart, targetChart)
        .orElseGet(() -> compatibility(relationship, userChart, targetChart));
    boolean full = "full".equalsIgnoreCase(request.mode()) || entitlementService.premiumActive(userId);
    if ("full".equalsIgnoreCase(request.mode()) && !entitlementService.premiumActive(userId)) {
      throw AppException.entitlement("relationship_full");
    }
    Map<String, Object> fullReport = full
        ? aiFullRelationship(relationship, preview, userChart, targetChart).orElseGet(() -> fullRelationship(preview))
        : null;
    Report report = reports.save(userId, userProfile.id(), relationshipId, "relationship", preview, fullReport, true, full);
    return Map.of(
        "relationshipId", relationshipId,
        "reportId", report.id(),
        "preview", preview,
        "fullReport", fullReport == null ? Map.of() : fullReport,
        "unlocked", report.unlocked()
    );
  }

  private java.util.Optional<Map<String, Object>> aiCompatibility(Map<String, Object> relationship, BaziChart userChart, BaziChart targetChart) {
    Map<String, Object> context = relationshipContext(relationship, userChart, targetChart, Map.of());
    String prompt = """
        Generate a relationship compatibility preview as valid JSON only.
        Keep it reflective, non-deterministic, and focused on communication patterns.
        Context:
        %s

        Required JSON shape:
        {
          "patternName": "string",
          "chemistryScore": 0,
          "communicationScore": 0,
          "stabilityScore": 0,
          "communicationSnapshot": "string",
          "mainStrength": "string",
          "mainTension": "string",
          "advicePrompts": ["string", "string"]
        }
        Scores must be integers from 0 to 100.
        """.formatted(aiGenerator.write(context));
    return aiGenerator.generate(systemPrompt(), prompt, 1200).flatMap(RelationshipService::normalizePreview);
  }

  private java.util.Optional<Map<String, Object>> aiFullRelationship(Map<String, Object> relationship, Map<String, Object> preview, BaziChart userChart, BaziChart targetChart) {
    Map<String, Object> context = relationshipContext(relationship, userChart, targetChart, preview);
    String prompt = """
        Generate a full relationship report as valid JSON only.
        Keep it practical and non-deterministic. Context:
        %s

        Required JSON shape:
        {
          "overview": "string",
          "emotionalChemistry": "string",
          "communicationStyle": "string",
          "conflictPattern": "string",
          "trustAndSecurity": "string",
          "conversationPrompts": ["string", "string", "string"],
          "practicalAdvice": "string"
        }
        """.formatted(aiGenerator.write(context));
    return aiGenerator.generate(systemPrompt(), prompt, 1400).flatMap(RelationshipService::normalizeFull);
  }

  private static Map<String, Object> relationshipContext(Map<String, Object> relationship, BaziChart userChart, BaziChart targetChart, Map<String, Object> preview) {
    return Map.of(
        "relationship", relationship,
        "userChart", chartContext(userChart),
        "targetChart", chartContext(targetChart),
        "preview", preview
    );
  }

  private static Map<String, Object> chartContext(BaziChart chart) {
    return Map.of(
        "dayMaster", chart.dayMaster(),
        "dayStem", chart.dayStem(),
        "dayBranch", chart.dayBranch(),
        "elementDistribution", chart.elementDistribution(),
        "confidence", chart.confidence()
    );
  }

  private static java.util.Optional<Map<String, Object>> normalizePreview(Map<String, Object> raw) {
    String patternName = text(raw.get("patternName"), "");
    String communicationSnapshot = text(raw.get("communicationSnapshot"), "");
    String mainStrength = text(raw.get("mainStrength"), "");
    String mainTension = text(raw.get("mainTension"), "");
    List<String> advicePrompts = stringList(raw.get("advicePrompts"), 2);
    if (patternName.isBlank() || communicationSnapshot.isBlank() || mainStrength.isBlank() || mainTension.isBlank() || advicePrompts.isEmpty()) {
      return java.util.Optional.empty();
    }
    return java.util.Optional.of(Map.of(
        "patternName", patternName,
        "chemistryScore", score(raw.get("chemistryScore"), 70),
        "communicationScore", score(raw.get("communicationScore"), 70),
        "stabilityScore", score(raw.get("stabilityScore"), 70),
        "communicationSnapshot", communicationSnapshot,
        "mainStrength", mainStrength,
        "mainTension", mainTension,
        "advicePrompts", advicePrompts
    ));
  }

  private static java.util.Optional<Map<String, Object>> normalizeFull(Map<String, Object> raw) {
    String overview = text(raw.get("overview"), "");
    String emotionalChemistry = text(raw.get("emotionalChemistry"), "");
    String communicationStyle = text(raw.get("communicationStyle"), "");
    String conflictPattern = text(raw.get("conflictPattern"), "");
    String trustAndSecurity = text(raw.get("trustAndSecurity"), "");
    String practicalAdvice = text(raw.get("practicalAdvice"), "");
    if (overview.isBlank() || emotionalChemistry.isBlank() || communicationStyle.isBlank() || conflictPattern.isBlank() || trustAndSecurity.isBlank() || practicalAdvice.isBlank()) {
      return java.util.Optional.empty();
    }
    return java.util.Optional.of(Map.of(
        "overview", overview,
        "emotionalChemistry", emotionalChemistry,
        "communicationStyle", communicationStyle,
        "conflictPattern", conflictPattern,
        "trustAndSecurity", trustAndSecurity,
        "conversationPrompts", stringList(raw.get("conversationPrompts"), 3),
        "practicalAdvice", practicalAdvice
    ));
  }

  private static String systemPrompt() {
    return """
        You are PillarWise AI. Use chart symbolism as a reflective compatibility lens.
        Do not claim fate, soulmate certainty, breakup certainty, marriage timing, medical, legal, or financial advice.
        Return JSON only.
        """;
  }

  private static int score(Object value, int fallback) {
    int score = value instanceof Number number ? number.intValue() : fallback;
    return Math.max(0, Math.min(100, score));
  }

  private static List<String> stringList(Object value, int max) {
    if (!(value instanceof List<?> list)) {
      return List.of();
    }
    return list.stream()
        .filter(String.class::isInstance)
        .map(String.class::cast)
        .map(String::trim)
        .filter(item -> !item.isBlank())
        .limit(max)
        .toList();
  }

  private static String text(Object value, String fallback) {
    return value instanceof String text && !text.isBlank() ? text.trim() : fallback;
  }

  public void delete(String userId, String relationshipId) {
    jdbcTemplate.update("DELETE FROM relationship_profiles WHERE id = ? AND user_id = ?", relationshipId, userId);
  }

  private static Map<String, Object> compatibility(Map<String, Object> relationship, BaziChart userChart, BaziChart targetChart) {
    int score = 70;
    if (userChart.dayStem().equals(targetChart.dayStem())) score += 3;
    if (userChart.dayBranch().equals(targetChart.dayBranch())) score -= 3;
    if (userChart.dayMaster().split(" ")[1].equals(targetChart.dayMaster().split(" ")[1])) score += 5;
    if ("unknown".equals(userChart.confidence().get("birthTime")) || "unknown".equals(targetChart.confidence().get("birthTime"))) score -= 5;
    score = Math.max(45, Math.min(95, score));
    return Map.of(
        "patternName", score >= 80 ? "The Magnetic Mirror" : "The Growth Dynamic",
        "chemistryScore", score,
        "communicationScore", Math.max(45, Math.min(95, score - 4)),
        "stabilityScore", Math.max(45, Math.min(95, score + 2)),
        "communicationSnapshot", "You seek clarity quickly; " + relationship.get("targetName") + " may need more private processing before responding.",
        "mainStrength", "This dynamic can create deep recognition when both people name what they need directly.",
        "mainTension", "Different recovery speeds after conflict.",
        "advicePrompts", List.of("What helps you feel safe after conflict?", "What signal means you need space rather than distance?")
    );
  }

  private static Map<String, Object> fullRelationship(Map<String, Object> preview) {
    return Map.of(
        "overview", preview.get("mainStrength"),
        "emotionalChemistry", "The connection may feel strongest when honesty is paired with enough room to process.",
        "communicationStyle", preview.get("communicationSnapshot"),
        "conflictPattern", preview.get("mainTension"),
        "trustAndSecurity", "Trust grows through consistent repair, not mind-reading.",
        "conversationPrompts", preview.get("advicePrompts"),
        "practicalAdvice", "Choose one repair ritual before the next difficult conversation."
    );
  }

  private static Map<String, Object> relationship(String id, String targetName, String relationshipType, String targetBirthProfileId, String createdAt) {
    Map<String, Object> map = new LinkedHashMap<>();
    map.put("id", id);
    map.put("targetName", targetName);
    map.put("relationshipType", relationshipType);
    map.put("targetBirthProfileId", targetBirthProfileId);
    map.put("createdAt", createdAt);
    return map;
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }
}
