package com.pillarwise.common;

import jakarta.servlet.http.HttpServletRequest;
import java.time.Clock;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
  private final Clock clock;

  public GlobalExceptionHandler(Clock clock) {
    this.clock = clock;
  }

  @ExceptionHandler(AppException.class)
  ResponseEntity<ApiResponse<Void>> handleApp(AppException ex, HttpServletRequest request) {
    ApiError error = new ApiError(ex.code(), ex.getMessage(), ex.details());
    return ResponseEntity.status(ex.status()).body(ApiResponse.fail(error, requestId(request), clock));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  ResponseEntity<ApiResponse<Void>> handleValidation(MethodArgumentNotValidException ex, HttpServletRequest request) {
    Map<String, Object> details = new LinkedHashMap<>();
    for (FieldError fieldError : ex.getBindingResult().getFieldErrors()) {
      details.put(fieldError.getField(), fieldError.getDefaultMessage());
    }
    ApiError error = new ApiError("VALIDATION_ERROR", "Check your details.", details);
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ApiResponse.fail(error, requestId(request), clock));
  }

  @ExceptionHandler(Exception.class)
  ResponseEntity<ApiResponse<Void>> handleOther(Exception ex, HttpServletRequest request) {
    ApiError error = new ApiError(
        "INTERNAL_ERROR",
        "Something went wrong. Please try again.",
        Map.of("requestId", requestId(request))
    );
    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(ApiResponse.fail(error, requestId(request), clock));
  }

  private static String requestId(HttpServletRequest request) {
    Object id = request.getAttribute(RequestIdFilter.REQUEST_ID_ATTRIBUTE);
    return id == null ? "req_unknown" : id.toString();
  }
}
