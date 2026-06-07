package com.pillarwise.bazi;

import com.pillarwise.common.Ids;
import com.pillarwise.profile.BirthProfile;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DeterministicBaziEngine implements BaziEngine {
  private static final String[] STEMS = {"Jia", "Yi", "Bing", "Ding", "Wu", "Ji", "Geng", "Xin", "Ren", "Gui"};
  private static final String[] BRANCHES = {"Zi", "Chou", "Yin", "Mao", "Chen", "Si", "Wu", "Wei", "Shen", "You", "Xu", "Hai"};
  private static final Map<String, String> STEM_ELEMENTS = Map.of(
      "Jia", "Wood", "Yi", "Wood",
      "Bing", "Fire", "Ding", "Fire",
      "Wu", "Earth", "Ji", "Earth",
      "Geng", "Metal", "Xin", "Metal",
      "Ren", "Water", "Gui", "Water"
  );
  private static final Map<String, String> BRANCH_ELEMENTS = Map.ofEntries(
      Map.entry("Zi", "Water"),
      Map.entry("Chou", "Earth"),
      Map.entry("Yin", "Wood"),
      Map.entry("Mao", "Wood"),
      Map.entry("Chen", "Earth"),
      Map.entry("Si", "Fire"),
      Map.entry("Wu", "Fire"),
      Map.entry("Wei", "Earth"),
      Map.entry("Shen", "Metal"),
      Map.entry("You", "Metal"),
      Map.entry("Xu", "Earth"),
      Map.entry("Hai", "Water")
  );

  @Override
  public String calcVersion() {
    return "bazi-v1-deterministic-solar-approx";
  }

  @Override
  public BaziChart calculate(BirthProfile profile) {
    LocalDate date = LocalDate.parse(profile.birthDate());
    LocalTime time = profile.birthTime() == null || profile.birthTime().isBlank()
        ? null
        : LocalTime.parse(profile.birthTime());
    if (time != null && profile.trueSolarTimeEnabled() && profile.longitude() != null) {
      time = trueSolarTime(date, time, profile.timezone(), profile.longitude());
    }

    int yearForPillar = isBeforeLichun(date) ? date.getYear() - 1 : date.getYear();
    int yearIndex = cycleIndex(yearForPillar - 1984);
    String yearStem = STEMS[yearIndex % 10];
    String yearBranch = BRANCHES[yearIndex % 12];

    int monthNumber = solarMonthNumber(date);
    String monthBranch = BRANCHES[(monthNumber + 1) % 12]; // 1=Yin
    int monthStemIndex = Math.floorMod((yearIndex % 10) * 2 + monthNumber + 1, 10);
    String monthStem = STEMS[monthStemIndex];

    long days = ChronoUnit.DAYS.between(LocalDate.of(1900, 1, 31), date);
    int dayIndex = cycleIndex((int) days + 40);
    String dayStem = STEMS[dayIndex % 10];
    String dayBranch = BRANCHES[dayIndex % 12];

    String hourStem = null;
    String hourBranch = null;
    if (time != null && !"unknown".equals(profile.birthTimePrecision())) {
      int hourBranchIndex = ((time.getHour() + 1) / 2) % 12;
      hourBranch = BRANCHES[hourBranchIndex];
      int hourStemIndex = Math.floorMod((dayIndex % 10) * 2 + hourBranchIndex, 10);
      hourStem = STEMS[hourStemIndex];
    }

    Map<String, Object> elements = elementDistribution(yearStem, yearBranch, monthStem, monthBranch, dayStem, dayBranch, hourStem, hourBranch);
    Map<String, Object> confidence = confidence(profile, hourStem);
    return new BaziChart(
        Ids.newId("chart"),
        profile.id(),
        calcVersion(),
        yearStem,
        yearBranch,
        monthStem,
        monthBranch,
        dayStem,
        dayBranch,
        hourStem,
        hourBranch,
        dayStem + " " + STEM_ELEMENTS.get(dayStem),
        elements,
        Map.of("source", "deterministic_mapping", "dayMaster", dayStem),
        hiddenStems(),
        luckCycles(profile.sexForTraditionalCycle(), confidence),
        annualCycles(date.getYear()),
        confidence
    );
  }

  private static LocalTime trueSolarTime(LocalDate date, LocalTime time, String timezone, double longitude) {
    ZonedDateTime zoned = LocalDateTime.of(date, time).atZone(ZoneId.of(timezone));
    double utcOffsetHours = zoned.getOffset().getTotalSeconds() / 3600.0;
    double centralMeridian = utcOffsetHours * 15.0;
    long offsetMinutes = Math.round((longitude - centralMeridian) * 4.0);
    return time.plusMinutes(offsetMinutes);
  }

  private static boolean isBeforeLichun(LocalDate date) {
    return date.getMonthValue() == 1 || (date.getMonthValue() == 2 && date.getDayOfMonth() < 4);
  }

  private static int solarMonthNumber(LocalDate date) {
    int month = date.getMonthValue();
    int day = date.getDayOfMonth();
    if (month == 2 && day >= 4 || month == 3 && day < 6) return 1;
    if (month == 3 || month == 4 && day < 5) return 2;
    if (month == 4 || month == 5 && day < 6) return 3;
    if (month == 5 || month == 6 && day < 6) return 4;
    if (month == 6 || month == 7 && day < 7) return 5;
    if (month == 7 || month == 8 && day < 8) return 6;
    if (month == 8 || month == 9 && day < 8) return 7;
    if (month == 9 || month == 10 && day < 8) return 8;
    if (month == 10 || month == 11 && day < 7) return 9;
    if (month == 11 || month == 12 && day < 7) return 10;
    if (month == 12 || month == 1 && day < 6) return 11;
    return 12;
  }

  private static int cycleIndex(int value) {
    return Math.floorMod(value, 60);
  }

  private static Map<String, Object> elementDistribution(String... pillars) {
    Map<String, Double> weights = new LinkedHashMap<>();
    weights.put("wood", 0.0);
    weights.put("fire", 0.0);
    weights.put("earth", 0.0);
    weights.put("metal", 0.0);
    weights.put("water", 0.0);
    for (int i = 0; i < pillars.length; i++) {
      String value = pillars[i];
      if (value == null) continue;
      String element = STEM_ELEMENTS.getOrDefault(value, BRANCH_ELEMENTS.get(value));
      if (element == null) continue;
      double weight = i % 2 == 0 ? 1.0 : 0.8;
      weights.compute(element.toLowerCase(), (key, old) -> (old == null ? 0 : old) + weight);
    }
    String monthBranch = pillars.length > 3 ? pillars[3] : null;
    if (monthBranch != null) {
      String element = BRANCH_ELEMENTS.get(monthBranch);
      weights.compute(element.toLowerCase(), (key, old) -> (old == null ? 0 : old) + 0.5);
    }
    double total = weights.values().stream().mapToDouble(Double::doubleValue).sum();
    Map<String, Object> normalized = new LinkedHashMap<>();
    for (Map.Entry<String, Double> entry : weights.entrySet()) {
      normalized.put(entry.getKey(), Math.round(entry.getValue() / total * 100.0) / 100.0);
    }
    return normalized;
  }

  private static Map<String, Object> hiddenStems() {
    return Map.ofEntries(
        Map.entry("Zi", List.of("Gui")),
        Map.entry("Chou", List.of("Ji", "Gui", "Xin")),
        Map.entry("Yin", List.of("Jia", "Bing", "Wu")),
        Map.entry("Mao", List.of("Yi")),
        Map.entry("Chen", List.of("Wu", "Yi", "Gui")),
        Map.entry("Si", List.of("Bing", "Wu", "Geng")),
        Map.entry("Wu", List.of("Ding", "Ji")),
        Map.entry("Wei", List.of("Ji", "Ding", "Yi")),
        Map.entry("Shen", List.of("Geng", "Ren", "Wu")),
        Map.entry("You", List.of("Xin")),
        Map.entry("Xu", List.of("Wu", "Xin", "Ding")),
        Map.entry("Hai", List.of("Ren", "Jia"))
    );
  }

  private static Map<String, Object> luckCycles(String sex, Map<String, Object> confidence) {
    if (sex == null || sex.equals("prefer_not_to_say")) {
      return Map.of("cycles", List.of(), "note", "Timeline insights are generalized without traditional cycle direction.");
    }
    List<Map<String, Object>> cycles = new ArrayList<>();
    for (int i = 0; i < 6; i++) {
      cycles.add(Map.of(
          "startAge", 8 + i * 10,
          "endAge", 17 + i * 10,
          "theme", i % 2 == 0 ? "Building inner structure" : "Expanding through relationships"
      ));
    }
    return Map.of("cycles", cycles, "confidence", confidence.get("timeline"));
  }

  private static Map<String, Object> annualCycles(int birthYear) {
    int current = java.time.Year.now().getValue();
    List<Map<String, Object>> years = new ArrayList<>();
    for (int i = 0; i < 5; i++) {
      int year = current + i;
      years.add(Map.of("year", year, "theme", (year - birthYear) % 2 == 0 ? "Refine commitments" : "Explore new options"));
    }
    return Map.of("years", years);
  }

  private static Map<String, Object> confidence(BirthProfile profile, String hourStem) {
    String location = profile.latitude() == null || profile.longitude() == null ? "approximate" : "exact";
    String timeline = profile.sexForTraditionalCycle() == null || profile.sexForTraditionalCycle().equals("prefer_not_to_say")
        ? "low"
        : hourStem == null ? "medium" : "high";
    List<String> notes = new ArrayList<>();
    if (hourStem == null) {
      notes.add("Birth time is unknown, so hour-based insights are generalized.");
    }
    if (!"exact".equals(location)) {
      notes.add("Birthplace coordinates are approximate, so location-based timing is generalized.");
    }
    return Map.of(
        "birthTime", profile.birthTimePrecision(),
        "location", location,
        "timeline", timeline,
        "notes", notes
    );
  }
}
