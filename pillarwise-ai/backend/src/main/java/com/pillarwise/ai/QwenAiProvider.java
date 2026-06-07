package com.pillarwise.ai;

import com.pillarwise.common.AppException;
import com.pillarwise.config.AppProperties;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestClientResponseException;

@Component
public class QwenAiProvider implements AiProvider {
  private static final String DEFAULT_BASE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1";
  private static final String DEFAULT_MODEL = "qwen-plus";
  private static final ParameterizedTypeReference<Map<String, Object>> MAP_RESPONSE = new ParameterizedTypeReference<>() {};

  private final AppProperties properties;
  private final RestClient restClient;

  public QwenAiProvider(AppProperties properties, RestClient.Builder restClientBuilder) {
    this.properties = properties;
    SimpleClientHttpRequestFactory requestFactory = new SimpleClientHttpRequestFactory();
    requestFactory.setConnectTimeout(Duration.ofSeconds(10));
    requestFactory.setReadTimeout(Duration.ofSeconds(45));
    this.restClient = restClientBuilder.requestFactory(requestFactory).build();
  }

  @Override
  public boolean supports(String provider) {
    return "qwen".equalsIgnoreCase(provider) || "dashscope".equalsIgnoreCase(provider);
  }

  @Override
  public AiCompletion complete(AiRequest request) {
    String apiKey = apiKey();
    if (apiKey.isBlank()) {
      throw aiUnavailable("Qwen API key is not configured.");
    }
    String model = model();
    String url = baseUrl() + "/chat/completions";
    Map<String, Object> body = requestBody(request, model);
    Instant started = Instant.now();
    try {
      Map<String, Object> response = restClient.post()
          .uri(url)
          .headers(headers -> headers.setBearerAuth(apiKey))
          .contentType(MediaType.APPLICATION_JSON)
          .accept(MediaType.APPLICATION_JSON)
          .body(body)
          .retrieve()
          .body(MAP_RESPONSE);
      long latencyMs = Duration.between(started, Instant.now()).toMillis();
      return completion(response, model, latencyMs);
    } catch (RestClientResponseException ex) {
      throw aiUnavailable("Qwen request failed with status " + ex.getStatusCode().value() + ".");
    } catch (RestClientException ex) {
      throw aiUnavailable("Qwen request failed. Please try again.");
    }
  }

  private Map<String, Object> requestBody(AiRequest request, String model) {
    Map<String, Object> body = new LinkedHashMap<>();
    body.put("model", model);
    List<Map<String, String>> messages = new ArrayList<>();
    if (request.systemPrompt() != null && !request.systemPrompt().isBlank()) {
      messages.add(Map.of("role", "system", "content", request.systemPrompt()));
    }
    for (AiMessage message : request.messages()) {
      messages.add(Map.of("role", message.role(), "content", message.content()));
    }
    body.put("messages", messages);
    body.put("temperature", request.temperature());
    if ("json_object".equals(request.responseFormat())) {
      body.put("response_format", Map.of("type", "json_object"));
      body.put("enable_thinking", false);
    }
    if (request.maxTokens() != null && request.maxTokens() > 0) {
      body.put("max_tokens", request.maxTokens());
    }
    return body;
  }

  @SuppressWarnings("unchecked")
  private AiCompletion completion(Map<String, Object> response, String model, long latencyMs) {
    if (response == null) {
      throw aiUnavailable("Qwen returned an empty response.");
    }
    List<Object> choices = (List<Object>) response.get("choices");
    if (choices == null || choices.isEmpty() || !(choices.getFirst() instanceof Map<?, ?> choice)) {
      throw aiUnavailable("Qwen returned no choices.");
    }
    Object message = choice.get("message");
    if (!(message instanceof Map<?, ?> messageMap)) {
      throw aiUnavailable("Qwen returned no message.");
    }
    Object content = messageMap.get("content");
    if (!(content instanceof String text) || text.isBlank()) {
      throw aiUnavailable("Qwen returned an empty message.");
    }
    Map<String, Object> usage = response.get("usage") instanceof Map<?, ?> map
        ? (Map<String, Object>) map
        : Map.of();
    return new AiCompletion(
        "qwen",
        stringValue(response.getOrDefault("model", model), model),
        text,
        intValue(usage.get("prompt_tokens")),
        intValue(usage.get("completion_tokens")),
        0.0,
        latencyMs
    );
  }

  private String apiKey() {
    String configured = properties.ai() == null ? "" : blankDefault(properties.ai().apiKey(), "");
    if (!configured.isBlank()) {
      return configured;
    }
    return blankDefault(System.getenv("DASHSCOPE_API_KEY"), "");
  }

  private String model() {
    String configured = properties.ai() == null ? "" : blankDefault(properties.ai().model(), "");
    return configured.isBlank() ? DEFAULT_MODEL : configured;
  }

  private String baseUrl() {
    String configured = properties.ai() == null ? "" : blankDefault(properties.ai().baseUrl(), "");
    String value = configured.isBlank() ? DEFAULT_BASE_URL : configured;
    while (value.endsWith("/")) {
      value = value.substring(0, value.length() - 1);
    }
    return value;
  }

  private static int intValue(Object value) {
    return value instanceof Number number ? number.intValue() : 0;
  }

  private static String stringValue(Object value, String fallback) {
    return value instanceof String text && !text.isBlank() ? text : fallback;
  }

  private static String blankDefault(String value, String fallback) {
    return value == null || value.isBlank() ? fallback : value.trim();
  }

  private static AppException aiUnavailable(String message) {
    return new AppException("AI_UNAVAILABLE", message, HttpStatus.SERVICE_UNAVAILABLE, Map.of());
  }
}
