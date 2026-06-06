package com.pillarwise.auth;

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
@RequestMapping("/api/v1/auth")
public class AuthController {
  private final AuthService authService;
  private final ResponseFactory responses;

  public AuthController(AuthService authService, ResponseFactory responses) {
    this.authService = authService;
    this.responses = responses;
  }

  @GetMapping("/dev-session")
  ApiResponse<AuthService.DevSession> devSession(HttpServletRequest request) {
    return responses.ok(authService.devSession(), request);
  }

  @PostMapping("/apple")
  ApiResponse<Map<String, Object>> apple(@RequestBody Map<String, Object> ignored, HttpServletRequest request) {
    return responses.ok(
        Map.of(
            "configured", false,
            "message", "Apple Sign-In is not configured for the local flavor."
        ),
        request
    );
  }
}
