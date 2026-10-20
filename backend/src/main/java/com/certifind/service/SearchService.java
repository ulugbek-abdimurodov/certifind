package com.certifind.service;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.domain.CertificationBody;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
public class SearchService {

    private final AtecoEaMappingRepository atecoEaMappingRepository;
    private final AccreditedScopeRepository accreditedScopeRepository;

    public SearchService(
            AtecoEaMappingRepository atecoEaMappingRepository,
            AccreditedScopeRepository accreditedScopeRepository) {
        this.atecoEaMappingRepository = atecoEaMappingRepository;
        this.accreditedScopeRepository = accreditedScopeRepository;
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Search criteria are required.");
        }

        String atecoCode = normalize(request.atecoCode());
        String sectorActivity = normalize(request.sectorActivity());
        if (atecoCode == null && sectorActivity == null) {
            throw new IllegalArgumentException("Enter an ATECO code or sector activity.");
        }

        Optional<AtecoEaMapping> mapping = Optional.empty();

        if (atecoCode != null) {
            mapping = atecoEaMappingRepository.findByAtecoCode(atecoCode);
        }
        if (mapping.isEmpty() && sectorActivity != null) {
            mapping = atecoEaMappingRepository
                    .findFirstByDescriptionContainingIgnoreCase(sectorActivity);
        }

        AtecoEaMapping resolvedMapping = mapping.orElseThrow(() -> new IllegalArgumentException(
                "No sector mapping found. Enter a supported ATECO code or sector activity."));
        String resolvedAteco = resolvedMapping.getAtecoCode();
        int resolvedEaCode = resolvedMapping.getEaCode();
        String resolvedEaDesc = resolvedMapping.getEaDescription();

        String iso = (normalize(request.isoStandard()) != null)
                ? normalize(request.isoStandard())
                : "ISO 9001";

        List<AccreditedScope> scopes = accreditedScopeRepository.findActiveScopesWithCabAndAb(iso, resolvedEaCode);

        List<CertificationBodyCardDto> cards = scopes.stream().map(scope -> {
            CertificationBody cb = scope.getCertificationBody();
            return new CertificationBodyCardDto(
                    cb.getId(),
                    cb.getName(),
                    cb.getCountry(),
                    cb.getAccreditationBody() != null ? cb.getAccreditationBody().getCode() : "N/A",
                    cb.getAccreditationBody() != null && Boolean.TRUE.equals(cb.getAccreditationBody().getIsIafMla()),
                    Boolean.TRUE.equals(cb.getHasItalianAuditors()),
                    Boolean.TRUE.equals(cb.getIsCommercialPartner()),
                    cb.getPhone(),
                    cb.getEmail(),
                    cb.getWebsite(),
                    cb.getAddress(),
                    scope.getProofUrl(),
                    scope.getEaCode(),
                    resolvedEaDesc,
                    scope.getScopeSection() != null ? scope.getScopeSection()
                            : "Certificazione generale conforme allo standard ISO");
        }).sorted(java.util.Comparator.comparing(CertificationBodyCardDto::name, String.CASE_INSENSITIVE_ORDER))
                .toList();

        return new SearchResponse(resolvedAteco, resolvedEaCode, resolvedEaDesc, cards.size(), cards);
    }

    private String normalize(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        return value.trim();
    }
}
