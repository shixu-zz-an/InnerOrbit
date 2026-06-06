package com.pillarwise;

import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import com.pillarwise.config.AppProperties;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {
  private final JdbcTemplate jdbcTemplate;
  private final AppProperties properties;
  private final ResponseFactory responses;

  public HealthController(JdbcTemplate jdbcTemplate, AppProperties properties, ResponseFactory responses) {
    this.jdbcTemplate = jdbcTemplate;
    this.properties = properties;
    this.responses = responses;
  }

  @GetMapping("/health")
  ApiResponse<Map<String, Object>> health(HttpServletRequest request) {
    jdbcTemplate.queryForObject("SELECT 1", Integer.class);
    return responses.ok(Map.of("status", "ok", "db", "ok", "profile", properties.profile()), request);
  }
}
