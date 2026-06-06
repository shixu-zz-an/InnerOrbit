package com.pillarwise.subscription;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/subscriptions")
public class SubscriptionController {
  private final EntitlementService entitlementService;
  private final ResponseFactory responses;

  public SubscriptionController(EntitlementService entitlementService, ResponseFactory responses) {
    this.entitlementService = entitlementService;
    this.responses = responses;
  }

  @GetMapping("/entitlement")
  ApiResponse<Map<String, Object>> entitlement(CurrentUser user, HttpServletRequest request) {
    return responses.ok(entitlementService.current(user.id()).toMap(), request);
  }

  @PostMapping("/local/activate")
  ApiResponse<Map<String, Object>> activate(CurrentUser user, @RequestBody Map<String, Object> body, HttpServletRequest request) {
    String productId = body.getOrDefault("productId", "premium_annual").toString();
    return responses.ok(entitlementService.activateLocal(user.id(), productId).toMap(), request);
  }
}
