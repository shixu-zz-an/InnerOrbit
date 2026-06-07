package com.pillarwise.bazi;

import com.nlf.calendar.EightChar;
import com.nlf.calendar.Lunar;
import com.nlf.calendar.Solar;
import com.nlf.calendar.eightchar.DaYun;
import com.nlf.calendar.eightchar.Yun;
import com.pillarwise.common.Ids;
import com.pillarwise.profile.BirthProfile;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class LunarJavaBaziEngine implements BaziEngine {
  public static final String VERSION = "bazi-v1-lunarjava-1.7.7-tst-simple-sect2";

  private static final Map<String, String> GAN = Map.ofEntries(
      Map.entry("甲", "Jia"),
      Map.entry("乙", "Yi"),
      Map.entry("丙", "Bing"),
      Map.entry("丁", "Ding"),
      Map.entry("戊", "Wu"),
      Map.entry("己", "Ji"),
      Map.entry("庚", "Geng"),
      Map.entry("辛", "Xin"),
      Map.entry("壬", "Ren"),
      Map.entry("癸", "Gui")
  );
  private static final Map<String, String> ZHI = Map.ofEntries(
      Map.entry("子", "Zi"),
      Map.entry("丑", "Chou"),
      Map.entry("寅", "Yin"),
      Map.entry("卯", "Mao"),
      Map.entry("辰", "Chen"),
      Map.entry("巳", "Si"),
      Map.entry("午", "Wu"),
      Map.entry("未", "Wei"),
      Map.entry("申", "Shen"),
      Map.entry("酉", "You"),
      Map.entry("戌", "Xu"),
      Map.entry("亥", "Hai")
  );
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
  private static final Map<String, String> TEN_GODS = Map.ofEntries(
      Map.entry("比肩", "Peer"),
      Map.entry("劫财", "Companion"),
      Map.entry("食神", "Expression"),
      Map.entry("伤官", "Creative Edge"),
      Map.entry("偏财", "Adaptive Resource"),
      Map.entry("正财", "Stable Resource"),
      Map.entry("七杀", "Pressure"),
      Map.entry("正官", "Structure"),
      Map.entry("偏印", "Intuition"),
      Map.entry("正印", "Support")
  );
  private static final Map<String, List<String>> HIDDEN_STEMS = Map.ofEntries(
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

  @Override
  public String calcVersion() {
    return VERSION;
  }

  @Override
  public BaziChart calculate(BirthProfile profile) {
    LocalDate date = LocalDate.parse(profile.birthDate());
    LocalTime time = birthTime(profile);
    boolean hasHour = time != null && !"unknown".equals(profile.birthTimePrecision());
    AdjustedBirthTime adjusted = adjustForTrueSolarTime(date, hasHour ? time : LocalTime.NOON, hasHour, profile);

    Solar solar = Solar.fromYmdHms(
        adjusted.dateTime().getYear(),
        adjusted.dateTime().getMonthValue(),
        adjusted.dateTime().getDayOfMonth(),
        adjusted.dateTime().getHour(),
        adjusted.dateTime().getMinute(),
        0
    );
    Lunar lunar = solar.getLunar();
    EightChar eightChar = EightChar.fromLunar(lunar);
    eightChar.setSect(2);

    String yearStem = stem(eightChar.getYearGan());
    String yearBranch = branch(eightChar.getYearZhi());
    String monthStem = stem(eightChar.getMonthGan());
    String monthBranch = branch(eightChar.getMonthZhi());
    String dayStem = stem(eightChar.getDayGan());
    String dayBranch = branch(eightChar.getDayZhi());
    String hourStem = hasHour ? stem(eightChar.getTimeGan()) : null;
    String hourBranch = hasHour ? branch(eightChar.getTimeZhi()) : null;

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
        elementDistribution(yearStem, yearBranch, monthStem, monthBranch, dayStem, dayBranch, hourStem, hourBranch),
        tenGods(eightChar, hasHour),
        new LinkedHashMap<>(HIDDEN_STEMS),
        luckCycles(eightChar, profile, hasHour),
        annualCycles(LocalDate.now().getYear()),
        confidence(profile, hasHour, adjusted.trueSolarApplied())
    );
  }

  private static LocalTime birthTime(BirthProfile profile) {
    if (profile.birthTime() == null || profile.birthTime().isBlank()) {
      return null;
    }
    return LocalTime.parse(profile.birthTime());
  }

  private static AdjustedBirthTime adjustForTrueSolarTime(LocalDate date, LocalTime time, boolean hasHour, BirthProfile profile) {
    LocalDateTime dateTime = LocalDateTime.of(date, time);
    if (!hasHour || !profile.trueSolarTimeEnabled() || profile.longitude() == null) {
      return new AdjustedBirthTime(dateTime, false);
    }
    ZonedDateTime zoned = dateTime.atZone(ZoneId.of(profile.timezone()));
    double utcOffsetHours = zoned.getOffset().getTotalSeconds() / 3600.0;
    double centralMeridian = utcOffsetHours * 15.0;
    long offsetMinutes = Math.round((profile.longitude() - centralMeridian) * 4.0);
    return new AdjustedBirthTime(dateTime.plusMinutes(offsetMinutes), true);
  }

  private static Map<String, Object> elementDistribution(
      String yearStem,
      String yearBranch,
      String monthStem,
      String monthBranch,
      String dayStem,
      String dayBranch,
      String hourStem,
      String hourBranch
  ) {
    Map<String, Double> weights = emptyWeights();
    addStem(weights, yearStem, 1.0);
    addStem(weights, monthStem, 1.0);
    addStem(weights, dayStem, 1.0);
    addStem(weights, hourStem, 1.0);
    addBranch(weights, yearBranch, 0.8);
    addBranch(weights, monthBranch, 0.8);
    addBranch(weights, dayBranch, 0.8);
    addBranch(weights, hourBranch, 0.8);
    addHiddenStems(weights, yearBranch);
    addHiddenStems(weights, monthBranch);
    addHiddenStems(weights, dayBranch);
    addHiddenStems(weights, hourBranch);
    addBranch(weights, monthBranch, 0.5);
    double total = weights.values().stream().mapToDouble(Double::doubleValue).sum();
    Map<String, Object> normalized = new LinkedHashMap<>();
    for (Map.Entry<String, Double> entry : weights.entrySet()) {
      normalized.put(entry.getKey(), Math.round(entry.getValue() / total * 100.0) / 100.0);
    }
    return normalized;
  }

  private static Map<String, Double> emptyWeights() {
    Map<String, Double> weights = new LinkedHashMap<>();
    weights.put("wood", 0.0);
    weights.put("fire", 0.0);
    weights.put("earth", 0.0);
    weights.put("metal", 0.0);
    weights.put("water", 0.0);
    return weights;
  }

  private static void addStem(Map<String, Double> weights, String stem, double value) {
    if (stem == null) return;
    addElement(weights, STEM_ELEMENTS.get(stem), value);
  }

  private static void addBranch(Map<String, Double> weights, String branch, double value) {
    if (branch == null) return;
    addElement(weights, BRANCH_ELEMENTS.get(branch), value);
  }

  private static void addHiddenStems(Map<String, Double> weights, String branch) {
    if (branch == null) return;
    for (String stem : HIDDEN_STEMS.getOrDefault(branch, List.of())) {
      addStem(weights, stem, 0.3);
    }
  }

  private static void addElement(Map<String, Double> weights, String element, double value) {
    if (element == null) return;
    String key = element.toLowerCase(Locale.ROOT);
    weights.compute(key, (ignored, old) -> (old == null ? 0 : old) + value);
  }

  private static Map<String, Object> tenGods(EightChar eightChar, boolean hasHour) {
    Map<String, Object> result = new LinkedHashMap<>();
    result.put("year", tenGod(eightChar.getYearShiShenGan(), eightChar.getYearShiShenZhi()));
    result.put("month", tenGod(eightChar.getMonthShiShenGan(), eightChar.getMonthShiShenZhi()));
    result.put("day", tenGod(eightChar.getDayShiShenGan(), eightChar.getDayShiShenZhi()));
    if (hasHour) {
      result.put("hour", tenGod(eightChar.getTimeShiShenGan(), eightChar.getTimeShiShenZhi()));
    }
    return result;
  }

  private static Map<String, Object> tenGod(String stem, List<String> branch) {
    return Map.of(
        "stem", TEN_GODS.getOrDefault(stem, stem),
        "branch", branch.stream().map(value -> TEN_GODS.getOrDefault(value, value)).toList()
    );
  }

  private static Map<String, Object> luckCycles(EightChar eightChar, BirthProfile profile, boolean hasHour) {
    if (profile.sexForTraditionalCycle() == null || "prefer_not_to_say".equals(profile.sexForTraditionalCycle())) {
      return Map.of("cycles", List.of(), "note", "Timeline insights are generalized without traditional cycle direction.");
    }
    int gender = "male".equals(profile.sexForTraditionalCycle()) ? 1 : 0;
    Yun yun = eightChar.getYun(gender, 2);
    List<Map<String, Object>> cycles = new ArrayList<>();
    for (DaYun daYun : yun.getDaYun(7)) {
      if (daYun.getIndex() == 0) continue;
      String ganZhi = daYun.getGanZhi();
      cycles.add(Map.of(
          "startAge", daYun.getStartAge(),
          "endAge", daYun.getEndAge(),
          "startYear", daYun.getStartYear(),
          "endYear", daYun.getEndYear(),
          "pillar", Map.of("stem", stem(ganZhi.substring(0, 1)), "branch", branch(ganZhi.substring(1, 2))),
          "theme", cycleTheme(stem(ganZhi.substring(0, 1)))
      ));
    }
    return Map.of(
        "cycles", cycles,
        "direction", yun.isForward() ? "forward" : "reverse",
        "start", Map.of("years", yun.getStartYear(), "months", yun.getStartMonth(), "days", yun.getStartDay(), "hours", yun.getStartHour()),
        "confidence", hasHour ? "high" : "medium"
    );
  }

  private static String cycleTheme(String stem) {
    String element = STEM_ELEMENTS.getOrDefault(stem, "Earth");
    return switch (element) {
      case "Wood" -> "Growth, direction, and expansion";
      case "Fire" -> "Visibility, warmth, and expression";
      case "Metal" -> "Standards, boundaries, and refinement";
      case "Water" -> "Reflection, learning, and adaptability";
      default -> "Structure, responsibility, and stability";
    };
  }

  private static Map<String, Object> annualCycles(int currentYear) {
    List<Map<String, Object>> years = new ArrayList<>();
    for (int i = 0; i < 5; i++) {
      int year = currentYear + i;
      Lunar lunar = Solar.fromYmd(year, 6, 1).getLunar();
      String ganZhi = lunar.getYearInGanZhiByLiChun();
      String stem = stem(ganZhi.substring(0, 1));
      years.add(Map.of(
          "year", year,
          "pillar", Map.of("stem", stem, "branch", branch(ganZhi.substring(1, 2))),
          "theme", cycleTheme(stem)
      ));
    }
    return Map.of("years", years);
  }

  private static Map<String, Object> confidence(BirthProfile profile, boolean hasHour, boolean trueSolarApplied) {
    String location = profile.latitude() == null || profile.longitude() == null ? "approximate" : "exact";
    String timeline = profile.sexForTraditionalCycle() == null || profile.sexForTraditionalCycle().equals("prefer_not_to_say")
        ? "low"
        : hasHour ? "high" : "medium";
    List<String> notes = new ArrayList<>();
    if (!hasHour) {
      notes.add("Birth time is unknown, so hour-based insights are generalized.");
    }
    if (!"exact".equals(location)) {
      notes.add("Birthplace coordinates are approximate, so location-based timing is generalized.");
    }
    if (profile.trueSolarTimeEnabled() && !trueSolarApplied) {
      notes.add("True solar time was requested but skipped because longitude was unavailable.");
    }
    if (trueSolarApplied) {
      notes.add("True solar time used a longitude offset without equation-of-time refinement.");
    }
    return Map.of(
        "birthTime", profile.birthTimePrecision(),
        "location", location,
        "timeline", timeline,
        "notes", notes
    );
  }

  private static String stem(String value) {
    return GAN.getOrDefault(value, value);
  }

  private static String branch(String value) {
    return ZHI.getOrDefault(value, value);
  }

  private record AdjustedBirthTime(LocalDateTime dateTime, boolean trueSolarApplied) {}
}
