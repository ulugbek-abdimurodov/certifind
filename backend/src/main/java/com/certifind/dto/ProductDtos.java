package com.certifind.dto;

import java.time.LocalDate;
import java.util.List;

/** Request and response shapes of the product certification (ISO/IEC 17065) search. */
public final class ProductDtos {

    private ProductDtos() {
    }

    /** At least one field must be filled. {@code industry} is an industry code. */
    public record SearchRequest(String scheme, String industry, String product) {
    }

    public record IndustryOption(String code, String name) {
    }

    /** A catalogued scheme and the industry codes it belongs to. */
    public record SchemeOption(String code, List<String> industries) {
    }

    public record Options(List<IndustryOption> industries, List<SchemeOption> schemes) {
    }

    /** One line of a scope annex. {@code scheme} is the catalogue name, {@code schemeText} the annex wording. */
    public record ScopeLine(
            int lineNo,
            String scheme,
            String industry,
            String productText,
            String productTextEn,
            String schemeText,
            String normativeDocs,
            String standardRefs,
            String accreditationBodyCode,
            String certificateNumber,
            LocalDate expiryDate,
            String proofUrl) {
    }

    /** One body with the lines that matched; the shared fields are named as in CertificationBodyCardDto. */
    public record BodyCard(
            Integer id,
            String name,
            String country,
            String accreditationBodyCode,
            String accreditationBodyWebsite,
            List<String> accreditationBodyCodes,
            String phone,
            String email,
            String website,
            String address,
            String sourceUrl,
            LocalDate verifiedAt,
            String proofUrl,
            LocalDate expiryDate,
            /** Distinct catalogue schemes among the matching lines. */
            List<String> schemes,
            /** The first matching lines (at most {@code MAX_CARD_LINES}); all of them come from /product-scopes. */
            List<ScopeLine> lines,
            int matchCount) {
    }

    public record SearchResponse(List<BodyCard> results) {
    }
}
