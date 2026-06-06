package com.pillarwise;

import static org.assertj.core.api.Assertions.assertThat;

import com.pillarwise.ai.SafetyGuard;
import org.junit.jupiter.api.Test;

class SafetyGuardTest {
  @Test
  void blocksSelfHarmRequests() {
    SafetyGuard guard = new SafetyGuard();

    SafetyGuard.SafetyDecision decision = guard.precheck("I want to kill myself");

    assertThat(decision.allowed()).isFalse();
    assertThat(decision.blocked()).isTrue();
    assertThat(decision.label()).isEqualTo("self_harm");
    assertThat(decision.fallbackAnswer()).containsKey("practicalStep");
  }

  @Test
  void reframesFinancialPredictionRequests() {
    SafetyGuard guard = new SafetyGuard();

    SafetyGuard.SafetyDecision decision = guard.precheck("Should I buy Tesla stock?");

    assertThat(decision.allowed()).isFalse();
    assertThat(decision.blocked()).isFalse();
    assertThat(decision.label()).isEqualTo("finance");
  }
}
