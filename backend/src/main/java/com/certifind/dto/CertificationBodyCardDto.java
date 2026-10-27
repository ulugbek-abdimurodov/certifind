package com.certifind.dto;

public record CertificationBodyCardDto(
    Integer id,
    String name,
    String country,
    String accreditationBodyCode,
    boolean isIafMla,
    String phone,
    String email,
    String website,
    String address,
    String proofUrl,
    int eaCode,
    String eaDescription,
    String scopeSection
) {}