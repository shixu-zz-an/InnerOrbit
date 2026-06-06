package com.pillarwise.common;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class Jsons {
  private static final TypeReference<Map<String, Object>> MAP = new TypeReference<>() {};
  private final ObjectMapper mapper;

  public Jsons(ObjectMapper mapper) {
    this.mapper = mapper;
  }

  public String write(Object value) {
    try {
      return mapper.writeValueAsString(value);
    } catch (Exception ex) {
      throw new IllegalStateException("Failed to write JSON", ex);
    }
  }

  public Map<String, Object> readMap(String value) {
    if (value == null || value.isBlank()) {
      return Map.of();
    }
    try {
      return mapper.readValue(value, MAP);
    } catch (Exception ex) {
      throw new IllegalStateException("Failed to read JSON", ex);
    }
  }
}
