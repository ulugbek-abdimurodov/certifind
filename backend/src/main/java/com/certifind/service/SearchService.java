package com.certifind.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.domain.Accreditation;
import com.certifind.domain.AccreditationBody;
import com.certifind.domain.AccreditedScope;
import com.certifind.domain.CertificationBody;
import com.certifind.domain.EaSector;
import com.certifind.domain.SectorKeyword;
import com.certifind.dto.AccreditationScopeDto;
import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchOptionsResponse;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.dto.SectorOption;
import com.certifind.repository.AccreditationRepository;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.CertificationBodyRepository;
import com.certifind.repository.EaSectorRepository;
import com.certifind.repository.SectorKeywordRepository;

@Service
public class SearchService {

    private static final Pattern EA_CODE_PATTERN =
            Pattern.compile("\\bEA\\s*(\\d{1,2})\\b", Pattern.CASE_INSENSITIVE);
    private static final String DEFAULT_ISO = "ISO 9001";
    private static final String ALL_SECTORS = "Tutti gli standard e settori";

    private final SectorKeywordRepository sectorKeywordRepository;
    private final AccreditedScopeRepository accreditedScopeRepository;
    private final AccreditationRepository accreditationRepository;
    private final CertificationBodyRepository certificationBodyRepository;
    private final EaSectorRepository eaSectorRepository;

    public SearchService(
            SectorKeywordRepository sectorKeywordRepository,
            AccreditedScopeRepository accreditedScopeRepository,
            AccreditationRepository accreditationRepository,
            CertificationBodyRepository certificationBodyRepository,
            EaSectorRepository eaSectorRepository) {
        this.sectorKeywordRepository = sectorKeywordRepository;
        this.accreditedScopeRepository = accreditedScopeRepository;
        this.accreditationRepository = accreditationRepository;
        this.certificationBodyRepository = certificationBodyRepository;
        this.eaSectorRepository = eaSectorRepository;
    }

    @Transactional(readOnly = true)
    public SearchOptionsResponse getOptions() {
        Map<Integer, String> sectorNames = loadSectorNames();
        var sectors = accreditedScopeRepository.findDistinctEaCodes().stream()
                .map(code -> new SectorOption(code, sectorName(sectorNames, code)))
                .toList();
        return new SearchOptionsResponse(accreditedScopeRepository.findDistinctCertificationStandards(), sectors);
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("La richiesta di ricerca non può essere vuota.");
        }

        // An explicit "EA nn" code wins; otherwise the sector text is resolved through the keyword vocabulary.
        Integer eaCode = parseEaCode(request.sectorActivity());
        if (eaCode == null) {
            eaCode = resolveKeyword(request.sectorActivity());
        }
        if (eaCode == null) {
            throw new IllegalArgumentException("Settore di attività non riconosciuto. Inserisci un settore valido o un codice EA supportato.");
        }
        int resolvedEaCode = eaCode;

        Map<Integer, String> sectorNames = loadSectorNames();
        String resolvedEaDesc = sectorName(sectorNames, resolvedEaCode);
        String iso = isPresent(request.isoStandard()) ? request.isoStandard().trim() : DEFAULT_ISO;

        // A body matches when one of its valid rights for the standard covers the resolved EA sector;
        // its card lists all its EA sectors for that standard.
        List<CertificationBodyCardDto> cards =
                groupByCertificationBody(accreditedScopeRepository.findValidScopesByStandard(iso))
                .values().stream()
                .flatMap(bodyScopes -> bodyScopes.stream()
                        .filter(scope -> Objects.equals(scope.getEaCode(), resolvedEaCode))
                        .findFirst()
                        .map(match -> {
                            List<AccreditationScopeDto> eaScopes = bodyScopes.stream()
                                    .map(scope -> toScopeDto(scope, sectorNames))
                                    .toList();
                            String scopeSection = match.getAccreditation().getAccreditationStandard()
                                    + " · " + match.getAccreditation().getCertificateNumber()
                                    + " · " + toScopeDto(match, sectorNames).scopeSection();
                            return toCard(match.getCertificationBody(), match.getAccreditation(),
                                    resolvedEaCode, resolvedEaDesc, scopeSection, eaScopes);
                        })
                        .stream())
                .toList();

        return new SearchResponse(resolvedEaCode, resolvedEaDesc, cards, false);
    }

    private Integer resolveKeyword(String sectorActivity) {
        if (!isPresent(sectorActivity)) {
            return null;
        }
        return sectorKeywordRepository.findBestMatch(sectorActivity.trim())
                .map(SectorKeyword::getEaCode)
                .orElse(null);
    }

    @Transactional(readOnly = true)
    public SearchResponse findAllCompanies() {
        Map<Integer, String> sectorNames = loadSectorNames();
        Map<Integer, List<AccreditedScope>> scopesByBody =
                groupByCertificationBody(accreditedScopeRepository.findAllValidScopes());
        // The card shows the body's first accreditation even when none of its rights is currently valid.
        Map<Integer, Accreditation> firstAccreditation = accreditationRepository.findAllWithAccreditationBody()
                .stream()
                .collect(Collectors.toMap(
                        accreditation -> accreditation.getCertificationBody().getId(),
                        accreditation -> accreditation,
                        (first, ignored) -> first));

        List<CertificationBodyCardDto> cards = certificationBodyRepository.findAllByOrderByNameAsc()
                .stream()
                .map(cb -> {
                    List<AccreditationScopeDto> scopes = scopesByBody
                            .getOrDefault(cb.getId(), List.of())
                            .stream()
                            .map(scope -> toScopeDto(scope, sectorNames))
                            .toList();
                    String scopeSection = scopes.stream()
                            .collect(Collectors.groupingBy(
                                    AccreditationScopeDto::isoStandard,
                                    LinkedHashMap::new,
                                    Collectors.mapping(scope -> String.valueOf(scope.eaCode()),
                                            Collectors.joining(", "))))
                            .entrySet().stream()
                            .map(entry -> entry.getKey() + ": EA " + entry.getValue())
                            .collect(Collectors.joining(" / "));
                    AccreditationScopeDto firstScope = scopes.isEmpty() ? null : scopes.get(0);

                    return toCard(
                            cb,
                            firstAccreditation.get(cb.getId()),
                            firstScope != null ? firstScope.eaCode() : 0,
                            firstScope != null ? firstScope.eaDescription() : ALL_SECTORS,
                            scopeSection.isBlank() ? "Nessun accreditamento valido" : scopeSection,
                            scopes);
                })
                .toList();

        return new SearchResponse(0, ALL_SECTORS, cards, true);
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

    /** EA code -> Italian display name, loaded in a single query. */
    private Map<Integer, String> loadSectorNames() {
        return eaSectorRepository.findAll().stream()
                .collect(Collectors.toMap(EaSector::getCode, EaSector::getNameIt));
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
        Accreditation accreditation = scope.getAccreditation();
        String description = sectorName(sectorNames, scope.getEaCode());
        String scopeSection = isPresent(scope.getScopeNote())
                ? scope.getScopeNote()
                : description + " (" + scope.getCertificationStandard() + ")";
        return new AccreditationScopeDto(
                scope.getEaCode(),
                description,
                scopeSection,
                accreditation.getProofUrl(),
                scope.getCertificationStandard(),
                accreditation.getAccreditationStandard(),
                accreditation.getAccreditationBody().getCode(),
                accreditation.getCertificateNumber());
    }

    private static CertificationBodyCardDto toCard(
            CertificationBody cb,
            Accreditation accreditation,
            int eaCode,
            String eaDescription,
            String scopeSection,
            List<AccreditationScopeDto> scopes) {
        AccreditationBody ab = accreditation != null ? accreditation.getAccreditationBody() : null;
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
                accreditation != null ? accreditation.getProofUrl() : null,
                eaCode,
                eaDescription,
                scopeSection,
                scopes);
    }
}
