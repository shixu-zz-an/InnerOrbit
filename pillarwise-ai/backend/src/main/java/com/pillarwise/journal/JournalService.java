package com.pillarwise.journal;

import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import java.time.Clock;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class JournalService {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;

  public JournalService(JdbcTemplate jdbcTemplate, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
  }

  public Map<String, Object> create(String userId, JournalEntryRequest body) {
    if (body.content() == null || body.content().isBlank()) {
      throw AppException.validation("Reflection content is required.", Map.of("content", "Write a quick reflection first."));
    }
    String id = Ids.newId("jnl");
    Instant now = Instant.now(clock);
    jdbcTemplate.update(
        """
        INSERT INTO journal_entries(id, user_id, source_type, source_id, prompt, content, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """,
        id,
        userId,
        blankDefault(body.sourceType(), "manual"),
        blankToNull(body.sourceId()),
        blankToNull(body.prompt()),
        body.content().trim(),
        now.toString(),
        now.toString()
    );
    return get(userId, id);
  }

  public Map<String, Object> update(String userId, String id, JournalEntryRequest body) {
    if (body.content() == null || body.content().isBlank()) {
      throw AppException.validation("Reflection content is required.", Map.of("content", "Write a quick reflection first."));
    }
    jdbcTemplate.update(
        "UPDATE journal_entries SET prompt = ?, content = ?, updated_at = ? WHERE id = ? AND user_id = ?",
        blankToNull(body.prompt()),
        body.content().trim(),
        Instant.now(clock).toString(),
        id,
        userId
    );
    return get(userId, id);
  }

  public List<Map<String, Object>> list(String userId) {
    return jdbcTemplate.query(
        "SELECT * FROM journal_entries WHERE user_id = ? ORDER BY created_at DESC LIMIT 100",
        (rs, rowNum) -> entry(
            rs.getString("id"),
            rs.getString("source_type"),
            rs.getString("source_id"),
            rs.getString("prompt"),
            rs.getString("content"),
            rs.getString("created_at"),
            rs.getString("updated_at")
        ),
        userId
    );
  }

  public Map<String, Object> get(String userId, String id) {
    return jdbcTemplate.query(
        "SELECT * FROM journal_entries WHERE id = ? AND user_id = ?",
        (rs, rowNum) -> entry(
            rs.getString("id"),
            rs.getString("source_type"),
            rs.getString("source_id"),
            rs.getString("prompt"),
            rs.getString("content"),
            rs.getString("created_at"),
            rs.getString("updated_at")
        ),
        id,
        userId
    ).stream().findFirst().orElseThrow(() -> AppException.notFound("Journal entry was not found."));
  }

  public void delete(String userId, String id) {
    jdbcTemplate.update("DELETE FROM journal_entries WHERE id = ? AND user_id = ?", id, userId);
  }

  private static Map<String, Object> entry(String id, String sourceType, String sourceId, String prompt, String content, String createdAt, String updatedAt) {
    Map<String, Object> map = new LinkedHashMap<>();
    map.put("id", id);
    map.put("sourceType", sourceType);
    map.put("sourceId", sourceId);
    map.put("prompt", prompt);
    map.put("content", content);
    map.put("createdAt", createdAt);
    map.put("updatedAt", updatedAt);
    return map;
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }

  private static String blankToNull(String value) {
    return value == null || value.isBlank() ? null : value.trim();
  }
}
