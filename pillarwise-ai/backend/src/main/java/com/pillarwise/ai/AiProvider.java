package com.pillarwise.ai;

public interface AiProvider {
  boolean supports(String provider);

  AiCompletion complete(AiRequest request);
}
