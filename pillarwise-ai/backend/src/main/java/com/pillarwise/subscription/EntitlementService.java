package com.pillarwise.subscription;

import com.pillarwise.common.Ids;
import java.time.Clock;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Map;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class EntitlementService {
  private final JdbcTemplate jdbcTemplate;
  private final Clock clock;

  public EntitlementService(JdbcTemplate jdbcTemplate, Clock clock) {
    this.jdbcTemplate = jdbcTemplate;
    this.clock = clock;
  }

  public Entitlement current(String userId) {
    Instant now = Instant.now(clock);
    List<Map<String, Object>> rows = jdbcTemplate.queryForList(
        """
        SELECT product_id, expires_at
        FROM subscriptions
        WHERE user_id = ? AND status = 'active' AND product_id LIKE 'premium_%'
          AND (expires_at IS NULL OR expires_at > ?)
        ORDER BY updated_at DESC
        LIMIT 1
        """,
        userId,
        now.toString()
    );
    boolean premium = !rows.isEmpty();
    String plan = premium ? rows.getFirst().get("product_id").toString() : "free";
    String expiresAt = premium && rows.getFirst().get("expires_at") != null ? rows.getFirst().get("expires_at").toString() : null;
    return new Entitlement(
        premium,
        plan,
        expiresAt,
        premium,
        premium,
        premium
    );
  }

  public Entitlement activateLocal(String userId, String productId) {
    Instant now = Instant.now(clock);
    Instant expiresAt = productId != null && productId.contains("monthly")
        ? now.plus(30, ChronoUnit.DAYS)
        : now.plus(365, ChronoUnit.DAYS);
    jdbcTemplate.update(
        """
        INSERT INTO subscriptions(id, user_id, store, product_id, status, expires_at, original_transaction_id, created_at, updated_at)
        VALUES (?, ?, 'local', ?, 'active', ?, ?, ?, ?)
        """,
        Ids.newId("sub"),
        userId,
        productId == null || productId.isBlank() ? "premium_annual" : productId,
        expiresAt.toString(),
        Ids.newId("txn"),
        now.toString(),
        now.toString()
    );
    return current(userId);
  }

  public boolean premiumActive(String userId) {
    return current(userId).premiumActive();
  }

  public record Entitlement(
      boolean premiumActive,
      String plan,
      String expiresAt,
      boolean fullBlueprint,
      boolean aiUnlimited,
      boolean relationshipReportsIncluded
  ) {
    public Map<String, Object> toMap() {
      return Map.of(
          "premiumActive", premiumActive,
          "plan", plan,
          "expiresAt", expiresAt == null ? "" : expiresAt,
          "features", Map.of(
              "aiUnlimited", aiUnlimited,
              "fullBlueprint", fullBlueprint,
              "relationshipReportsIncluded", relationshipReportsIncluded
          )
      );
    }
  }
}
