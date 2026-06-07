package com.pillarwise.ai;

public record AiCompletion(
    String provider,
    String model,
    String content,
    int inputTokens,
    int outputTokens,
    double costUsd,
    long latencyMs
) {}
