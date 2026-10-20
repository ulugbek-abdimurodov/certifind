package com.certifind.dto;

public record CertificationBodyCardDto(
    Integer id,
    String name,
    String country,
    String accreditationBodyCode,
    boolean isIafMla,
    boolean hasItalianAuditors,
    boolean isCommercialPartner,
    String phone,
    String email,
    String website,
    String address,
    String proofUrl,
    int eaCode,
    String eaDescription
) {}
