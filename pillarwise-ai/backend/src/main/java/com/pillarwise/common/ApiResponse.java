package com.pillarwise.common;

import java.time.Clock;
import java.time.Instant;

public record ApiResponse<T>(
    boolean success,
    T data,
    ApiError error,
    ApiMeta meta
) {
  public static <T> ApiResponse<T> ok(T data, String requestId, Clock clock) {
    return new ApiResponse<>(true, data, null, new ApiMeta(requestId, Instant.now(clock).toString()));
  }

  public static ApiResponse<Void> fail(ApiError error, String requestId, Clock clock) {
    return new ApiResponse<>(false, null, error, new ApiMeta(requestId, Instant.now(clock).toString()));
  }
}
