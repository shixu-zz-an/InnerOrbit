package com.pillarwise.ai;

import com.pillarwise.common.Jsons;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class AiAnswerValidator {
  private final Jsons jsons;

  public AiAnswerValidator(Jsons jsons) {
    this.jsons = jsons;
  }

  public Map<String, Object> parseAndValidate(String content) {
    Map<String, Object> raw = jsons.readMap(stripCodeFence(content));
    String headline = requiredString(raw, "headline");
    String summary = requiredString(raw, "summary");
    List<Map<String, Object>> sections = sections(raw.get("sections"));
    String practicalStep = requiredString(raw, "practicalStep");
    String reflectionQuestion = requiredString(raw, "reflectionQuestion");
    Map<String, Object> answer = new LinkedHashMap<>();
    answer.put("headline", headline);
    answer.put("summary", summary);
    answer.put("sections", sections);
    answer.put("practicalStep", practicalStep);
    answer.put("reflectionQuestion", reflectionQuestion);
    if (raw.get("safetyNote") instanceof String safetyNote && !safetyNote.isBlank()) {
      answer.put("safetyNote", safetyNote.trim());
    }
    return answer;
  }

  private static List<Map<String, Object>> sections(Object value) {
    if (!(value instanceof List<?> list) || list.isEmpty() || list.size() > 5) {
      throw new IllegalArgumentException("AI sections must contain 1 to 5 items.");
    }
    List<Map<String, Object>> sections = new ArrayList<>();
    for (Object item : list) {
      if (!(item instanceof Map<?, ?> map)) {
        throw new IllegalArgumentException("AI section is invalid.");
      }
      String title = stringValue(map.get("title"));
      String body = stringValue(map.get("body"));
      if (title.isBlank() || body.isBlank() || body.length() > 900) {
        throw new IllegalArgumentException("AI section content is invalid.");
      }
      sections.add(Map.of("title", title, "body", body));
    }
    return sections;
  }

  private static String requiredString(Map<String, Object> raw, String key) {
    String value = stringValue(raw.get(key));
    if (value.isBlank()) {
      throw new IllegalArgumentException("AI response is missing " + key + ".");
    }
    return value;
  }

  private static String stringValue(Object value) {
    return value instanceof String text ? text.trim() : "";
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
