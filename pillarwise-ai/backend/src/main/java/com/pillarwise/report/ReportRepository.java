package com.pillarwise.report;

import com.pillarwise.common.Ids;
import com.pillarwise.common.Jsons;
import com.pillarwise.config.AppProperties;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class ReportRepository {
  private final JdbcTemplate jdbcTemplate;
  private final Jsons jsons;
  private final Clock clock;
  private final AppProperties properties;

  public ReportRepository(JdbcTemplate jdbcTemplate, Jsons jsons, Clock clock, AppProperties properties) {
    this.jdbcTemplate = jdbcTemplate;
    this.jsons = jsons;
    this.clock = clock;
    this.properties = properties;
  }

  public Report save(
      String userId,
      String birthProfileId,
      String relationshipProfileId,
      String reportType,
      java.util.Map<String, Object> preview,
      java.util.Map<String, Object> full,
      boolean paidRequired,
      boolean unlocked
  ) {
    Instant now = Instant.now(clock);
    String id = Ids.newId("rpt");
    jdbcTemplate.update(
        """
        INSERT INTO reports(
          id, user_id, birth_profile_id, relationship_profile_id, report_type, status, free_preview_json,
          full_report_json, model_version, prompt_version, paid_required, unlocked, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, 'ready', ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        id,
        userId,
        birthProfileId,
        relationshipProfileId,
        reportType,
        jsons.write(preview),
        full == null ? null : jsons.write(full),
        modelVersion(),
        reportType + "-v1.0.0",
        paidRequired ? 1 : 0,
        unlocked ? 1 : 0,
        now.toString(),
        now.toString()
    );
    return findByIdForUser(id, userId).orElseThrow();
  }

  public Optional<Report> findByIdForUser(String id, String userId) {
    return jdbcTemplate.query("SELECT * FROM reports WHERE id = ? AND user_id = ?", mapper(), id, userId)
        .stream()
        .findFirst();
  }

  public List<Report> listByUser(String userId) {
    return jdbcTemplate.query("SELECT * FROM reports WHERE user_id = ? ORDER BY created_at DESC", mapper(), userId);
  }

  public Report unlockLocal(String id, String userId) {
    jdbcTemplate.update("UPDATE reports SET unlocked = 1, updated_at = ? WHERE id = ? AND user_id = ?", Instant.now(clock).toString(), id, userId);
    return findByIdForUser(id, userId).orElseThrow();
  }

  private RowMapper<Report> mapper() {
    return (rs, rowNum) -> new Report(
        rs.getString("id"),
        rs.getString("user_id"),
        rs.getString("birth_profile_id"),
        rs.getString("relationship_profile_id"),
        rs.getString("report_type"),
        rs.getString("status"),
        jsons.readMap(rs.getString("free_preview_json")),
        jsons.readMap(rs.getString("full_report_json")),
        rs.getString("model_version"),
        rs.getString("prompt_version"),
        rs.getInt("paid_required") == 1,
        rs.getInt("unlocked") == 1,
        rs.getString("created_at"),
        rs.getString("updated_at")
    );
  }

  private String modelVersion() {
    if (properties.ai() == null || properties.ai().model() == null || properties.ai().model().isBlank()) {
      return "qwen-plus";
    }
    return properties.ai().model();
  }
}
