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
        Optional<AtecoEaMapping> mapping = Optional.empty();

        if (request.atecoCode() != null && !request.atecoCode().isBlank()) {
            mapping = atecoEaMappingRepository.findByAtecoCode(request.atecoCode().trim());
        }
        if (mapping.isEmpty() && request.sectorActivity() != null && !request.sectorActivity().isBlank()) {
            mapping = atecoEaMappingRepository
                    .findFirstByDescriptionContainingIgnoreCase(request.sectorActivity().trim());
        }

        AtecoEaMapping resolvedMapping = mapping.orElseThrow(() -> new IllegalArgumentException(
                "No sector mapping found. Enter a supported ATECO code or sector activity."));
        String resolvedAteco = resolvedMapping.getAtecoCode();
        int resolvedEaCode = resolvedMapping.getEaCode();
        String resolvedEaDesc = resolvedMapping.getEaDescription();

        String iso = (request.isoStandard() != null && !request.isoStandard().isBlank())
                ? request.isoStandard().trim()
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
}
