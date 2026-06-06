package com.pillarwise.bazi;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/bazi")
public class BaziController {
  private final BaziService baziService;
  private final ResponseFactory responses;

  public BaziController(BaziService baziService, ResponseFactory responses) {
    this.baziService = baziService;
    this.responses = responses;
  }

  @GetMapping("/charts/{birthProfileId}")
  ApiResponse<Map<String, Object>> chart(CurrentUser user, @PathVariable String birthProfileId, HttpServletRequest request) {
    return responses.ok(BaziDtos.chart(baziService.chartForUser(user.id(), birthProfileId)), request);
  }
}
