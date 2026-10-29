package com.certifind.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.domain.AccreditationBody;
import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.domain.CertificationBody;
import com.certifind.domain.EaSector;
import com.certifind.dto.AccreditationScopeDto;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchOptionsResponse;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.dto.SectorOption;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;
import com.certifind.repository.CertificationBodyRepository;
import com.certifind.repository.EaSectorRepository;

@Service
public class SearchService {

    private static final Pattern EA_CODE_PATTERN =
            Pattern.compile("\\bEA\\s*(\\d{1,2})\\b", Pattern.CASE_INSENSITIVE);
    private static final String DEFAULT_ISO = "ISO 9001";
    private static final String ALL_SECTORS = "Tutti gli standard e settori";

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
        Map<Integer, String> sectorNames = loadSectorNames();
        var sectors = accreditedScopeRepository.findDistinctEaCodes().stream()
                .map(code -> new SectorOption(code, sectorName(sectorNames, code)))
                .toList();
        return new SearchOptionsResponse(accreditedScopeRepository.findDistinctIsoStandards(), sectors);
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("La richiesta di ricerca non può essere vuota.");
        }

        // An ATECO/sector mapping takes precedence over an "EA nn" code typed in the sector field.
        AtecoEaMapping mapping = resolveMapping(request);
        Integer eaCode = mapping != null ? mapping.getEaCode() : parseEaCode(request.sectorActivity());
        if (eaCode == null) {
            throw new IllegalArgumentException("Settore di attività non riconosciuto. Inserisci un settore valido o un codice EA/ATECO supportato.");
        }
        int resolvedEaCode = eaCode;

        // ATECO can be null when matched purely by Activity Sector
        String resolvedAteco = mapping != null && isPresent(mapping.getAtecoCode())
                ? mapping.getAtecoCode()
                : "N/A (Solo Settore EA)";
        Map<Integer, String> sectorNames = loadSectorNames();
        String resolvedEaDesc = sectorName(sectorNames, resolvedEaCode);
        String iso = isPresent(request.isoStandard()) ? request.isoStandard().trim() : DEFAULT_ISO;

        // A body matches when one of its scopes covers the resolved EA sector; its card lists all its EA scopes.
        List<CertificationBodyCardDto> cards =
                groupByCertificationBody(accreditedScopeRepository.findActiveScopesWithCabAndAbByIso(iso))
                .values().stream()
                .flatMap(bodyScopes -> bodyScopes.stream()
                        .filter(scope -> Objects.equals(scope.getEaCode(), resolvedEaCode))
                        .findFirst()
                        .map(match -> {
                            List<AccreditationScopeDto> eaScopes = bodyScopes.stream()
                                    .filter(scope -> scope.getEaCode() != null)
                                    .map(scope -> toScopeDto(scope, sectorNames))
                                    .toList();
                            String scopeSection = eaScopes.stream()
                                    .map(AccreditationScopeDto::scopeSection)
                                    .distinct()
                                    .collect(Collectors.joining(" / "));
                            return toCard(match.getCertificationBody(), match.getProofUrl(),
                                    resolvedEaCode, resolvedEaDesc, scopeSection, eaScopes);
                        })
                        .stream())
                .toList();

        return new SearchResponse(resolvedAteco, resolvedEaCode, resolvedEaDesc, cards, false);
    }

    /** ATECO code first, then the sector text against Italian descriptions, then English EA descriptions. */
    private AtecoEaMapping resolveMapping(SearchRequest request) {
        Optional<AtecoEaMapping> mapping = isPresent(request.atecoCode())
                ? atecoEaMappingRepository.findFirstByAtecoCode(request.atecoCode().trim())
                : Optional.empty();
        if (mapping.isEmpty() && isPresent(request.sectorActivity())) {
            String keyword = request.sectorActivity().trim();
            mapping = atecoEaMappingRepository.findFirstByDescriptionContainingIgnoreCase(keyword)
                    .or(() -> atecoEaMappingRepository.findFirstByEaDescriptionContainingIgnoreCase(keyword));
        }
        return mapping.orElse(null);
    }

    @Transactional(readOnly = true)
    public SearchResponse findAllCompanies() {
        Map<Integer, String> sectorNames = loadSectorNames();
        Map<Integer, List<AccreditedScope>> scopesByBody =
                groupByCertificationBody(accreditedScopeRepository.findAllScopesWithCertificationBody());

        List<CertificationBodyCardDto> cards = certificationBodyRepository.findAllWithAccreditationBody()
                .stream()
                .map(cb -> {
                    List<AccreditationScopeDto> scopes = scopesByBody
                            .getOrDefault(cb.getId(), List.of())
                            .stream()
                            .map(scope -> toScopeDto(scope, sectorNames))
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

                    return toCard(
                            cb,
                            firstScope != null ? firstScope.proofUrl() : null,
                            firstScope != null && firstScope.eaCode() != null ? firstScope.eaCode() : 0,
                            firstScope != null ? firstScope.eaDescription() : ALL_SECTORS,
                            scopeSection.isBlank() ? "Nessun settore disponibile" : scopeSection,
                            scopes);
                })
                .toList();

        return new SearchResponse("Tutti", 0, ALL_SECTORS, cards, true);
    }

    private static boolean isPresent(String value) {
        return value != null && !value.isBlank();
    }

    private static Integer parseEaCode(String sectorActivity) {
        if (sectorActivity == null) return null;
        Matcher matcher = EA_CODE_PATTERN.matcher(sectorActivity);
        if (!matcher.find()) return null;
        int code = Integer.parseInt(matcher.group(1));
        return code >= 1 && code <= 39 ? code : null;
    }

    /** EA code -> display name (Italian when available, English otherwise), loaded in a single query. */
    private Map<Integer, String> loadSectorNames() {
        return eaSectorRepository.findAll().stream()
                .collect(Collectors.toMap(
                        EaSector::getCode,
                        sector -> isPresent(sector.getNameIt()) ? sector.getNameIt() : sector.getNameEn()));
    }

    private static String sectorName(Map<Integer, String> sectorNames, int eaCode) {
        return sectorNames.getOrDefault(eaCode, "EA " + eaCode);
    }

    private static Map<Integer, List<AccreditedScope>> groupByCertificationBody(List<AccreditedScope> scopes) {
        return scopes.stream()
                .collect(Collectors.groupingBy(
                        scope -> scope.getCertificationBody().getId(),
                        LinkedHashMap::new,
                        Collectors.toList()));
    }

    private static AccreditationScopeDto toScopeDto(AccreditedScope scope, Map<Integer, String> sectorNames) {
        Integer eaCode = scope.getEaCode();
        String description = eaCode == null ? "Non-EA scope" : sectorName(sectorNames, eaCode);
        String scopeSection = isPresent(scope.getScopeSection())
                ? scope.getScopeSection()
                : (eaCode == null ? "Accredited scope" : description) + " (" + scope.getIsoStandard() + ")";
        return new AccreditationScopeDto(eaCode, description, scopeSection, scope.getProofUrl(), scope.getIsoStandard());
    }

    private static CertificationBodyCardDto toCard(
            CertificationBody cb,
            String proofUrl,
            int eaCode,
            String eaDescription,
            String scopeSection,
            List<AccreditationScopeDto> scopes) {
        AccreditationBody ab = cb.getAccreditationBody();
        return new CertificationBodyCardDto(
                cb.getId(),
                cb.getName(),
                cb.getCountry(),
                ab != null ? ab.getCode() : "N/A",
                ab != null && Boolean.TRUE.equals(ab.getIsIafMla()),
                cb.getPhone(),
                cb.getEmail(),
                cb.getWebsite(),
                cb.getAddress(),
                proofUrl,
                eaCode,
                eaDescription,
                scopeSection,
                scopes);
    }
}
