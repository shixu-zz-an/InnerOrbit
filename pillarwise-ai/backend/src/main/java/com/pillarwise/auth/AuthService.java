package com.pillarwise.auth;

import com.pillarwise.common.AppException;
import com.pillarwise.common.Ids;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.time.Clock;
import java.time.Instant;
import java.util.HexFormat;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class AuthService {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;

  public AuthService(JdbcTemplate jdbcTemplate, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
  }

  public DevSession devSession() {
    Instant now = Instant.now(clock);
    List<Map<String, Object>> users = jdbcTemplate.queryForList(
        "SELECT id, display_name FROM users WHERE deleted_at IS NULL ORDER BY created_at LIMIT 1"
    );
    boolean isNewUser = users.isEmpty();
    String userId;
    if (isNewUser) {
      userId = Ids.newId("usr");
      jdbcTemplate.update(
          "INSERT INTO users(id, email, display_name, locale, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?)",
          userId,
          null,
          "You",
          "en-US",
          now.toString(),
          now.toString()
      );
    } else {
      userId = users.getFirst().get("id").toString();
    }
    String token = "dev_" + userId + "_" + Ids.newId("tok").substring(4);
    String expiresAt = "2099-01-01T00:00:00Z";
    jdbcTemplate.update(
        "INSERT INTO auth_sessions(id, user_id, token_hash, provider, expires_at, created_at) VALUES (?, ?, ?, ?, ?, ?)",
        Ids.newId("ses"),
        userId,
        hash(token),
        "dev",
        expiresAt,
        now.toString()
    );
    return new DevSession(userId, token, expiresAt, isNewUser);
  }

  public CurrentUser requireCurrentUser(String authorizationHeader) {
    if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
      throw AppException.unauthorized();
    }
    String token = authorizationHeader.substring("Bearer ".length()).trim();
    if (token.isBlank()) {
      throw AppException.unauthorized();
    }
    List<CurrentUser> users = jdbcTemplate.query("""
        SELECT u.id, u.locale, u.display_name
        FROM auth_sessions s
        JOIN users u ON u.id = s.user_id
        WHERE s.token_hash = ? AND s.expires_at > ? AND u.deleted_at IS NULL
        LIMIT 1
        """,
        (rs, rowNum) -> new CurrentUser(
            rs.getString("id"),
            rs.getString("locale"),
            rs.getString("display_name")
        ),
        hash(token),
        Instant.now(clock).toString()
    );
    if (users.isEmpty()) {
      throw AppException.unauthorized();
    }
    return users.getFirst();
  }

  public void clearSessions(String userId) {
    jdbcTemplate.update("DELETE FROM auth_sessions WHERE user_id = ?", userId);
  }

  private static String hash(String token) {
    try {
      MessageDigest digest = MessageDigest.getInstance("SHA-256");
      return HexFormat.of().formatHex(digest.digest(token.getBytes(StandardCharsets.UTF_8)));
    } catch (Exception ex) {
      throw new IllegalStateException("Unable to hash token", ex);
    }
  }

  public record DevSession(
      String userId,
      String accessToken,
      String expiresAt,
      boolean isNewUser
  ) {}
}
