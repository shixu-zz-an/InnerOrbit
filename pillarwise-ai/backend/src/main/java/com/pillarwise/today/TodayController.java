package com.pillarwise.today;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/today")
public class TodayController {
  private final TodayService todayService;
  private final ResponseFactory responses;

  public TodayController(TodayService todayService, ResponseFactory responses) {
    this.todayService = todayService;
    this.responses = responses;
  }

  @GetMapping
  ApiResponse<Map<String, Object>> today(
      CurrentUser user,
      @RequestParam(required = false) String birthProfileId,
      @RequestParam(required = false) String date,
      HttpServletRequest request
  ) {
    return responses.ok(todayService.today(user.id(), birthProfileId, date), request);
  }
}
