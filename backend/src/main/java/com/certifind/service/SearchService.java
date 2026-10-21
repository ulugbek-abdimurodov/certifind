package com.certifind.service;

import java.util.Comparator;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.domain.CertificationBody;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;

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
            throw new IllegalArgumentException("La richiesta di ricerca non può essere vuota.");
        }

        Optional<AtecoEaMapping> mapping = Optional.empty();

        // 1. Optional ATECO lookup (if user provided an ATECO code)
        if (request.atecoCode() != null && !request.atecoCode().isBlank()) {
            mapping = atecoEaMappingRepository.findFirstByAtecoCode(request.atecoCode().trim());
        }

        // 2. Mandatory Activity Sector lookup (matches Italian description or English EA description)
        if (mapping.isEmpty() && request.sectorActivity() != null && !request.sectorActivity().isBlank()) {
            String keyword = request.sectorActivity().trim();
            mapping = atecoEaMappingRepository.findFirstByDescriptionContainingIgnoreCase(keyword)
                    .or(() -> atecoEaMappingRepository.findFirstByEaDescriptionContainingIgnoreCase(keyword));
        }

        AtecoEaMapping resolvedMapping = mapping.orElseThrow(() ->
                new IllegalArgumentException("Settore di attività non riconosciuto. Inserisci un settore valido (es. Asilo nido, Software, Costruzione, Ingegneria) o un codice ATECO supportato."));

        // ATECO can be null when matched purely by Activity Sector
        String resolvedAteco = (resolvedMapping.getAtecoCode() != null && !resolvedMapping.getAtecoCode().isBlank())
                ? resolvedMapping.getAtecoCode()
                : "N/A (Solo Settore EA)";
        int resolvedEaCode = resolvedMapping.getEaCode();
        String resolvedEaDesc = resolvedMapping.getEaDescription();

        // 3. Mandatory ISO Standard (defaults to ISO 9001 if blank)
        String iso = (request.isoStandard() != null && !request.isoStandard().isBlank())
                ? request.isoStandard().trim()
                : "ISO 9001";

        List<AccreditedScope> scopes = accreditedScopeRepository.findActiveScopesWithCabAndAb(iso, resolvedEaCode);

        List<CertificationBodyCardDto> cards = scopes.stream().map(scope -> {
            CertificationBody cb = scope.getCertificationBody();
            String scopeSection = (scope.getScopeSection() != null && !scope.getScopeSection().isBlank())
                    ? scope.getScopeSection()
                    : resolvedEaDesc + " (" + iso + ")";

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
                    scopeSection
            );
        }).sorted(
                Comparator.comparing(CertificationBodyCardDto::isCommercialPartner).reversed()
                        .thenComparing(CertificationBodyCardDto::name, String.CASE_INSENSITIVE_ORDER)
        ).toList();

        return new SearchResponse(resolvedAteco, resolvedEaCode, resolvedEaDesc, cards.size(), cards);
    }
}