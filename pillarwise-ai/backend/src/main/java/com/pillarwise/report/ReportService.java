package com.pillarwise.report;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.common.AppException;
import com.pillarwise.profile.BirthProfile;
import com.pillarwise.profile.BirthProfileRepository;
import com.pillarwise.subscription.EntitlementService;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;

@Service
public class ReportService {
  private final BirthProfileRepository birthProfiles;
  private final BaziService baziService;
  private final InsightMapper insightMapper;
  private final ReportRepository reports;
  private final EntitlementService entitlementService;

  public ReportService(
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      InsightMapper insightMapper,
      ReportRepository reports,
      EntitlementService entitlementService
  ) {
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.insightMapper = insightMapper;
    this.reports = reports;
    this.entitlementService = entitlementService;
  }

  public Report generateLifeBlueprint(String userId, LifeBlueprintRequest request) {
    String profileId = request.birthProfileId();
    if (profileId == null || profileId.isBlank()) {
      profileId = birthProfiles.findPrimaryByUser(userId)
          .orElseThrow(() -> AppException.notFound("Create your blueprint first."))
          .id();
    }
    BirthProfile profile = birthProfiles.findByIdForUser(profileId, userId)
        .orElseThrow(() -> AppException.notFound("Birth profile was not found."));
    BaziChart chart = baziService.chartForProfile(profile);
    InsightMapper.MappedInsight insight = insightMapper.map(chart);
    boolean fullMode = "full".equalsIgnoreCase(request.mode());
    boolean premium = entitlementService.premiumActive(userId);
    if (fullMode && !premium) {
      throw AppException.entitlement("life_blueprint_full");
    }
    Map<String, Object> preview = lifeBlueprintContent(insight, false);
    Map<String, Object> full = fullMode || premium ? lifeBlueprintContent(insight, true) : null;
    return reports.save(userId, profile.id(), null, "life_blueprint", preview, full, true, full != null);
  }

  public Report get(String userId, String reportId) {
    return reports.findByIdForUser(reportId, userId).orElseThrow(() -> AppException.notFound("Report was not found."));
  }

  public List<Report> list(String userId) {
    return reports.listByUser(userId);
  }

  public Report unlockLocal(String userId, String reportId) {
    return reports.unlockLocal(reportId, userId);
  }

  public Map<String, Object> lifeBlueprintContent(InsightMapper.MappedInsight insight, boolean full) {
    List<Map<String, Object>> sections = new ArrayList<>();
    sections.add(section("core", "Core Pattern", "Built for steadiness", headlineBody(insight), insight.strengths().getFirst(), false));
    sections.add(section("hidden_strength", "Hidden Strength", "Your quiet advantage", insight.strengths().get(1), "Let this strength be visible before it is perfect.", false));
    sections.add(section("blind_spot", "Blind Spot", "Where growth gets heavy", insight.blindSpots().getFirst(), "Notice when control is trying to create safety.", false));
    sections.add(section("relationship", "Relationship", "How connection tends to work", insight.relationshipPattern(), "Ask for one clear signal instead of reading between every line.", !full));
    sections.add(section("reflection", "Reflection", "A useful question", "Where are you managing something that needs trust?", "Write one sentence before taking action.", false));
    if (full) {
      sections.add(section("career", "Career", "Natural work style", insight.careerStyle(), "Choose the system you can improve for a full season.", false));
      sections.add(section("money", "Money", "Stability and growth", insight.moneyStyle(), "Give every goal a visible container.", false));
      sections.add(section("growth", "Growth", "Your next practice", insight.currentPhase(), "Let one low-risk situation stay unresolved for a day.", false));
      sections.add(section("timeline", "Timeline", "12-month focus", "The next year favors clearer boundaries, cleaner commitments, and fewer half-started plans.", "Close one loop before opening the next.", false));
      sections.add(section("emotional", "Emotional Pattern", "What steadies you", "You return to yourself when expectations are concrete and care is consistent.", "Name the expectation before you carry it.", false));
    }
    return Map.of(
        "coreArchetype", insight.coreArchetype(),
        "headline", headlineBody(insight),
        "summary", "Your blueprint points to a person who turns uncertainty into structure and makes life feel more workable.",
        "cards", sections,
        "sections", sections
    );
  }

  private static String headlineBody(InsightMapper.MappedInsight insight) {
    return insight.strengths().getFirst().contains("stability")
        ? "You create steadiness where others feel scattered."
        : "You notice the pattern beneath the surface and turn it into direction.";
  }

  private static Map<String, Object> section(String id, String label, String title, String body, String step, boolean locked) {
    return Map.of(
        "id", id,
        "section", id,
        "label", label,
        "title", title,
        "body", body,
        "howItShowsUp", List.of(body),
        "growthEdge", locked ? "Unlock the full reading to explore this section." : "This pattern is most useful when it becomes a choice, not a rule.",
        "practicalStep", step,
        "reflectionQuestion", "What would change if you trusted this pattern without letting it define you?",
        "locked", locked
    );
  }
}
