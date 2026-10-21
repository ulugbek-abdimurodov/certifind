package com.certifind.service;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.domain.CertificationBody;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.exception.InvalidSearchRequestException;
import com.certifind.repository.AccreditedScopeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class SearchService {

    private final SectorMappingResolver sectorMappingResolver;
    private final AccreditedScopeRepository accreditedScopeRepository;

    public SearchService(
            SectorMappingResolver sectorMappingResolver,
            AccreditedScopeRepository accreditedScopeRepository) {
        this.sectorMappingResolver = sectorMappingResolver;
        this.accreditedScopeRepository = accreditedScopeRepository;
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        String atecoCode = normalize(request.atecoCode());
        String sectorActivity = normalize(request.sectorActivity());
        // The @AssertTrue constraint on SearchRequest already rejects requests
        // where both fields are blank before we reach this point. The check
        // below is a defence-in-depth fallback (e.g. if the service is called
        // outside the HTTP layer in a future integration test).
        if (atecoCode == null && sectorActivity == null) {
            throw new InvalidSearchRequestException("Enter an ATECO code or sector activity.");
        }

        AtecoEaMapping resolvedMapping = sectorMappingResolver.resolve(atecoCode, sectorActivity);
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
