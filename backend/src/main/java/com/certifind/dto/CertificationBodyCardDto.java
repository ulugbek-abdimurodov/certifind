package com.certifind.dto;

import java.util.List;

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
    String scopeSection,
    List<AccreditationScopeDto> scopes
) {
    public CertificationBodyCardDto(
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
    ) {
        this(id, name, country, accreditationBodyCode, isIafMla, phone, email,
                website, address, proofUrl, eaCode, eaDescription, scopeSection, List.of());
    }
}