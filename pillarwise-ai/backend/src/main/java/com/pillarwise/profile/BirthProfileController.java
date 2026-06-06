package com.pillarwise.profile;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/birth-profiles")
public class BirthProfileController {
  private final BirthProfileService birthProfileService;
  private final ResponseFactory responses;

  public BirthProfileController(BirthProfileService birthProfileService, ResponseFactory responses) {
    this.birthProfileService = birthProfileService;
    this.responses = responses;
  }

  @PostMapping
  ApiResponse<Map<String, Object>> create(
      CurrentUser user,
      @RequestBody BirthProfileRequest body,
      HttpServletRequest request
  ) {
    BirthProfileService.CreateBirthProfileResult result = birthProfileService.create(user.id(), body);
    return responses.ok(BirthProfileDtos.createResponse(result.profile(), result.chart(), result.insight()), request);
  }

  @GetMapping("/primary")
  ApiResponse<Map<String, Object>> primary(CurrentUser user, HttpServletRequest request) {
    return responses.ok(BirthProfileDtos.summary(birthProfileService.primary(user.id())), request);
  }

  @DeleteMapping("/{id}")
  ApiResponse<Map<String, Object>> delete(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    birthProfileService.delete(user.id(), id);
    return responses.ok(Map.of("deleted", true), request);
  }
}
