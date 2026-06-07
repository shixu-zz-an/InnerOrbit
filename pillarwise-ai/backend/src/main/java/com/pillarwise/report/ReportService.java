package com.pillarwise.report;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziService;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.ai.StructuredAiGenerator;
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
  private final StructuredAiGenerator aiGenerator;

  public ReportService(
      BirthProfileRepository birthProfiles,
      BaziService baziService,
      InsightMapper insightMapper,
      ReportRepository reports,
      EntitlementService entitlementService,
      StructuredAiGenerator aiGenerator
  ) {
    this.birthProfiles = birthProfiles;
    this.baziService = baziService;
    this.insightMapper = insightMapper;
    this.reports = reports;
    this.entitlementService = entitlementService;
    this.aiGenerator = aiGenerator;
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
    Map<String, Object> preview = aiLifeBlueprint(profile, chart, insight, false)
        .orElseGet(() -> lifeBlueprintContent(insight, false));
    Map<String, Object> full = fullMode || premium
        ? aiLifeBlueprint(profile, chart, insight, true).orElseGet(() -> lifeBlueprintContent(insight, true))
        : null;
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

  private java.util.Optional<Map<String, Object>> aiLifeBlueprint(BirthProfile profile, BaziChart chart, InsightMapper.MappedInsight insight, boolean full) {
    Map<String, Object> context = Map.of(
        "profile", Map.of(
            "birthProfileId", profile.id(),
            "birthDate", profile.birthDate(),
            "birthTimePrecision", profile.birthTimePrecision(),
            "birthPlaceText", profile.birthPlaceText(),
            "timezone", profile.timezone()
        ),
        "chart", Map.of(
            "calcVersion", chart.calcVersion(),
            "dayMaster", chart.dayMaster(),
            "pillars", Map.of(
                "year", chart.yearStem() + " " + chart.yearBranch(),
                "month", chart.monthStem() + " " + chart.monthBranch(),
                "day", chart.dayStem() + " " + chart.dayBranch(),
                "hour", chart.hourStem() == null ? "unknown" : chart.hourStem() + " " + chart.hourBranch()
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
        "mode", full ? "full" : "preview"
    );
    String prompt = """
        Generate a PillarWise life blueprint as valid JSON only.
        Use BaZi as a reflective framework, never deterministic fate.
        Avoid medical, legal, investment, and guaranteed prediction claims.
        Context:
        %s

        Required JSON shape:
        {
          "coreArchetype": "string",
          "headline": "string",
          "summary": "string",
          "cards": [
            {
              "id": "string",
              "section": "string",
              "label": "string",
              "title": "string",
              "body": "string",
              "howItShowsUp": ["string"],
              "growthEdge": "string",
              "practicalStep": "string",
              "reflectionQuestion": "string",
              "locked": false
            }
          ],
          "sections": "same array as cards"
        }
        Include %d cards. For preview lock relationship/career depth if needed. For full set locked to false.
        """.formatted(aiGenerator.write(context), full ? 8 : 5);
    return aiGenerator.generate(systemPrompt(), prompt, 2200).flatMap(this::normalizeBlueprint);
  }

  @SuppressWarnings("unchecked")
  private java.util.Optional<Map<String, Object>> normalizeBlueprint(Map<String, Object> raw) {
    Object cardsValue = raw.get("cards") == null ? raw.get("sections") : raw.get("cards");
    if (!(cardsValue instanceof List<?> cards) || cards.isEmpty()) {
      return java.util.Optional.empty();
    }
    List<Map<String, Object>> normalized = new ArrayList<>();
    for (Object item : cards) {
      if (!(item instanceof Map<?, ?> map)) {
        return java.util.Optional.empty();
      }
      String id = text(map.get("id"), text(map.get("section"), "section_" + normalized.size()));
      String title = text(map.get("title"), "");
      String body = text(map.get("body"), "");
      if (title.isBlank() || body.isBlank()) {
        return java.util.Optional.empty();
      }
      normalized.add(section(
          id,
          text(map.get("label"), title),
          title,
          body,
          text(map.get("practicalStep"), "Choose one grounded next step."),
          Boolean.TRUE.equals(map.get("locked"))
      ));
    }
    return java.util.Optional.of(Map.of(
        "coreArchetype", text(raw.get("coreArchetype"), "Personal Blueprint"),
        "headline", text(raw.get("headline"), "A grounded pattern is ready to work with."),
        "summary", text(raw.get("summary"), "Use this reading as a practical reflection lens."),
        "cards", normalized,
        "sections", normalized
    ));
  }

  private static String systemPrompt() {
    return """
        You are PillarWise AI. Produce concise, emotionally mature app copy.
        Use the user's chart context as symbolism for self-reflection.
        Do not claim certainty, fate, diagnosis, wealth, death, marriage timing, or emergency advice.
        Return JSON only.
        """;
  }

  private static String text(Object value, String fallback) {
    return value instanceof String text && !text.isBlank() ? text.trim() : fallback;
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
