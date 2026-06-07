package com.pillarwise.ai;

import org.springframework.stereotype.Component;

@Component
public class LocalAiProvider implements AiProvider {
  @Override
  public boolean supports(String provider) {
    return "local".equalsIgnoreCase(provider)
        || "mock".equalsIgnoreCase(provider)
        || "offline".equalsIgnoreCase(provider);
  }

  @Override
  public AiCompletion complete(AiRequest request) {
    long started = System.nanoTime();
    String content = contentFor(request);
    long latencyMs = Math.max(1, (System.nanoTime() - started) / 1_000_000);
    return new AiCompletion(
        "local",
        "local-static",
        content,
        estimateTokens(request.systemPrompt()) + request.messages().stream()
            .mapToInt(message -> estimateTokens(message.content()))
            .sum(),
        estimateTokens(content),
        0,
        latencyMs
    );
  }

  private String contentFor(AiRequest request) {
    String prompt = request.messages().isEmpty() ? "" : request.messages().getLast().content();
    String lower = prompt.toLowerCase();
    if (lower.contains("\"currentquestion\"") || lower.contains("return json with this schema")) {
      if (lower.contains("\"locale\":\"zh\"") || lower.contains("\"locale\": \"zh\"")) {
        return """
            {
              "headline": "先从一个真实下一步开始",
              "summary": "这个模式更适合用一个清晰行动来处理，而不是一次性解决整个局面。",
              "sections": [
                {
                  "title": "正在发生什么",
                  "body": "你可能在信息还不够完整时，已经提前承担了太多结果。"
                },
                {
                  "title": "注意力放在哪里",
                  "body": "先找出那个能恢复清晰、稳定或直接沟通的小决定。"
                }
              ],
              "practicalStep": "写下一句话，说明今天可以完成的那个具体行动。",
              "reflectionQuestion": "这件事里，现阶段真正属于你可以行动的部分是什么？"
            }
            """;
      }
      return """
          {
            "headline": "Start with the next honest step",
            "summary": "This pattern is best handled by making one clear move instead of trying to solve the whole situation at once.",
            "sections": [
              {
                "title": "What may be active",
                "body": "You may be carrying too much of the outcome before the situation has enough real information."
              },
              {
                "title": "Where to place attention",
                "body": "Look for the smallest decision that restores clarity, steadiness, or a direct conversation."
              }
            ],
            "practicalStep": "Write one sentence that names the next action you can complete today.",
            "reflectionQuestion": "What part of this situation is actually yours to act on now?"
          }
          """;
    }
    return "{}";
  }

  private static int estimateTokens(String text) {
    if (text == null || text.isBlank()) {
      return 0;
    }
    return Math.max(1, text.length() / 4);
  }
}
