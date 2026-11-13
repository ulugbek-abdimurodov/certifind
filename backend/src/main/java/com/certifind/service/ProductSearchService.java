package com.certifind.service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.dto.ProductDtos.BodyCard;
import com.certifind.dto.ProductDtos.IndustryOption;
import com.certifind.dto.ProductDtos.Options;
import com.certifind.dto.ProductDtos.SchemeOption;
import com.certifind.dto.ProductDtos.ScopeLine;
import com.certifind.dto.ProductDtos.SearchRequest;
import com.certifind.dto.ProductDtos.SearchResponse;

/**
 * Search over ISO/IEC 17065 scope lines (product, process and service certification).
 * A line is valid when it and its accreditation are ACTIVE and the accreditation has not
 * expired. Unlike management systems, no ISO/IEC 17021-1 accreditation is required.
 */
@Service
public class ProductSearchService {

    static final int MIN_TEXT_LENGTH = 2;
    static final int MAX_TOKENS = 6;
    static final int MAX_CARD_LINES = 3;

    private static final String LINE_COLUMNS = """
            SELECT cb.id AS body_id, cb.name, cb.country, cb.phone, cb.email, cb.website, cb.address,
                   cb.source_url, cb.verified_at,
                   ab.code AS ab_code, ab.website AS ab_website,
                   a.certificate_number, a.expiry_date, a.proof_url,
                   ps.line_no, ps.scheme_code, i.name_it AS industry_name, ps.product_text, ps.product_text_en,
                   ps.scheme_text, ps.normative_docs, ps.standard_refs
            FROM product_scopes ps
            JOIN accreditations a        ON a.id = ps.accreditation_id
            JOIN certification_bodies cb ON cb.id = a.certification_body_id
            JOIN accreditation_bodies ab ON ab.id = a.accreditation_body_id
            LEFT JOIN industries i       ON i.code = ps.industry_code
            WHERE ps.status = 'ACTIVE' AND a.status = 'ACTIVE'
              AND (a.expiry_date IS NULL OR a.expiry_date >= CURRENT_DATE)
            """;
    /** Where a scheme or standard is looked for, and where a product or activity is. */
    private static final String REFERENCE_TEXT =
            "concat_ws(' ', ps.scheme_code, ps.scheme_text, ps.normative_docs, ps.standard_refs)";
    private static final String PRODUCT_TEXT = "concat_ws(' ', ps.product_text, ps.product_text_en)";

    private final NamedParameterJdbcTemplate jdbc;

    public ProductSearchService(NamedParameterJdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    /** The whole catalogue: industries in display order, schemes by name. */
    @Transactional(readOnly = true)
    public Options getOptions() {
        List<IndustryOption> industries = jdbc.query(
                "SELECT code, name_it FROM industries ORDER BY sort_order",
                (rs, n) -> new IndustryOption(rs.getString(1), rs.getString(2)));
        Map<String, List<String>> bySchemes = new LinkedHashMap<>();
        jdbc.query("SELECT s.code, si.industry_code FROM schemes s "
                        + "LEFT JOIN scheme_industries si ON si.scheme_code = s.code "
                        + "ORDER BY lower(s.code), si.industry_code",
                rs -> {
                    List<String> codes = bySchemes.computeIfAbsent(rs.getString(1), code -> new ArrayList<>());
                    if (rs.getString(2) != null) codes.add(rs.getString(2));
                });
        List<SchemeOption> schemes = bySchemes.entrySet().stream()
                .map(e -> new SchemeOption(e.getKey(), List.copyOf(e.getValue())))
                .toList();
        return new Options(industries, schemes);
    }

    @Transactional(readOnly = true)
    public SearchResponse search(SearchRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("La richiesta di ricerca non può essere vuota.");
        }
        String scheme = clean(request.scheme());
        String product = clean(request.product());
        String industry = clean(request.industry());
        if (scheme == null && product == null && industry == null) {
            throw new IllegalArgumentException("Indica uno schema o una norma, un settore oppure un prodotto.");
        }

        MapSqlParameterSource params = new MapSqlParameterSource();
        StringBuilder sql = new StringBuilder(LINE_COLUMNS);
        if (industry != null) {
            Integer known = jdbc.queryForObject("SELECT count(*) FROM industries WHERE code = :industry",
                    Map.of("industry", industry), Integer.class);
            if (known == null || known == 0) {
                throw new IllegalArgumentException("Settore non riconosciuto.");
            }
            // The line's own industry, or any industry of its scheme.
            sql.append("""
                      AND (ps.industry_code = :industry
                           OR EXISTS (SELECT 1 FROM scheme_industries si
                                      WHERE si.scheme_code = ps.scheme_code AND si.industry_code = :industry))
                    """);
            params.addValue("industry", industry);
        }
        appendTokens(sql, params, REFERENCE_TEXT, "r", scheme);
        appendTokens(sql, params, PRODUCT_TEXT, "p", product);
        return collect(sql.toString(), params);
    }

    /** Every body with at least one valid scope line, for "Vedi tutti gli organismi". */
    @Transactional(readOnly = true)
    public SearchResponse findAll() {
        return collect(LINE_COLUMNS, new MapSqlParameterSource());
    }

    /** Runs a LINE_COLUMNS query and groups its lines into one card per body. */
    private SearchResponse collect(String sql, MapSqlParameterSource params) {
        Map<Integer, CardBuilder> cards = new LinkedHashMap<>();
        jdbc.query(sql + " ORDER BY cb.name, cb.id, a.id, ps.line_no", params, rs -> {
            cards.computeIfAbsent(rs.getInt("body_id"), id -> new CardBuilder()).add(rs);
        });
        return new SearchResponse(cards.values().stream().map(CardBuilder::build).toList());
    }

    /** Every valid scope line of one body, in annex order. */
    @Transactional(readOnly = true)
    public List<ScopeLine> findScopes(Integer bodyId) {
        return jdbc.query(LINE_COLUMNS + " AND cb.id = :bodyId ORDER BY a.id, ps.line_no",
                Map.of("bodyId", bodyId), (rs, n) -> line(rs));
    }

    /**
     * Adds one condition per word: every word must appear in {@code haystack}. Each word is
     * also tried against the text without spaces, so "EN1090" finds "EN 1090".
     */
    private static void appendTokens(StringBuilder sql, MapSqlParameterSource params, String haystack,
                                     String prefix, String text) {
        if (text == null) return;
        String[] tokens = text.split("\\s+");
        for (int i = 0; i < Math.min(tokens.length, MAX_TOKENS); i++) {
            String name = prefix + i;
            sql.append(" AND (").append(haystack).append(" ILIKE :").append(name)
                    .append(" ESCAPE '\\' OR replace(").append(haystack).append(", ' ', '') ILIKE :")
                    .append(name).append(" ESCAPE '\\')");
            params.addValue(name, "%" + escapeLike(tokens[i]) + "%");
        }
    }

    /** LIKE wildcards typed by the user are matched literally. */
    private static String escapeLike(String value) {
        return value.replace("\\", "\\\\").replace("%", "\\%").replace("_", "\\_");
    }

    /** Trimmed text, or null when blank; rejects control characters and out-of-range lengths. */
    private static String clean(String value) {
        if (value == null || value.isBlank()) return null;
        SearchService.validateInput(value, MIN_TEXT_LENGTH);
        return value.trim();
    }

    private static ScopeLine line(ResultSet rs) throws SQLException {
        return new ScopeLine(
                rs.getInt("line_no"),
                rs.getString("scheme_code"),
                rs.getString("industry_name"),
                rs.getString("product_text"),
                rs.getString("product_text_en"),
                rs.getString("scheme_text"),
                rs.getString("normative_docs"),
                rs.getString("standard_refs"),
                rs.getString("ab_code"),
                rs.getString("certificate_number"),
                rs.getObject("expiry_date", LocalDate.class),
                rs.getString("proof_url"));
    }

    /** Collects the matching lines of one body; the first line supplies the card's accreditation. */
    private static final class CardBuilder {
        private BodyCard first;
        private final Set<String> abCodes = new LinkedHashSet<>();
        private final Set<String> schemes = new LinkedHashSet<>();
        private final List<ScopeLine> lines = new ArrayList<>();
        private int matchCount;

        void add(ResultSet rs) throws SQLException {
            ScopeLine line = line(rs);
            if (first == null) {
                first = new BodyCard(rs.getInt("body_id"), rs.getString("name"), rs.getString("country"),
                        line.accreditationBodyCode(), rs.getString("ab_website"), List.of(),
                        rs.getString("phone"), rs.getString("email"), rs.getString("website"),
                        rs.getString("address"), rs.getString("source_url"),
                        rs.getObject("verified_at", LocalDate.class), line.proofUrl(), line.expiryDate(),
                        List.of(), List.of(), 0);
            }
            abCodes.add(line.accreditationBodyCode());
            if (line.scheme() != null) schemes.add(line.scheme());
            if (lines.size() < MAX_CARD_LINES) lines.add(line);
            matchCount++;
        }

        BodyCard build() {
            return new BodyCard(first.id(), first.name(), first.country(), first.accreditationBodyCode(),
                    first.accreditationBodyWebsite(), List.copyOf(abCodes), first.phone(), first.email(),
                    first.website(), first.address(), first.sourceUrl(), first.verifiedAt(), first.proofUrl(),
                    first.expiryDate(), List.copyOf(schemes), List.copyOf(lines), matchCount);
        }
    }
}
