package com.pillarwise.report;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/reports")
public class ReportController {
  private final ReportService reportService;
  private final ResponseFactory responses;

  public ReportController(ReportService reportService, ResponseFactory responses) {
    this.reportService = reportService;
    this.responses = responses;
  }

  @PostMapping("/life-blueprint")
  ApiResponse<Map<String, Object>> lifeBlueprint(
      CurrentUser user,
      @RequestBody LifeBlueprintRequest body,
      HttpServletRequest request
  ) {
    return responses.ok(ReportDtos.response(reportService.generateLifeBlueprint(user.id(), body)), request);
  }

  @GetMapping("/{id}")
  ApiResponse<Map<String, Object>> get(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    return responses.ok(ReportDtos.response(reportService.get(user.id(), id)), request);
  }

  @GetMapping
  ApiResponse<Map<String, Object>> list(CurrentUser user, HttpServletRequest request) {
    return responses.ok(Map.of("reports", reportService.list(user.id()).stream().map(ReportDtos::listItem).toList()), request);
  }

  @PostMapping("/{id}/unlock-local")
  ApiResponse<Map<String, Object>> unlock(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    return responses.ok(ReportDtos.response(reportService.unlockLocal(user.id(), id)), request);
  }
}
