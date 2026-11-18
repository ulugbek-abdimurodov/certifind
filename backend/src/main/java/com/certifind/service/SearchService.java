package com.certifind.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.domain.Accreditation;
import com.certifind.domain.AccreditationBody;
import com.certifind.domain.AccreditedScope;
import com.certifind.domain.CertificationBody;
import com.certifind.domain.EaSector;
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
    private final NamedParameterJdbcTemplate jdbc;

    public SearchService(
            SectorKeywordRepository sectorKeywordRepository,
            AccreditedScopeRepository accreditedScopeRepository,
            CertificationBodyRepository certificationBodyRepository,
            EaSectorRepository eaSectorRepository,
            NamedParameterJdbcTemplate jdbc) {
        this.sectorKeywordRepository = sectorKeywordRepository;
        this.accreditedScopeRepository = accreditedScopeRepository;
        this.certificationBodyRepository = certificationBodyRepository;
        this.eaSectorRepository = eaSectorRepository;
        this.jdbc = jdbc;
    }

    /**
     * Valid issuing rights (same rule as {@link AccreditedScopeRepository}) with everything the
     * keyword is matched against: the body, its accreditation and AB, the standard and its title,
     * the EA sector (code, Italian and English names, and its search vocabulary) and the scope note.
     */
    private static final String KEYWORD_ROWS = """
            WITH kw AS (SELECT ea_code, string_agg(keyword, ' ') AS words FROM sector_keywords GROUP BY ea_code)
            SELECT cb.id AS body_id, cb.name, cb.country, cb.phone, cb.email, cb.website, cb.address,
                   cb.source_url, cb.verified_at,
                   ab.code AS ab_code, ab.website AS ab_website,
                   a.accreditation_standard, a.certificate_number, a.proof_url, a.expiry_date,
                   s.certification_standard, s.ea_code, s.scope_note, e.name_it AS ea_name
            FROM accredited_scopes s
            JOIN accreditations a        ON a.id = s.accreditation_id
            JOIN certification_bodies cb ON cb.id = a.certification_body_id
            JOIN accreditation_bodies ab ON ab.id = a.accreditation_body_id
            LEFT JOIN ea_sectors e       ON e.code = s.ea_code
            LEFT JOIN standards st       ON st.code = s.certification_standard
            LEFT JOIN kw                 ON kw.ea_code = s.ea_code
            WHERE s.status = 'ACTIVE' AND a.status = 'ACTIVE'
              AND (a.expiry_date IS NULL OR a.expiry_date >= CURRENT_DATE)
              AND (a.accreditation_standard = 'ISO/IEC 17021-1'
                   OR EXISTS (SELECT 1 FROM accreditations base
                              WHERE base.certification_body_id = a.certification_body_id
                                AND base.accreditation_standard = 'ISO/IEC 17021-1'
                                AND base.status = 'ACTIVE'
                                AND (base.expiry_date IS NULL OR base.expiry_date >= CURRENT_DATE)))
            """;
    private static final String KEYWORD_TEXT = """
            concat_ws(' ', cb.name, cb.country, cb.address, cb.website, cb.email, cb.phone, cb.registration_no,
                      ab.code, ab.name, ab.country, a.accreditation_standard, a.certificate_number,
                      s.certification_standard, st.title, 'EA ' || s.ea_code, e.name_it, e.name_en,
                      kw.words, s.scope_note)""";

    /**
     * Free-text search: every word of the keyword must appear somewhere in a valid scope row
     * (see {@link KeywordPattern}); a chosen standard and sector narrow the rows further.
     * One card per body, built from its first matching row (ISO/IEC 17021-1 rows first).
     */
    private SearchResponse keywordSearch(SearchRequest request) {
        String keyword = isPresent(request.keyword()) ? request.keyword().trim() : null;
        if (keyword != null) validateInput(keyword, ProductSearchService.MIN_TEXT_LENGTH);
        String iso = isPresent(request.isoStandard()) ? request.isoStandard().trim() : null;
        Integer eaCode = null;
        if (isPresent(request.sectorActivity())) {
            validateInput(request.sectorActivity(), MIN_SECTOR_LENGTH);
            eaCode = parseEaCode(request.sectorActivity());
            if (eaCode == null) eaCode = resolveKeyword(request.sectorActivity());
            if (eaCode == null) {
                throw new IllegalArgumentException("Settore di attività non riconosciuto. Inserisci un settore valido o un codice EA supportato.");
            }
        }
        if (keyword == null && eaCode == null) {
            throw new IllegalArgumentException("Indica una parola chiave oppure un settore di attività.");
        }

        MapSqlParameterSource params = new MapSqlParameterSource();
        StringBuilder sql = new StringBuilder(KEYWORD_ROWS);
        if (iso != null) {
            sql.append(" AND s.certification_standard = :iso");
            params.addValue("iso", iso);
        }
        if (eaCode != null) {
            sql.append(" AND s.ea_code = :ea");
            params.addValue("ea", eaCode);
        }
        KeywordPattern.appendTokens(sql, params, KEYWORD_TEXT, "k", keyword);
        sql.append(" ORDER BY cb.name, cb.id, (a.accreditation_standard <> 'ISO/IEC 17021-1'), a.id, ")
                .append("s.certification_standard, s.ea_code");

        Map<Integer, KeywordCard> cards = new LinkedHashMap<>();
        jdbc.query(sql.toString(), params, rs -> {
            cards.computeIfAbsent(rs.getInt("body_id"), id -> new KeywordCard()).add(rs);
        });
        String sectorName = eaCode == null ? "" : sectorName(loadSectorNames(), eaCode);
        return new SearchResponse(eaCode == null ? 0 : eaCode, sectorName,
                cards.values().stream().map(KeywordCard::build).toList(), false);
    }

    /** Collects one body's matching rows for a keyword search card. */
    private static final class KeywordCard {
        private CertificationBodyCardDto first;
        private final TreeSet<String> otherAbs = new TreeSet<>();
        private final TreeSet<String> standards = new TreeSet<>();

        void add(ResultSet rs) throws SQLException {
            String ab = rs.getString("ab_code");
            standards.add(rs.getString("certification_standard"));
            if (first != null) {
                if (!ab.equals(first.accreditationBodyCode())) otherAbs.add(ab);
                return;
            }
            Integer ea = (Integer) rs.getObject("ea_code");
            String eaName = rs.getString("ea_name");
            String note = rs.getString("scope_note");
            String scope = isPresent(note) ? note
                    : (eaName != null ? eaName : "EA " + ea) + " (" + rs.getString("certification_standard") + ")";
            first = new CertificationBodyCardDto(
                    rs.getInt("body_id"), rs.getString("name"), rs.getString("country"),
                    ab, rs.getString("ab_website"), List.of(),
                    rs.getString("phone"), rs.getString("email"), rs.getString("website"),
                    rs.getString("address"), rs.getString("source_url"),
                    rs.getObject("verified_at", LocalDate.class), rs.getString("proof_url"),
                    ea == null ? 0 : ea, eaName == null ? "" : eaName,
                    rs.getString("accreditation_standard") + " · " + rs.getString("certificate_number") + " · " + scope,
                    List.of(), rs.getObject("expiry_date", LocalDate.class));
        }

        CertificationBodyCardDto build() {
            List<String> abs = new ArrayList<>();
            abs.add(first.accreditationBodyCode());
            abs.addAll(otherAbs);
            return new CertificationBodyCardDto(first.id(), first.name(), first.country(),
                    first.accreditationBodyCode(), first.accreditationBodyWebsite(), List.copyOf(abs),
                    first.phone(), first.email(), first.website(), first.address(), first.sourceUrl(),
                    first.verifiedAt(), first.proofUrl(), first.eaCode(), first.eaDescription(),
                    first.scopeSection(), List.copyOf(standards), first.expiryDate());
        }
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
        // A keyword, or no standard ("Tutti gli standard"), goes through the free-text search,
        // where standard and sector are optional filters.
        if (isPresent(request.keyword()) || !isPresent(request.isoStandard())) {
            return keywordSearch(request);
        }
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
