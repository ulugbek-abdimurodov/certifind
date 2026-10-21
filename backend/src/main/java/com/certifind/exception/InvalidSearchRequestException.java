package com.certifind.exception;

/**
 * Thrown when a search request contains a logically invalid or unresolvable
 * combination of inputs (e.g. an ATECO code that has no EA mapping).
 *
 * <p>Using a dedicated type instead of {@link IllegalArgumentException} lets
 * {@link com.certifind.controller.ApiExceptionHandler} map <em>only our own</em>
 * validation failures to HTTP 400, and leaves unexpected {@code IllegalArgumentException}s
 * thrown by the JDK or Spring to propagate as 500s where they belong.</p>
 */
public class InvalidSearchRequestException extends RuntimeException {

    public InvalidSearchRequestException(String message) {
        super(message);
    }
}
