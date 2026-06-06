package com.pillarwise.common;

import jakarta.servlet.http.HttpServletRequest;
import java.time.Clock;
import org.springframework.stereotype.Component;

@Component
public class ResponseFactory {
  private final Clock clock;

  public ResponseFactory(Clock clock) {
    this.clock = clock;
  }

  public <T> ApiResponse<T> ok(T data, HttpServletRequest request) {
    Object id = request.getAttribute(RequestIdFilter.REQUEST_ID_ATTRIBUTE);
    return ApiResponse.ok(data, id == null ? "req_unknown" : id.toString(), clock);
  }
}
