package com.pillarwise.analytics;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.time.Clock;
import java.time.Instant;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/analytics")
public class AnalyticsController {
  private final JdbcTemplate jdbcTemplate;
  private final Jsons jsons;
  private final Clock clock;
  private final ResponseFactory responses;

  public AnalyticsController(JdbcTemplate jdbcTemplate, Jsons jsons, Clock clock, ResponseFactory responses) {
    this.jdbcTemplate = jdbcTemplate;
    this.jsons = jsons;
    this.clock = clock;
    this.responses = responses;
  }

  @PostMapping("/events")
  ApiResponse<Map<String, Object>> track(CurrentUser user, @RequestBody AnalyticsEventRequest body, HttpServletRequest request) {
    String eventName = body.eventName() == null || body.eventName().isBlank() ? "unknown_event" : body.eventName();
    jdbcTemplate.update(
        "INSERT INTO analytics_events(id, user_id, event_name, properties_json, created_at) VALUES (?, ?, ?, ?, ?)",
        Ids.newId("evt"),
        user.id(),
        eventName,
        jsons.write(body.properties() == null ? Map.of() : body.properties()),
        Instant.now(clock).toString()
    );
    return responses.ok(Map.of("tracked", true), request);
  }
}
