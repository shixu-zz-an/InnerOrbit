package com.pillarwise.relationship;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
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

  public RelationshipService(
      JdbcTemplate jdbcTemplate,
      Clock clock,
      BirthProfileService birthProfileService,
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      ReportRepository reports,
      EntitlementService entitlementService
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
    this.birthProfileService = birthProfileService;
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.reports = reports;
    this.entitlementService = entitlementService;
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
    Map<String, Object> preview = compatibility(relationship, userChart, targetChart);
    boolean full = "full".equalsIgnoreCase(request.mode()) || entitlementService.premiumActive(userId);
    if ("full".equalsIgnoreCase(request.mode()) && !entitlementService.premiumActive(userId)) {
      throw AppException.entitlement("relationship_full");
    }
    Map<String, Object> fullReport = full ? fullRelationship(preview) : null;
    Report report = reports.save(userId, userProfile.id(), relationshipId, "relationship", preview, fullReport, true, full);
    return Map.of(
        "relationshipId", relationshipId,
        "reportId", report.id(),
        "preview", preview,
        "fullReport", fullReport == null ? Map.of() : fullReport,
        "unlocked", report.unlocked()
    );
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
