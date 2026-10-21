package com.certifind.controller;

import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.exception.InvalidSearchRequestException;
import com.certifind.service.SearchService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Slice test for {@link ApiExceptionHandler}.
 *
 * Uses @WebMvcTest so no JPA / DB context is loaded. SearchService is mocked
 * to control exactly which exceptions reach the handler.
 */
@WebMvcTest(controllers = {SearchController.class, ApiExceptionHandler.class})
class ApiExceptionHandlerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SearchService searchService;

    @Autowired
    private ObjectMapper objectMapper;

    // ------------------------------------------------------------------
    // Health endpoint — baseline, not handled by exception handler
    // ------------------------------------------------------------------

    @Test
    @DisplayName("GET /api/v1/health returns 200 with status UP")
    void health_returns200() throws Exception {
        mockMvc.perform(get("/api/v1/health"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.status").value("UP"));
    }

    // ------------------------------------------------------------------
    // InvalidSearchRequestException → 400 Bad Request
    // ------------------------------------------------------------------

    @Test
    @DisplayName("Service throws InvalidSearchRequestException → 400 with correct body shape")
    void search_invalidSearchRequest_returns400() throws Exception {
        when(searchService.search(any(SearchRequest.class)))
                .thenThrow(new InvalidSearchRequestException(
                        "No sector mapping found. Enter a supported ATECO code or sector activity."));

        String body = objectMapper.writeValueAsString(
                new SearchRequest("ISO 9001", "unknown sector", null));

        mockMvc.perform(post("/api/v1/search")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.error").value("Bad Request"))
                .andExpect(jsonPath("$.message").value(
                        "No sector mapping found. Enter a supported ATECO code or sector activity."))
                .andExpect(jsonPath("$.timestamp").exists());
    }

    @Test
    @DisplayName("InvalidSearchRequestException with null message does not NPE — returns generic message")
    void search_nullMessage_doesNotThrowNpe() throws Exception {
        // Previously Map.of(..., exception.getMessage()) would NPE here
        // because Map.of rejects null values.
        when(searchService.search(any(SearchRequest.class)))
                .thenThrow(new InvalidSearchRequestException(null));

        String body = objectMapper.writeValueAsString(
                new SearchRequest("ISO 9001", "any sector", null));

        mockMvc.perform(post("/api/v1/search")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                // handler must not propagate as 500 — message falls back to "Invalid request"
                .andExpect(jsonPath("$.message").value("Invalid request"));
    }

    // ------------------------------------------------------------------
    // @Valid rejection (MethodArgumentNotValidException) → 400
    // ------------------------------------------------------------------

    @Test
    @DisplayName("POST /api/v1/search with both sector fields blank is rejected by @Valid before service is called")
    void search_bothSectorFieldsBlank_validationRejects400() throws Exception {
        // Both atecoCode and sectorActivity are null/blank → @AssertTrue fires
        String body = objectMapper.writeValueAsString(
                new SearchRequest("ISO 9001", null, null));

        mockMvc.perform(post("/api/v1/search")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.status").value(400))
                .andExpect(jsonPath("$.message").value(
                        "atLeastOneSectorCriterionPresent: Provide at least one of: atecoCode, sectorActivity"));
    }

    // ------------------------------------------------------------------
    // IllegalArgumentException must NOT be mapped to 400
    // ------------------------------------------------------------------

    @Test
    @DisplayName("Unexpected IllegalArgumentException from service propagates as 500, not 400")
    void search_unexpectedIllegalArgument_propagatesAs500() throws Exception {
        // An IllegalArgumentException thrown by a JDK or Spring internal
        // should not be silently mapped to a user-facing 400.
        when(searchService.search(any(SearchRequest.class)))
                .thenThrow(new IllegalArgumentException("some internal bug"));

        String body = objectMapper.writeValueAsString(
                new SearchRequest("ISO 9001", "Asilo nido", "88.91.00"));

        mockMvc.perform(post("/api/v1/search")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isInternalServerError());
    }

    // ------------------------------------------------------------------
    // Happy path — handler is transparent on success
    // ------------------------------------------------------------------

    @Test
    @DisplayName("POST /api/v1/search with valid request returns 200 and response body")
    void search_validRequest_returns200() throws Exception {
        SearchResponse stubResponse = new SearchResponse("88.91.00", 37, "Education", 1, List.of());
        when(searchService.search(any(SearchRequest.class))).thenReturn(stubResponse);

        String body = objectMapper.writeValueAsString(
                new SearchRequest("ISO 9001", "Asilo nido", "88.91.00"));

        mockMvc.perform(post("/api/v1/search")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.resolvedEaCode").value(37))
                .andExpect(jsonPath("$.totalResults").value(1));
    }
}
