package com.pillarwise.bazi;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class InsightMapper {
  public MappedInsight map(BaziChart chart) {
    String element = chart.dayMaster().contains("Wood") ? "wood"
        : chart.dayMaster().contains("Fire") ? "fire"
        : chart.dayMaster().contains("Earth") ? "earth"
        : chart.dayMaster().contains("Metal") ? "metal"
        : "water";
    String dominant = dominantElement(chart.elementDistribution());
    return switch (element) {
      case "wood" -> new MappedInsight(
          archetype(chart.dayStem(), dominant),
          List.of("Sees growth potential quickly", "Pushes toward improvement", "Carries strong long-range vision"),
          List.of("Can rush seasons that need patience", "May turn every discomfort into a project"),
          "You need honesty and room to keep growing.",
          "You work best where ideas can become living systems.",
          "Money feels cleanest when it supports growth and autonomy.",
          "This phase asks you to choose the one direction worth feeding."
      );
      case "fire" -> new MappedInsight(
          archetype(chart.dayStem(), dominant),
          List.of("Brings warmth and visibility", "Motivates others through expression", "Finds meaning quickly"),
          List.of("May read low energy as rejection", "Can overextend to keep momentum alive"),
          "You need emotional responsiveness without performance pressure.",
          "You thrive where your voice, taste, or presence matters.",
          "Money follows consistency more than bursts of inspiration.",
          "This phase asks you to protect your signal from noise."
      );
      case "metal" -> new MappedInsight(
          archetype(chart.dayStem(), dominant),
          List.of("Sharp standards and boundaries", "Refines messy systems", "Values clarity and integrity"),
          List.of("May confuse softness with weakness", "Can edit before an idea has had room to breathe"),
          "You need respect, precision, and repair after conflict.",
          "You are suited to work that rewards judgment and craft.",
          "Money improves when rules are explicit and reviewed.",
          "This phase asks you to soften without lowering your standards."
      );
      case "water" -> new MappedInsight(
          archetype(chart.dayStem(), dominant),
          List.of("Intuitive and adaptive", "Comfortable with complexity", "Learns through reflection"),
          List.of("May drift when the next step is too undefined", "Can mistake possibility for commitment"),
          "You need emotional room and honest curiosity.",
          "You fit roles that need research, imagination, or strategy.",
          "Money works best with containers around optionality.",
          "This phase asks you to turn insight into one concrete move."
      );
      default -> new MappedInsight(
          archetype(chart.dayStem(), dominant),
          List.of("Creates stability under pressure", "Turns vague ideas into structure", "Reliable when others feel scattered"),
          List.of("May confuse control with safety", "Can carry too much responsibility alone"),
          "You need consistency, trust, and clear emotional signals.",
          "You build value by turning uncertainty into practical systems.",
          "Money feels safest when plans are visible and grounded.",
          "This phase asks you to let support in before you feel fully ready."
      );
    };
  }

  private static String dominantElement(Map<String, Object> distribution) {
    return distribution.entrySet().stream()
        .max(Comparator.comparingDouble(e -> ((Number) e.getValue()).doubleValue()))
        .map(Map.Entry::getKey)
        .orElse("earth");
  }

  private static String archetype(String dayStem, String dominant) {
    if (dayStem.equals("Jia")) return "The Vision Builder";
    if (dayStem.equals("Yi")) return "The Adaptive Creator";
    if (dayStem.equals("Bing")) return "The Radiant Catalyst";
    if (dayStem.equals("Ding")) return "The Quiet Illuminator";
    if (dayStem.equals("Wu")) return "The Steady Mountain";
    if (dayStem.equals("Ji")) return "The Grounded Strategist";
    if (dayStem.equals("Geng")) return "The Principled Architect";
    if (dayStem.equals("Xin")) return "The Refined Editor";
    if (dayStem.equals("Ren")) return "The Deep Explorer";
    if (dominant.equals("water")) return "The Intuitive Synthesizer";
    return "The Intuitive Synthesizer";
  }

  public record MappedInsight(
      String coreArchetype,
      List<String> strengths,
      List<String> blindSpots,
      String relationshipPattern,
      String careerStyle,
      String moneyStyle,
      String currentPhase
  ) {}
}
