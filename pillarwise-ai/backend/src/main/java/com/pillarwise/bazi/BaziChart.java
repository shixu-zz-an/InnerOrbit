package com.pillarwise.bazi;

import java.util.Map;

public record BaziChart(
    String id,
    String birthProfileId,
    String calcVersion,
    String yearStem,
    String yearBranch,
    String monthStem,
    String monthBranch,
    String dayStem,
    String dayBranch,
    String hourStem,
    String hourBranch,
    String dayMaster,
    Map<String, Object> elementDistribution,
    Map<String, Object> tenGods,
    Map<String, Object> hiddenStems,
    Map<String, Object> luckCycles,
    Map<String, Object> annualCycles,
    Map<String, Object> confidence
) {}
