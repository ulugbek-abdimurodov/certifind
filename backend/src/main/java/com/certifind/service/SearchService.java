package com.certifind.service;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.TreeSet;
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
    static final int MIN_SECTOR_LENGTH = 3;
    static final int MAX_INPUT_LENGTH = 200;

    private final SectorKeywordRepository sectorKeywordRepository;
    private final AccreditedScopeRepository accreditedScopeRepository;
    private final CertificationBodyRepository certificationBodyRepository;
    private final EaSectorRepository eaSectorRepository;

    public SearchService(
            SectorKeywordRepository sectorKeywordRepository,
            AccreditedScopeRepository accreditedScopeRepository,
            CertificationBodyRepository certificationBodyRepository,
            EaSectorRepository eaSectorRepository) {
        this.sectorKeywordRepository = sectorKeywordRepository;
        this.accreditedScopeRepository = accreditedScopeRepository;
        this.certificationBodyRepository = certificationBodyRepository;
        this.eaSectorRepository = eaSectorRepository;
    }

    @Transactional(readOnly = true)
    public SearchOptionsResponse getOptions() {
        Map<Integer, String> sectorNames = loadSectorNames();
        // Each standard offers only the EA sectors some body can currently certify for it.
        Map<String, List<SectorOption>> sectorsByStandard = accreditedScopeRepository.findDistinctStandardEaCodes()
                .stream()
                .collect(Collectors.groupingBy(
                        row -> (String) row[0],
                        LinkedHashMap::new,
                        Collectors.mapping(row -> {
                            int code = (Integer) row[1];
                            return new SectorOption(code, sectorName(sectorNames, code));
                        }, Collectors.toList())));
        return new SearchOptionsResponse(accreditedScopeRepository.findDistinctCertificationStandards(), sectorsByStandard);
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("La richiesta di ricerca non può essere vuota.");
        }
        validateInput(request.isoStandard(), 0);
        validateInput(request.sectorActivity(), MIN_SECTOR_LENGTH);

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
                            // Every AB whose valid right covers this standard and sector, not just the first.
                            List<String> abCodes = abCodes(match.getAccreditation(), bodyScopes.stream()
                                    .filter(scope -> Objects.equals(scope.getEaCode(), resolvedEaCode))
                                    .map(AccreditedScope::getAccreditation)
                                    .toList());
                            String scopeSection = match.getAccreditation().getAccreditationStandard()
                                    + " · " + match.getAccreditation().getCertificateNumber()
                                    + " · " + toScopeDto(match, sectorNames).scopeSection();
                            return toCard(match.getCertificationBody(), match.getAccreditation(),
                                    resolvedEaCode, resolvedEaDesc, scopeSection, List.of(iso), abCodes);
                        })
                        .stream())
                .toList();

        return new SearchResponse(resolvedEaCode, resolvedEaDesc, cards, false);
    }

    /** EA code for free text; null when nothing matches. Text matching several sectors is rejected. */
    private Integer resolveKeyword(String sectorActivity) {
        if (!isPresent(sectorActivity)) {
            return null;
        }
        SectorKeywordRepository.KeywordMatch match = sectorKeywordRepository.match(sectorActivity);
        if (!match.ambiguousCodes().isEmpty()) {
            Map<Integer, String> names = loadSectorNames();
            String options = match.ambiguousCodes().stream()
                    .map(code -> "EA " + code + " (" + sectorName(names, code) + ")")
                    .collect(Collectors.joining(", "));
            throw new IllegalArgumentException("Settore ambiguo: «" + sectorActivity.trim()
                    + "» può indicare " + options + ". Scrivi un termine più preciso o scegli un codice EA.");
        }
        return match.eaCode();
    }

    @Transactional(readOnly = true)
    public SearchResponse findAllCompanies() {
        // Lightweight rows instead of every scope entity: the list only shows each body's standards.
        Map<Integer, TreeSet<String>> standardsByBody = new HashMap<>();
        for (Object[] row : accreditedScopeRepository.findValidBodyStandards()) {
            standardsByBody.computeIfAbsent((Integer) row[0], id -> new TreeSet<>()).add((String) row[1]);
        }
        // The card shows the body's ISO/IEC 17021-1 accreditation when it has a valid scope, else its first one.
        Map<Integer, Accreditation> cardAccreditation = new HashMap<>();
        Map<Integer, List<Accreditation>> accreditationsByBody = new HashMap<>();
        for (Accreditation a : accreditedScopeRepository.findValidAccreditationsWithScopes()) {
            accreditationsByBody.computeIfAbsent(a.getCertificationBody().getId(), id -> new java.util.ArrayList<>()).add(a);
            cardAccreditation.merge(a.getCertificationBody().getId(), a,
                    (current, next) -> rank(next) < rank(current) ? next : current);
        }
        // Only bodies that hold at least one valid issuing right are listed (the same rule as
        // search): withdrawn, suspended and expired bodies stay in the database but are hidden.
        List<CertificationBodyCardDto> cards = certificationBodyRepository.findAllByOrderByNameAsc()
                .stream()
                .filter(cb -> standardsByBody.containsKey(cb.getId()) && cardAccreditation.containsKey(cb.getId()))
                .map(cb -> {
                    List<String> standards = List.copyOf(standardsByBody.get(cb.getId()));
                    Accreditation primary = cardAccreditation.get(cb.getId());
                    return toCard(cb, primary, 0, ALL_SECTORS, String.join(", ", standards), standards,
                            abCodes(primary, accreditationsByBody.get(cb.getId())));
                })
                .toList();

        return new SearchResponse(0, ALL_SECTORS, cards, true);
    }

    /** All valid scope rows of one body, optionally for a single certification standard. */
    @Transactional(readOnly = true)
    public List<AccreditationScopeDto> findScopes(Integer bodyId, String standard) {
        Map<Integer, String> sectorNames = loadSectorNames();
        return accreditedScopeRepository.findValidScopesByBody(bodyId).stream()
                .filter(scope -> !isPresent(standard) || scope.getCertificationStandard().equals(standard.trim()))
                .map(scope -> toScopeDto(scope, sectorNames))
                .toList();
    }

    /** Distinct AB codes: the card's own AB first, the others alphabetically. */
    private static List<String> abCodes(Accreditation primary, List<Accreditation> all) {
        String first = primary.getAccreditationBody().getCode();
        TreeSet<String> others = all.stream()
                .map(a -> a.getAccreditationBody().getCode())
                .filter(code -> !code.equals(first))
                .collect(Collectors.toCollection(TreeSet::new));
        List<String> codes = new java.util.ArrayList<>();
        codes.add(first);
        codes.addAll(others);
        return codes;
    }

    private static int rank(Accreditation a) {
        return ("ISO/IEC 17021-1".equals(a.getAccreditationStandard()) ? 0 : 1_000_000_000) + a.getId();
    }

    /** Rejects control characters and text outside [minLength, MAX_INPUT_LENGTH] once trimmed. */
    static void validateInput(String value, int minLength) {
        String trimmed = value == null ? "" : value.trim();
        if (trimmed.length() < minLength) {
            throw new IllegalArgumentException("Inserisci almeno " + minLength + " caratteri.");
        }
        if (trimmed.length() > MAX_INPUT_LENGTH) {
            throw new IllegalArgumentException("Testo troppo lungo (massimo " + MAX_INPUT_LENGTH + " caratteri).");
        }
        // Any control character (C0, DEL, C1), tabs and newlines included.
        if (value != null && value.chars().anyMatch(Character::isISOControl)) {
            throw new IllegalArgumentException("Il testo contiene caratteri non validi.");
        }
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
                accreditation.getCertificateNumber(),
                accreditation.getExpiryDate());
    }

    private static CertificationBodyCardDto toCard(
            CertificationBody cb,
            Accreditation accreditation,
            int eaCode,
            String eaDescription,
            String scopeSection,
            List<String> standards,
            List<String> accreditationBodyCodes) {
        AccreditationBody ab = accreditation.getAccreditationBody();
        return new CertificationBodyCardDto(
                cb.getId(),
                cb.getName(),
                cb.getCountry(),
                ab.getCode(),
                ab.getWebsite(),
                accreditationBodyCodes,
                cb.getPhone(),
                cb.getEmail(),
                cb.getWebsite(),
                cb.getAddress(),
                cb.getSourceUrl(),
                cb.getVerifiedAt(),
                accreditation.getProofUrl(),
                eaCode,
                eaDescription,
                scopeSection,
                standards,
                accreditation.getExpiryDate());
    }
}
