package com.pillarwise;

import static org.assertj.core.api.Assertions.assertThat;

import com.pillarwise.bazi.BaziChart;
import com.pillarwise.bazi.DeterministicBaziEngine;
import com.pillarwise.profile.BirthProfile;
import org.junit.jupiter.api.Test;

class BaziEngineTest {
  @Test
  void calculatesStableChartForExactBirthTime() {
    DeterministicBaziEngine engine = new DeterministicBaziEngine();
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
    assertThat(first.yearStem()).isEqualTo(second.yearStem());
    assertThat(first.monthBranch()).isEqualTo(second.monthBranch());
    assertThat(first.confidence()).containsEntry("timeline", "high");
  }

  @Test
  void unknownBirthTimeOmitsHourAndLowersConfidence() {
    DeterministicBaziEngine engine = new DeterministicBaziEngine();
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
    assertThat(chart.confidence()).containsEntry("birthTime", "unknown");
    assertThat(chart.confidence()).containsEntry("timeline", "low");
  }
}
