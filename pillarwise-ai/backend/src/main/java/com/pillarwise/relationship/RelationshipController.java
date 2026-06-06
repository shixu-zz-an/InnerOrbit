package com.pillarwise.relationship;

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
@RequestMapping("/api/v1/relationships")
public class RelationshipController {
  private final RelationshipService relationshipService;
  private final ResponseFactory responses;

  public RelationshipController(RelationshipService relationshipService, ResponseFactory responses) {
    this.relationshipService = relationshipService;
    this.responses = responses;
  }

  @GetMapping
  ApiResponse<Map<String, Object>> list(CurrentUser user, HttpServletRequest request) {
    return responses.ok(Map.of("relationships", relationshipService.list(user.id())), request);
  }

  @PostMapping
  ApiResponse<Map<String, Object>> create(CurrentUser user, @RequestBody RelationshipRequest body, HttpServletRequest request) {
    return responses.ok(relationshipService.create(user.id(), body), request);
  }

  @PostMapping("/{id}/report")
  ApiResponse<Map<String, Object>> report(CurrentUser user, @PathVariable String id, @RequestBody RelationshipReportRequest body, HttpServletRequest request) {
    return responses.ok(relationshipService.report(user.id(), id, body), request);
  }

  @DeleteMapping("/{id}")
  ApiResponse<Map<String, Object>> delete(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    relationshipService.delete(user.id(), id);
    return responses.ok(Map.of("deleted", true), request);
  }
}
