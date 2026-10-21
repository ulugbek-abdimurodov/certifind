package com.certifind.controller;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.certifind.exception.InvalidSearchRequestException;

@RestControllerAdvice
public class ApiExceptionHandler {

    /**
     * Domain validation errors — e.g. unresolvable ATECO / sector-activity input.
     *
     * <p>Uses {@link InvalidSearchRequestException} rather than the raw
     * {@link IllegalArgumentException} so that unexpected JDK/Spring
     * {@code IllegalArgumentException}s are not accidentally swallowed as
     * user errors and still surface as 500s.</p>
     *
     * <p>{@link java.util.Map#of} throws {@link NullPointerException} when any
     * value is {@code null}, so we use a {@link LinkedHashMap} and guard the
     * message explicitly.</p>
     */
    @ExceptionHandler(InvalidSearchRequestException.class)
    public ResponseEntity<Map<String, Object>> handleInvalidSearchRequest(
            InvalidSearchRequestException exception) {
        return badRequestBody(exception.getMessage());
    }

    /**
     * Bean-validation failures triggered by {@code @Valid} on the request body.
     * Collects all field errors into a single, human-readable string.
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationErrors(
            MethodArgumentNotValidException exception) {
        String message = exception.getBindingResult()
                .getFieldErrors()
                .stream()
                .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
                .sorted()
                .collect(java.util.stream.Collectors.joining("; "));
        return badRequestBody(message.isBlank() ? "Invalid request" : message);
    }

    // ------------------------------------------------------------------
    // Shared helper
    // ------------------------------------------------------------------

    private ResponseEntity<Map<String, Object>> badRequestBody(String message) {
        Map<String, Object> body = new LinkedHashMap<>();
        body.put("timestamp", Instant.now().toString());
        body.put("status", HttpStatus.BAD_REQUEST.value());
        body.put("error", "Bad Request");
        body.put("message", message != null ? message : "Invalid request");
        return ResponseEntity.badRequest().body(body);
    }
}
