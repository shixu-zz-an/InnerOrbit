package com.pillarwise.config;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Clock;
import java.time.Instant;
import java.util.HexFormat;
import java.util.List;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.core.ConnectionCallback;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Component;

@Component
public class MigrationRunner implements ApplicationRunner {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;

  public MigrationRunner(JdbcTemplate jdbcTemplate, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
  }

  @Override
  public void run(ApplicationArguments args) throws Exception {
    jdbcTemplate.execute("""
        CREATE TABLE IF NOT EXISTS schema_migrations (
          version TEXT PRIMARY KEY,
          checksum TEXT NOT NULL,
          executed_at TEXT NOT NULL
        )
        """);
    Resource[] resources = new PathMatchingResourcePatternResolver()
        .getResources("classpath:/db/migration/*.sql");
    List<Resource> sorted = java.util.Arrays.stream(resources)
        .sorted((a, b) -> filename(a).compareTo(filename(b)))
        .toList();
    for (Resource resource : sorted) {
      String name = filename(resource);
      String version = name.contains("__") ? name.substring(0, name.indexOf("__")) : name;
      String sql = new String(resource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
      String checksum = checksum(sql);
      Integer count = jdbcTemplate.queryForObject(
          "SELECT COUNT(*) FROM schema_migrations WHERE version = ?",
          Integer.class,
          version
      );
      if (count != null && count > 0) {
        continue;
      }
      jdbcTemplate.execute((ConnectionCallback<Void>) connection -> {
        ScriptUtils.executeSqlScript(connection, resource);
        return null;
      });
      jdbcTemplate.update(
          "INSERT INTO schema_migrations(version, checksum, executed_at) VALUES (?, ?, ?)",
          version,
          checksum,
          Instant.now(clock).toString()
      );
    }
  }

  private static String filename(Resource resource) {
    String filename = resource.getFilename();
    return filename == null ? "" : filename;
  }

  private static String checksum(String text) throws Exception {
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
    return HexFormat.of().formatHex(digest.digest(text.getBytes(StandardCharsets.UTF_8)));
  }
}
