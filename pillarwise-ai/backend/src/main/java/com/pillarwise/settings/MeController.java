package com.pillarwise.settings;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/me")
public class MeController {
  private final MeService meService;
  private final ResponseFactory responses;

  public MeController(MeService meService, ResponseFactory responses) {
    this.meService = meService;
    this.responses = responses;
  }

  @GetMapping
  ApiResponse<Map<String, Object>> me(CurrentUser user, HttpServletRequest request) {
    return responses.ok(meService.me(user), request);
  }

  @GetMapping("/export")
  ApiResponse<Map<String, Object>> export(CurrentUser user, HttpServletRequest request) {
    return responses.ok(meService.export(user), request);
  }

  @DeleteMapping
  ApiResponse<Map<String, Object>> delete(CurrentUser user, @RequestBody DeleteAccountRequest body, HttpServletRequest request) {
    return responses.ok(meService.delete(user, body), request);
  }
}
