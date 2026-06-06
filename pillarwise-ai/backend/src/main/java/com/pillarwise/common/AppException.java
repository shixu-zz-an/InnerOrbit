package com.pillarwise.common;

import java.util.Map;
import org.springframework.http.HttpStatus;

public class AppException extends RuntimeException {
  private final String code;
  private final HttpStatus status;
  private final Map<String, Object> details;

  public AppException(String code, String message, HttpStatus status) {
    this(code, message, status, Map.of());
  }

  public AppException(String code, String message, HttpStatus status, Map<String, Object> details) {
    super(message);
    this.code = code;
    this.status = status;
    this.details = details;
  }

  public String code() {
    return code;
  }

  public HttpStatus status() {
    return status;
  }

  public Map<String, Object> details() {
    return details;
  }

  public static AppException unauthorized() {
    return new AppException("UNAUTHORIZED", "Session expired. Please start again.", HttpStatus.UNAUTHORIZED);
  }

  public static AppException notFound(String message) {
    return new AppException("NOT_FOUND", message, HttpStatus.NOT_FOUND);
  }

  public static AppException validation(String message, Map<String, Object> details) {
    return new AppException("VALIDATION_ERROR", message, HttpStatus.BAD_REQUEST, details);
  }

  public static AppException entitlement(String context) {
    return new AppException(
        "ENTITLEMENT_REQUIRED",
        "Unlock Premium to continue this reading.",
        HttpStatus.PAYMENT_REQUIRED,
        Map.of("paywall", context)
    );
  }
}
