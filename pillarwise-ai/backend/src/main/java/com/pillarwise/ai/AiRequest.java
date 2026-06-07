package com.pillarwise.ai;

import java.util.List;

public record AiRequest(
    String systemPrompt,
    List<AiMessage> messages,
    String responseFormat,
    double temperature,
    Integer maxTokens
) {}
