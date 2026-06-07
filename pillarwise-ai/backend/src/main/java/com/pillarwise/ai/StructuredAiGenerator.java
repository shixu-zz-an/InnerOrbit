package com.pillarwise.ai;

import com.pillarwise.common.AppException;
import com.pillarwise.common.Jsons;
import com.pillarwise.config.AppProperties;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.stereotype.Service;

@Service
public class StructuredAiGenerator {
  private final Jsons jsons;
  private final AppProperties properties;
  private final List<AiProvider> providers;

  public StructuredAiGenerator(Jsons jsons, AppProperties properties, List<AiProvider> providers) {
    this.jsons = jsons;
    this.properties = properties;
    this.providers = providers;
  }

  public Optional<Map<String, Object>> generate(String systemPrompt, String userPrompt, int maxTokens) {
    try {
      AiCompletion completion = activeProvider().complete(new AiRequest(
          systemPrompt,
          List.of(new AiMessage("user", userPrompt)),
          "json_object",
          0.55,
          maxTokens
      ));
      return Optional.of(jsons.readMap(stripCodeFence(completion.content())));
    } catch (AppException ex) {
      if ("AI_UNAVAILABLE".equals(ex.code())) {
        return Optional.empty();
      }
      throw ex;
    } catch (RuntimeException ex) {
      return Optional.empty();
    }
  }

  public String write(Object value) {
    return jsons.write(value);
  }

  private AiProvider activeProvider() {
    String provider = properties.ai() == null || properties.ai().provider() == null || properties.ai().provider().isBlank()
        ? "qwen"
        : properties.ai().provider();
    return providers.stream()
        .filter(candidate -> candidate.supports(provider))
        .findFirst()
        .orElseThrow(() -> AppException.validation("AI provider is not supported.", Map.of("provider", provider)));
  }

  private static String stripCodeFence(String content) {
    if (content == null) {
      return "";
    }
    String text = content.trim();
    if (!text.startsWith("```")) {
      return text;
    }
    int firstLine = text.indexOf('\n');
    int lastFence = text.lastIndexOf("```");
    if (firstLine >= 0 && lastFence > firstLine) {
      return text.substring(firstLine + 1, lastFence).trim();
    }
    return text;
  }
}
