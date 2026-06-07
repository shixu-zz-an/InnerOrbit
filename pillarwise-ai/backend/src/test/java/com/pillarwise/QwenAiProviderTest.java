package com.pillarwise;

import static org.assertj.core.api.Assertions.assertThat;

import com.pillarwise.ai.AiCompletion;
import com.pillarwise.ai.AiMessage;
import com.pillarwise.ai.AiRequest;
import com.pillarwise.ai.QwenAiProvider;
import com.pillarwise.config.AppProperties;
import com.sun.net.httpserver.HttpServer;
import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.springframework.web.client.RestClient;

class QwenAiProviderTest {
  private HttpServer server;

  @AfterEach
  void stopServer() {
    if (server != null) {
      server.stop(0);
    }
  }

  @Test
  void callsOpenAiCompatibleChatCompletionsEndpoint() throws IOException {
    AtomicReference<String> authorization = new AtomicReference<>();
    AtomicReference<String> body = new AtomicReference<>();
    server = HttpServer.create(new InetSocketAddress("127.0.0.1", 0), 0);
    server.createContext("/chat/completions", exchange -> {
      authorization.set(exchange.getRequestHeaders().getFirst("Authorization"));
      body.set(new String(exchange.getRequestBody().readAllBytes(), StandardCharsets.UTF_8));
      byte[] response = """
          {
            "model": "qwen-plus",
            "choices": [
              {
                "message": {
                  "role": "assistant",
                  "content": "{\\"headline\\":\\"Clear\\",\\"summary\\":\\"Grounded\\",\\"sections\\":[{\\"title\\":\\"Pattern\\",\\"body\\":\\"Useful body\\"}],\\"practicalStep\\":\\"Act\\",\\"reflectionQuestion\\":\\"Ask?\\"}"
                }
              }
            ],
            "usage": {"prompt_tokens": 12, "completion_tokens": 24}
          }
          """.getBytes(StandardCharsets.UTF_8);
      exchange.getResponseHeaders().set("Content-Type", "application/json");
      exchange.sendResponseHeaders(200, response.length);
      exchange.getResponseBody().write(response);
      exchange.close();
    });
    server.start();
    String baseUrl = "http://127.0.0.1:" + server.getAddress().getPort();
    AppProperties properties = new AppProperties(
        "test",
        new AppProperties.Sqlite(":memory:"),
        new AppProperties.Ai("qwen", baseUrl, "test-key", "qwen-plus"),
        new AppProperties.Auth("dev")
    );
    QwenAiProvider provider = new QwenAiProvider(properties, RestClient.builder());

    AiCompletion completion = provider.complete(new AiRequest(
        "Return JSON only.",
        List.of(new AiMessage("user", "Hello")),
        "json_object",
        0.2,
        null
    ));

    assertThat(authorization.get()).isEqualTo("Bearer test-key");
    assertThat(body.get()).contains("\"model\":\"qwen-plus\"");
    assertThat(body.get()).contains("\"response_format\":{\"type\":\"json_object\"}");
    assertThat(body.get()).contains("\"enable_thinking\":false");
    assertThat(completion.provider()).isEqualTo("qwen");
    assertThat(completion.model()).isEqualTo("qwen-plus");
    assertThat(completion.inputTokens()).isEqualTo(12);
    assertThat(completion.outputTokens()).isEqualTo(24);
    assertThat(completion.content()).contains("\"headline\":\"Clear\"");
  }
}
