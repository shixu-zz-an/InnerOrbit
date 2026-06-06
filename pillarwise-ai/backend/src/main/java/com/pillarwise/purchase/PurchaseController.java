package com.pillarwise.purchase;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.Ids;
import com.pillarwise.common.ResponseFactory;
import com.pillarwise.report.ReportDtos;
import com.pillarwise.report.ReportRepository;
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
@RequestMapping("/api/v1/purchases")
public class PurchaseController {
  private final JdbcTemplate jdbcTemplate;
  private final ReportRepository reports;
  private final Clock clock;
  private final ResponseFactory responses;

  public PurchaseController(JdbcTemplate jdbcTemplate, ReportRepository reports, Clock clock, ResponseFactory responses) {
    this.jdbcTemplate = jdbcTemplate;
    this.reports = reports;
    this.clock = clock;
    this.responses = responses;
  }

  @PostMapping("/local/unlock")
  ApiResponse<Map<String, Object>> unlock(CurrentUser user, @RequestBody PurchaseRequest body, HttpServletRequest request) {
    String productId = body.productId() == null || body.productId().isBlank() ? "relationship_deep" : body.productId();
    jdbcTemplate.update(
        "INSERT INTO purchases(id, user_id, product_id, report_id, store, status, transaction_id, created_at) VALUES (?, ?, ?, ?, 'local', 'completed', ?, ?)",
        Ids.newId("pur"),
        user.id(),
        productId,
        body.reportId(),
        Ids.newId("txn"),
        Instant.now(clock).toString()
    );
    Map<String, Object> result = body.reportId() == null || body.reportId().isBlank()
        ? Map.of("unlocked", true)
        : ReportDtos.response(reports.unlockLocal(body.reportId(), user.id()));
    return responses.ok(result, request);
  }
}
