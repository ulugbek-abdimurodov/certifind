package com.certifind.dto;

import jakarta.validation.constraints.AssertTrue;

/**
 * Inbound search payload.
 *
 * <p>At least one of {@code atecoCode} or {@code sectorActivity} must be
 * non-blank. The constraint is expressed as a cross-field {@link AssertTrue}
 * so that a single, readable error message is returned instead of two
 * independent field errors.</p>
 *
 * <p>{@code isoStandard} is optional; the service defaults to ISO 9001 when
 * it is absent.</p>
 */
public record SearchRequest(
    String isoStandard,
    String sectorActivity,
    String atecoCode
) {
    @AssertTrue(message = "Provide at least one of: atecoCode, sectorActivity")
    public boolean isAtLeastOneSectorCriterionPresent() {
        return (atecoCode != null && !atecoCode.isBlank())
            || (sectorActivity != null && !sectorActivity.isBlank());
    }
}
