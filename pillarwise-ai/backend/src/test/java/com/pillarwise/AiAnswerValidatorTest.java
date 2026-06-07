package com.pillarwise;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.pillarwise.ai.AiAnswerValidator;
import com.pillarwise.common.Jsons;
import java.util.Map;
import org.junit.jupiter.api.Test;

class AiAnswerValidatorTest {
  private final AiAnswerValidator validator = new AiAnswerValidator(new Jsons(new ObjectMapper()));

  @Test
  void parsesFencedJsonAnswer() {
    Map<String, Object> answer = validator.parseAndValidate("""
        ```json
        {
          "headline": "A grounded answer",
          "summary": "Use this as a reflective pattern.",
          "sections": [
            {"title": "Pattern", "body": "Name the next choice you control."}
          ],
          "practicalStep": "Take one small step.",
          "reflectionQuestion": "What is actually in your control?"
        }
        ```
        """);

    assertThat(answer).containsEntry("headline", "A grounded answer");
    assertThat(answer.get("sections").toString()).contains("Pattern");
  }

  @Test
  void rejectsInvalidSchema() {
    assertThatThrownBy(() -> validator.parseAndValidate("""
        {
          "headline": "Missing useful fields",
          "summary": "",
          "sections": [],
          "practicalStep": "",
          "reflectionQuestion": ""
        }
        """))
        .isInstanceOf(IllegalArgumentException.class);
  }
}
