package com.pillarwise.bazi;

import com.pillarwise.common.Jsons;
import java.time.Clock;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class BaziRepository {
  private final JdbcTemplate jdbcTemplate;
  private final Jsons jsons;
  private final Clock clock;

  public BaziRepository(JdbcTemplate jdbcTemplate, Jsons jsons, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.jsons = jsons;
    this.clock = clock;
  }

  public void save(BaziChart chart) {
    jdbcTemplate.update(
        """
        INSERT INTO bazi_charts(
          id, birth_profile_id, calc_version, year_stem, year_branch, month_stem, month_branch,
          day_stem, day_branch, hour_stem, hour_branch, day_master, element_distribution_json,
          ten_gods_json, hidden_stems_json, luck_cycles_json, annual_cycles_json, confidence_json, created_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
        chart.id(),
        chart.birthProfileId(),
        chart.calcVersion(),
        chart.yearStem(),
        chart.yearBranch(),
        chart.monthStem(),
        chart.monthBranch(),
        chart.dayStem(),
        chart.dayBranch(),
        chart.hourStem(),
        chart.hourBranch(),
        chart.dayMaster(),
        jsons.write(chart.elementDistribution()),
        jsons.write(chart.tenGods()),
        jsons.write(chart.hiddenStems()),
        jsons.write(chart.luckCycles()),
        jsons.write(chart.annualCycles()),
        jsons.write(chart.confidence()),
        Instant.now(clock).toString()
    );
  }

  public Optional<BaziChart> findLatestByBirthProfileId(String birthProfileId) {
    List<BaziChart> charts = jdbcTemplate.query(
        "SELECT * FROM bazi_charts WHERE birth_profile_id = ? ORDER BY created_at DESC LIMIT 1",
        (rs, rowNum) -> new BaziChart(
            rs.getString("id"),
            rs.getString("birth_profile_id"),
            rs.getString("calc_version"),
            rs.getString("year_stem"),
            rs.getString("year_branch"),
            rs.getString("month_stem"),
            rs.getString("month_branch"),
            rs.getString("day_stem"),
            rs.getString("day_branch"),
            rs.getString("hour_stem"),
            rs.getString("hour_branch"),
            rs.getString("day_master"),
            jsons.readMap(rs.getString("element_distribution_json")),
            jsons.readMap(rs.getString("ten_gods_json")),
            jsons.readMap(rs.getString("hidden_stems_json")),
            jsons.readMap(rs.getString("luck_cycles_json")),
            jsons.readMap(rs.getString("annual_cycles_json")),
            jsons.readMap(rs.getString("confidence_json"))
        ),
        birthProfileId
    );
    return charts.stream().findFirst();
  }
}
