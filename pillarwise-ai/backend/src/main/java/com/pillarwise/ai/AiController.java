package com.pillarwise.ai;

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
@RequestMapping("/api/v1/ai")
public class AiController {
  private final AiService aiService;
  private final ResponseFactory responses;

  public AiController(AiService aiService, ResponseFactory responses) {
    this.aiService = aiService;
    this.responses = responses;
  }

  @PostMapping("/conversations")
  ApiResponse<Map<String, Object>> create(CurrentUser user, @RequestBody AiConversationRequest body, HttpServletRequest request) {
    return responses.ok(aiService.createConversation(user.id(), body), request);
  }

  @PostMapping("/messages")
  ApiResponse<Map<String, Object>> message(CurrentUser user, @RequestBody AiMessageRequest body, HttpServletRequest request) {
    return responses.ok(aiService.sendMessage(user.id(), body), request);
  }

  @GetMapping("/conversations/{id}")
  ApiResponse<Map<String, Object>> conversation(CurrentUser user, @PathVariable String id, HttpServletRequest request) {
    return responses.ok(aiService.conversation(user.id(), id), request);
  }
}
