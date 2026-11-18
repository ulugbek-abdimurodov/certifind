package com.certifind.dto;

/**
 * Management system search. {@code isoStandard} and {@code sectorActivity} pick a standard and
 * an EA sector; {@code keyword} is free text matched against everything stored about a body,
 * its accreditations and their scopes. With a keyword, standard and sector are optional filters.
 */
public record SearchRequest(
    String isoStandard,
    String sectorActivity,
    String keyword
) {
    public SearchRequest(String isoStandard, String sectorActivity) {
        this(isoStandard, sectorActivity, null);
    }
}
