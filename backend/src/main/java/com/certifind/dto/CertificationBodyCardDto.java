package com.certifind.dto;

import java.time.LocalDate;
import java.util.List;

public record CertificationBodyCardDto(
    Integer id,
    String name,
    String country,
    String accreditationBodyCode,
    String accreditationBodyWebsite,
    /** Every AB with a valid right behind this card; the card's own AB comes first. */
    List<String> accreditationBodyCodes,
    String phone,
    String email,
    String website,
    String address,
    String sourceUrl,
    LocalDate verifiedAt,
    String proofUrl,
    int eaCode,
    String eaDescription,
    String scopeSection,
    /** Distinct certification standards; the scope rows come from /companies/{id}/scopes. */
    List<String> standards,
    LocalDate expiryDate
) {}
