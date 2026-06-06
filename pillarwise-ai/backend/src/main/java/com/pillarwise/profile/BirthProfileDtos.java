package com.pillarwise.profile;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.InsightMapper;
import java.util.LinkedHashMap;
import java.util.Map;

public final class BirthProfileDtos {
  private BirthProfileDtos() {}

  public static Map<String, Object> createResponse(
      BirthProfile profile,
      BaziChart chart,
      InsightMapper.MappedInsight insight
  ) {
    return Map.of(
        "birthProfile", summary(profile),
        "chartSummary", Map.of(
            "chartId", chart.id(),
            "dayMaster", chart.dayMaster(),
            "coreArchetype", insight.coreArchetype(),
            "confidenceLevel", chart.confidence().get("timeline")
        )
    );
  }

  public static Map<String, Object> summary(BirthProfile profile) {
    Map<String, Object> map = new LinkedHashMap<>();
    map.put("id", profile.id());
    map.put("name", profile.name());
    map.put("birthDate", profile.birthDate());
    map.put("birthTime", profile.birthTime());
    map.put("birthTimePrecision", profile.birthTimePrecision());
    map.put("birthPlaceText", profile.birthPlaceText());
    map.put("latitude", profile.latitude());
    map.put("longitude", profile.longitude());
    map.put("timezone", profile.timezone());
    map.put("sexForTraditionalCycle", profile.sexForTraditionalCycle());
    map.put("trueSolarTimeEnabled", profile.trueSolarTimeEnabled());
    map.put("isPrimary", profile.primary());
    return map;
  }
}
