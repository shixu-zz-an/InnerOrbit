package com.pillarwise.ai;

import java.util.Map;

public record AiMessageRequest(
    String conversationId,
    String birthProfileId,
    String message,
    Map<String, Object> context
) {}
