package com.pillarwise.journal;

import com.pillarwise.auth.CurrentUser;
import com.pillarwise.common.ApiResponse;
import com.pillarwise.common.ResponseFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/journal")
public class JournalController {
  private final JournalService journalService;
  private final ResponseFactory responses;

  public JournalController(JournalService journalService, ResponseFactory responses) {
    this.journalService = journalService;
    this.responses = responses;
  }

  @GetMapping
  ApiResponse<Map<String, Object>> list(CurrentUser user, HttpServletRequest request) {
    return responses.ok(Map.of("entries", journalService.list(user.id())), request);
  }

  @PostMapping
  ApiResponse<Map<String, Object>> create(CurrentUser user, @RequestBody JournalEntryRequest body, HttpServletRequest request) {
    return responses.ok(journalService.create(user.id(), body), request);
  }

  @PutMapping("/{id}")
  ApiResponse<Map<String, Object>> update(CurrentUser user, @PathVariable String id, @RequestBody JournalEntryRequest body, HttpServletRequest request) {
    return responses.ok(journalService.update(user.id(), id, body), request);
  }

  @DeleteMapping("/{id}")
  ApiResponse<Map<String, Object>> delete(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    journalService.delete(user.id(), id);
    return responses.ok(Map.of("deleted", true), request);
  }
}
