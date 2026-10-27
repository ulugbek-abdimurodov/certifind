package com.certifind.dto;

public record AccreditationScopeDto(
        int eaCode,
        String eaDescription,
        String scopeSection,
        String proofUrl
) {}
