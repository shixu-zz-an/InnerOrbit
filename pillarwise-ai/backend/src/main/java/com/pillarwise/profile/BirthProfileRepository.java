package com.pillarwise.profile;

import com.pillarwise.common.Ids;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

@Repository
public class BirthProfileRepository {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;

  private final RowMapper<BirthProfile> mapper = (rs, rowNum) -> new BirthProfile(
      rs.getString("id"),
      rs.getString("user_id"),
      rs.getString("name"),
      rs.getString("birth_date"),
      rs.getString("birth_time"),
      rs.getString("birth_time_precision"),
      rs.getString("birth_place_text"),
      (Double) rs.getObject("latitude"),
      (Double) rs.getObject("longitude"),
      rs.getString("timezone"),
      rs.getString("sex_for_traditional_cycle"),
      rs.getInt("true_solar_time_enabled") == 1,
      rs.getInt("is_primary") == 1
  );

  public BirthProfileRepository(JdbcTemplate jdbcTemplate, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
  }

  public BirthProfile insert(String userId, BirthProfileRequest request, boolean primary) {
    Instant now = Instant.now(clock);
    if (primary) {
      jdbcTemplate.update("UPDATE birth_profiles SET is_primary = 0, updated_at = ? WHERE user_id = ?", now.toString(), userId);
    }
    String id = Ids.newId("bp");
    boolean trueSolar = request.trueSolarTimeEnabled() == null || request.trueSolarTimeEnabled();
    jdbcTemplate.update(
        """
        INSERT INTO birth_profiles(
          id, user_id, name, birth_date, birth_time, birth_time_precision, birth_place_text, latitude,
          longitude, timezone, sex_for_traditional_cycle, true_solar_time_enabled, is_primary, created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        id,
        userId,
        blankDefault(request.name(), "Me"),
        request.birthDate(),
        blankToNull(request.birthTime()),
        request.birthTimePrecision(),
        request.birthPlaceText(),
        request.latitude(),
        request.longitude(),
        request.timezone(),
        blankToNull(request.sexForTraditionalCycle()),
        trueSolar ? 1 : 0,
        primary ? 1 : 0,
        now.toString(),
        now.toString()
    );
    return findByIdForUser(id, userId).orElseThrow();
  }

  public Optional<BirthProfile> findPrimaryByUser(String userId) {
    return jdbcTemplate.query(
        "SELECT * FROM birth_profiles WHERE user_id = ? AND is_primary = 1 ORDER BY created_at DESC LIMIT 1",
        mapper,
        userId
    ).stream().findFirst();
  }

  public List<BirthProfile> findAllByUser(String userId) {
    return jdbcTemplate.query("SELECT * FROM birth_profiles WHERE user_id = ? ORDER BY created_at DESC", mapper, userId);
  }

  public Optional<BirthProfile> findByIdForUser(String id, String userId) {
    return jdbcTemplate.query("SELECT * FROM birth_profiles WHERE id = ? AND user_id = ?", mapper, id, userId)
        .stream()
        .findFirst();
  }

  public void deleteForUser(String id, String userId) {
    jdbcTemplate.update("DELETE FROM birth_profiles WHERE id = ? AND user_id = ?", id, userId);
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }

  private static String blankToNull(String value) {
    return value == null || value.isBlank() ? null : value.trim();
  }
}
