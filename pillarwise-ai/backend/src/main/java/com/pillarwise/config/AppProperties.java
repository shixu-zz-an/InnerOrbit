package com.pillarwise.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app")
public record AppProperties(
    String profile,
    Sqlite sqlite,
    Ai ai,
    Auth auth
) {
  public record Sqlite(String path) {}

  public record Ai(String provider, String baseUrl, String apiKey, String model) {}

  public record Auth(String provider) {}
}
