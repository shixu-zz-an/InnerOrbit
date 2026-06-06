package com.pillarwise.today;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.BaziRepository;
import com.pillarwise.bazi.InsightMapper;
import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
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
  private final BaziRepository charts;
  private final InsightMapper insightMapper;

  public TodayService(
      JdbcTemplate jdbcTemplate,
      Jsons jsons,
      Clock clock,
      BirthProfileRepository birthProfiles,
      BaziRepository charts,
      InsightMapper insightMapper
  ) {
    this.jdbcTemplate = jdbcTemplate;
    this.jsons = jsons;
    this.clock = clock;
    this.birthProfiles = birthProfiles;
    this.charts = charts;
    this.insightMapper = insightMapper;
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
    BaziChart chart = charts.findLatestByBirthProfileId(profile.id())
        .orElseThrow(() -> AppException.notFound("Chart was not found."));
    Map<String, Object> content = generate(date, insightMapper.map(chart), chart);
    String id = Ids.newId("day");
    jdbcTemplate.update(
        """
        INSERT INTO daily_insights(id, user_id, birth_profile_id, insight_date, content_json, prompt_version, model_version, created_at)
        VALUES (?, ?, ?, ?, ?, 'daily-v1.0.0', 'mock-v1', ?)
        """,
        id,
        userId,
        profile.id(),
        date.toString(),
        jsons.write(content),
        Instant.now(clock).toString()
    );
    content = new LinkedHashMap<>(content);
    content.put("id", id);
    return content;
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
}
