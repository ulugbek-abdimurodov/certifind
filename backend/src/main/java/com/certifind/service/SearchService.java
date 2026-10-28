package com.certifind.service;

import java.util.List;
import java.util.Optional;
import java.util.Map;
import java.util.LinkedHashMap;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.domain.CertificationBody;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.AccreditationScopeDto;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchOptionsResponse;
import com.certifind.dto.SectorOption;
import com.certifind.dto.SearchResponse;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;
import com.certifind.repository.CertificationBodyRepository;
import com.certifind.repository.EaSectorRepository;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class SearchService {

    private final AtecoEaMappingRepository atecoEaMappingRepository;
    private final AccreditedScopeRepository accreditedScopeRepository;
    private final CertificationBodyRepository certificationBodyRepository;
    private final EaSectorRepository eaSectorRepository;

    public SearchService(
            AtecoEaMappingRepository atecoEaMappingRepository,
            AccreditedScopeRepository accreditedScopeRepository,
            CertificationBodyRepository certificationBodyRepository,
            EaSectorRepository eaSectorRepository) {
        this.atecoEaMappingRepository = atecoEaMappingRepository;
        this.accreditedScopeRepository = accreditedScopeRepository;
        this.certificationBodyRepository = certificationBodyRepository;
        this.eaSectorRepository = eaSectorRepository;
    }

    @Transactional(readOnly = true)
    public SearchOptionsResponse getOptions() {
        var sectorNames = eaSectorRepository.findAllByOrderByCodeAsc().stream()
                .collect(java.util.stream.Collectors.toMap(
                        sector -> sector.getCode(),
                        sector -> sector.getNameIt() != null && !sector.getNameIt().isBlank()
                                ? sector.getNameIt()
                                : sector.getNameEn()
                ));
        var sectors = accreditedScopeRepository.findDistinctEaCodes().stream()
                .map(code -> new SectorOption(code, sectorNames.getOrDefault(code, "EA " + code)))
                .toList();
        return new SearchOptionsResponse(accreditedScopeRepository.findDistinctIsoStandards(), sectors);
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

        Integer directEaCode = parseEaCode(request.sectorActivity());
        AtecoEaMapping resolvedMapping = mapping.orElse(null);
        if (resolvedMapping == null && directEaCode == null) {
            throw new IllegalArgumentException("Settore di attività non riconosciuto. Inserisci un settore valido o un codice EA/ATECO supportato.");
        }

        // ATECO can be null when matched purely by Activity Sector
        String resolvedAteco = resolvedMapping != null && resolvedMapping.getAtecoCode() != null && !resolvedMapping.getAtecoCode().isBlank()
                ? resolvedMapping.getAtecoCode()
                : "N/A (Solo Settore EA)";
        int resolvedEaCode = resolvedMapping != null ? resolvedMapping.getEaCode() : directEaCode;
        String resolvedEaDesc = getSectorName(resolvedEaCode);

        // 3. Mandatory ISO Standard (defaults to ISO 9001 if blank)
        String iso = (request.isoStandard() != null && !request.isoStandard().isBlank())
                ? request.isoStandard().trim()
                : "ISO 9001";

        List<AccreditedScope> matchingScopes =
                accreditedScopeRepository.findActiveScopesWithCabAndAb(iso, resolvedEaCode);
        Map<Integer, List<AccreditedScope>> allScopesByBody =
                accreditedScopeRepository.findActiveScopesWithCabAndAbByIso(iso).stream()
                        .collect(Collectors.groupingBy(
                                scope -> scope.getCertificationBody().getId(),
                                LinkedHashMap::new,
                                Collectors.toList()));

        List<CertificationBodyCardDto> cards = matchingScopes.stream()
                .collect(Collectors.toMap(
                        scope -> scope.getCertificationBody().getId(),
                        scope -> scope,
                        (first, ignored) -> first,
                        LinkedHashMap::new))
                .values().stream()
                .map(scope -> {
                    CertificationBody cb = scope.getCertificationBody();
                    List<AccreditationScopeDto> groupedScopes = allScopesByBody
                            .getOrDefault(cb.getId(), List.of())
                            .stream()
                            .filter(candidate -> candidate.getEaCode() != null)
                            .map(candidate -> new AccreditationScopeDto(
                                    candidate.getEaCode(),
                                    getSectorName(candidate.getEaCode()),
                                    candidate.getScopeSection() != null && !candidate.getScopeSection().isBlank()
                                            ? candidate.getScopeSection()
                                            : getSectorName(candidate.getEaCode()) + " (" + iso + ")",
                                    candidate.getProofUrl(),
                                    candidate.getIsoStandard()))
                            .toList();
                    String scopeSection = groupedScopes.stream()
                            .map(AccreditationScopeDto::scopeSection)
                            .distinct()
                            .collect(Collectors.joining(" / "));

                    return new CertificationBodyCardDto(
                            cb.getId(), cb.getName(), cb.getCountry(),
                            cb.getAccreditationBody() != null ? cb.getAccreditationBody().getCode() : "N/A",
                            cb.getAccreditationBody() != null
                                    && Boolean.TRUE.equals(cb.getAccreditationBody().getIsIafMla()),
                            cb.getPhone(), cb.getEmail(), cb.getWebsite(), cb.getAddress(),
                            scope.getProofUrl(), resolvedEaCode, resolvedEaDesc, scopeSection, groupedScopes);
                }).toList();

        return new SearchResponse(resolvedAteco, resolvedEaCode, resolvedEaDesc, cards.size(), cards, false);
    }

    private Integer parseEaCode(String sectorActivity) {
        if (sectorActivity == null) return null;
        Matcher matcher = Pattern.compile("\\bEA\\s*(\\d{1,2})\\b", Pattern.CASE_INSENSITIVE)
                .matcher(sectorActivity);
        if (!matcher.find()) return null;
        int code = Integer.parseInt(matcher.group(1));
        return code >= 1 && code <= 39 ? code : null;
    }

    private String getSectorName(int eaCode) {
        return eaSectorRepository.findById(eaCode)
                .map(sector -> sector.getNameIt() != null && !sector.getNameIt().isBlank()
                        ? sector.getNameIt()
                        : sector.getNameEn())
                .orElse("EA " + eaCode);
    }

    @Transactional(readOnly = true)
    public SearchResponse findAllCompanies() {
        Map<Integer, List<AccreditedScope>> scopesByBody =
                accreditedScopeRepository.findAllScopesWithCertificationBody().stream()
                        .collect(Collectors.groupingBy(
                                scope -> scope.getCertificationBody().getId(),
                                LinkedHashMap::new,
                                Collectors.toList()));

        List<CertificationBodyCardDto> cards = certificationBodyRepository.findAllWithAccreditationBody()
                .stream()
                .map(cb -> {
                    List<AccreditationScopeDto> scopes = scopesByBody
                            .getOrDefault(cb.getId(), List.of())
                            .stream()
                            .map(scope -> new AccreditationScopeDto(
                                    scope.getEaCode(),
                                    scope.getEaCode() == null ? "Non-EA scope" : getSectorName(scope.getEaCode()),
                                    scope.getScopeSection() != null && !scope.getScopeSection().isBlank()
                                            ? scope.getScopeSection()
                                            : (scope.getEaCode() == null ? "Accredited scope" : getSectorName(scope.getEaCode()))
                                                    + " (" + scope.getIsoStandard() + ")",
                                    scope.getProofUrl(),
                                    scope.getIsoStandard()))
                            .collect(Collectors.collectingAndThen(
                                    Collectors.toMap(
                                            scope -> scope.eaCode() == null
                                                    ? "STANDARD:" + scope.isoStandard()
                                                    : "EA:" + scope.eaCode(),
                                            scope -> scope,
                                            (first, ignored) -> first,
                                            LinkedHashMap::new),
                                    values -> values.values().stream().toList()));
                    String scopeSection = scopes.stream()
                            .map(scope -> scope.eaCode() == null
                                    ? scope.isoStandard() + ": " + scope.scopeSection()
                                    : "EA " + scope.eaCode() + ": " + scope.scopeSection())
                            .collect(Collectors.joining(" / "));
                    AccreditationScopeDto firstScope = scopes.isEmpty() ? null : scopes.get(0);

                    return new CertificationBodyCardDto(
                        cb.getId(),
                        cb.getName(),
                        cb.getCountry(),
                        cb.getAccreditationBody() != null ? cb.getAccreditationBody().getCode() : "N/A",
                        cb.getAccreditationBody() != null
                                && Boolean.TRUE.equals(cb.getAccreditationBody().getIsIafMla()),
                        cb.getPhone(),
                        cb.getEmail(),
                        cb.getWebsite(),
                        cb.getAddress(),
                        firstScope != null ? firstScope.proofUrl() : null,
                        firstScope != null && firstScope.eaCode() != null ? firstScope.eaCode() : 0,
                        firstScope != null ? firstScope.eaDescription() : "Tutti gli standard e settori",
                        scopeSection.isBlank() ? "Nessun settore disponibile" : scopeSection,
                        scopes);
                })
                .toList();

        return new SearchResponse(
                "Tutti",
                0,
                "Tutti gli standard e settori",
                cards.size(),
                cards,
                true
        );
    }
}
