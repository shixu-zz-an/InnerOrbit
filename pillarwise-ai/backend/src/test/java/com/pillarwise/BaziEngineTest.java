package com.pillarwise;

import static org.assertj.core.api.Assertions.assertThat;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.LunarJavaBaziEngine;
import com.pillarwise.profile.BirthProfile;
import org.junit.jupiter.api.Test;

class BaziEngineTest {
  @Test
  void calculatesStableChartForExactBirthTime() {
    LunarJavaBaziEngine engine = new LunarJavaBaziEngine();
    BirthProfile profile = new BirthProfile(
        "bp_test",
        "usr_test",
        "Me",
        "1994-08-21",
        "14:30",
        "exact",
        "Los Angeles, CA, US",
        34.0522,
        -118.2437,
        "America/Los_Angeles",
        "female",
        true,
        true
    );

    BaziChart first = engine.calculate(profile);
    BaziChart second = engine.calculate(profile);

    assertThat(first.dayMaster()).isEqualTo("Ji Earth");
    assertThat(first.calcVersion()).isEqualTo(LunarJavaBaziEngine.VERSION);
    assertThat(first.yearStem()).isEqualTo("Jia");
    assertThat(first.yearBranch()).isEqualTo("Xu");
    assertThat(first.monthStem()).isEqualTo("Ren");
    assertThat(first.monthBranch()).isEqualTo("Shen");
    assertThat(first.dayStem()).isEqualTo("Ji");
    assertThat(first.dayBranch()).isEqualTo("Mao");
    assertThat(first.hourStem()).isEqualTo("Xin");
    assertThat(first.hourBranch()).isEqualTo("Wei");
    assertThat(first.yearStem()).isEqualTo(second.yearStem());
    assertThat(first.monthBranch()).isEqualTo(second.monthBranch());
    assertThat(first.elementDistribution()).containsEntry("earth", 0.33);
    assertThat(first.confidence()).containsEntry("timeline", "high");
  }

  @Test
  void unknownBirthTimeOmitsHourAndLowersConfidence() {
    LunarJavaBaziEngine engine = new LunarJavaBaziEngine();
    BirthProfile profile = new BirthProfile(
        "bp_test",
        "usr_test",
        "Alex",
        "1993-02-18",
        null,
        "unknown",
        "New York, NY, US",
        40.7128,
        -74.006,
        "America/New_York",
        "prefer_not_to_say",
        true,
        false
    );

    BaziChart chart = engine.calculate(profile);

    assertThat(chart.hourStem()).isNull();
    assertThat(chart.hourBranch()).isNull();
    assertThat(chart.dayMaster()).isEqualTo("Geng Metal");
    assertThat(chart.confidence()).containsEntry("birthTime", "unknown");
    assertThat(chart.confidence()).containsEntry("timeline", "low");
    assertThat(chart.confidence().get("notes").toString()).doesNotContain("True solar time used");
  }

  @Test
  void lichunBoundaryUsesExactSolarTermMoment() {
    LunarJavaBaziEngine engine = new LunarJavaBaziEngine();
    BirthProfile profile = new BirthProfile(
        "bp_test",
        "usr_test",
        "Li Chun",
        "2024-02-04",
        "10:30",
        "exact",
        "Shanghai, CN",
        31.2304,
        121.4737,
        "Asia/Shanghai",
        "male",
        false,
        true
    );

    BaziChart chart = engine.calculate(profile);

    assertThat(chart.yearStem()).isEqualTo("Gui");
    assertThat(chart.yearBranch()).isEqualTo("Mao");
    assertThat(chart.monthStem()).isEqualTo("Yi");
    assertThat(chart.monthBranch()).isEqualTo("Chou");
  }

  @Test
  void trueSolarTimeCanShiftTheCalculatedDay() {
    LunarJavaBaziEngine engine = new LunarJavaBaziEngine();
    BirthProfile profile = new BirthProfile(
        "bp_test",
        "usr_test",
        "True Solar",
        "2000-01-01",
        "00:10",
        "exact",
        "Far west",
        0.0,
        -179.0,
        "UTC",
        "male",
        true,
        true
    );

    BaziChart chart = engine.calculate(profile);

    assertThat(chart.dayStem()).isEqualTo("Ding");
    assertThat(chart.dayBranch()).isEqualTo("Si");
    assertThat(chart.hourStem()).isEqualTo("Bing");
    assertThat(chart.hourBranch()).isEqualTo("Wu");
    assertThat(chart.confidence().get("notes").toString()).contains("True solar time used");
  }
}
