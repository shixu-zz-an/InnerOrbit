package com.pillarwise.ai;

import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class SafetyGuard {
  private static final List<String> HARD_BLOCK = List.of("suicide", "kill myself", "self harm", "overdose", "die soon", "death date");
  private static final List<String> HEALTH = List.of("cancer", "sick", "diagnosis", "medication", "stop taking");
  private static final List<String> FINANCE = List.of("stock", "lottery", "get rich", "investment", "buy tesla");
  private static final List<String> DETERMINISTIC = List.of("will i marry", "will my partner", "soulmate", "will i get", "guaranteed");
  private static final List<String> FORBIDDEN_OUTPUT = List.of(
      "you will definitely", "guaranteed", "doomed", "must break up", "will die", "will get cancer", "buy this stock", "stop medication"
  );

  public SafetyDecision precheck(String message) {
    String text = normalize(message);
    if (containsAny(text, HARD_BLOCK)) {
      return SafetyDecision.blocked("self_harm", Map.of(
          "headline", "Your safety matters more than a reading.",
          "summary", "I’m really sorry you’re feeling this way. I can’t provide a reading for this, but your safety matters.",
          "sections", List.of(Map.of(
              "title", "Please get immediate support",
              "body", "If you might hurt yourself or feel in immediate danger, contact local emergency services now or reach out to someone you trust. If you’re in the U.S. or Canada, call or text 988 for immediate support."
          )),
          "practicalStep", "Contact emergency services, 988, or a trusted person now.",
          "reflectionQuestion", "Who can you contact right now so you are not alone with this?"
      ));
    }
    if (containsAny(text, HEALTH)) {
      return SafetyDecision.reframe("health", safeAnswer(
          "I can’t predict or assess health.",
          "For health concerns, it’s best to speak with a qualified professional. I can help you reflect on stress patterns and support needs.",
          "Name one support need you can meet today."
      ));
    }
    if (containsAny(text, FINANCE)) {
      return SafetyDecision.reframe("finance", safeAnswer(
          "I can’t provide financial predictions or investment advice.",
          "I can help you reflect on your decision style, risk tolerance, and patterns around stability and growth.",
          "Define the part of this decision that is actually within your control."
      ));
    }
    if (containsAny(text, DETERMINISTIC)) {
      return SafetyDecision.reframe("deterministic", safeAnswer(
          "I can’t promise a specific outcome.",
          "What I can do is read this as a pattern and timing theme, then help you focus on choices you can control.",
          "Write the choice you can make without needing certainty first."
      ));
    }
    return SafetyDecision.allow();
  }

  public boolean outputSafe(Map<String, Object> answer) {
    String text = normalize(answer.toString());
    return !containsAny(text, FORBIDDEN_OUTPUT);
  }

  private static Map<String, Object> safeAnswer(String headline, String summary, String step) {
    return Map.of(
        "headline", headline,
        "summary", summary,
        "sections", List.of(Map.of("title", "A safer frame", "body", summary)),
        "practicalStep", step,
        "reflectionQuestion", "What support or information would make this decision safer?"
    );
  }

  private static String normalize(String value) {
    return value == null ? "" : value.toLowerCase(Locale.ROOT);
  }

  private static boolean containsAny(String text, List<String> terms) {
    return terms.stream().anyMatch(text::contains);
  }

  public record SafetyDecision(
      boolean allowed,
      boolean blocked,
      String label,
      Map<String, Object> fallbackAnswer
  ) {
    static SafetyDecision allow() {
      return new SafetyDecision(true, false, "safe", Map.of());
    }

    static SafetyDecision blocked(String label, Map<String, Object> answer) {
      return new SafetyDecision(false, true, label, answer);
    }

    static SafetyDecision reframe(String label, Map<String, Object> answer) {
      return new SafetyDecision(false, false, label, answer);
    }
  }
}
