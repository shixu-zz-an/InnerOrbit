package com.pillarwise.bazi;

import java.util.Map;

public final class BaziDtos {
  private BaziDtos() {}

  public static Map<String, Object> chart(BaziChart chart) {
    return Map.of(
        "chartId", chart.id(),
        "calcVersion", chart.calcVersion(),
        "fourPillars", Map.of(
            "year", pillar(chart.yearStem(), chart.yearBranch()),
            "month", pillar(chart.monthStem(), chart.monthBranch()),
            "day", pillar(chart.dayStem(), chart.dayBranch()),
            "hour", chart.hourStem() == null ? Map.of() : pillar(chart.hourStem(), chart.hourBranch())
        ),
        "dayMaster", chart.dayMaster(),
        "elementDistribution", chart.elementDistribution(),
        "confidence", chart.confidence()
    );
  }

  private static Map<String, Object> pillar(String stem, String branch) {
    return Map.of("stem", stem, "branch", branch, "element", element(stem));
  }

  private static String element(String stem) {
    return switch (stem) {
      case "Jia", "Yi" -> "Wood";
      case "Bing", "Ding" -> "Fire";
      case "Wu", "Ji" -> "Earth";
      case "Geng", "Xin" -> "Metal";
      default -> "Water";
    };
  }
}
