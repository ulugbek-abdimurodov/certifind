package com.certifind.dto;

import java.util.List;

public record SearchResponse(
    String resolvedAteco,
    int resolvedEaCode,
    String resolvedEaDescription,
    List<CertificationBodyCardDto> results,
    boolean directory
) {}
