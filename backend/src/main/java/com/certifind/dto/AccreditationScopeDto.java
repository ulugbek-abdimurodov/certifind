package com.certifind.dto;

public record AccreditationScopeDto(
        Integer eaCode,
        String eaDescription,
        String scopeSection,
        String proofUrl,
        String isoStandard
) {}
