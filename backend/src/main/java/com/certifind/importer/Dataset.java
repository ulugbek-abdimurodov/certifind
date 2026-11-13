package com.certifind.importer;

import java.time.LocalDate;
import java.util.List;
import java.util.SortedSet;

/**
 * One dataset folder under data/ (e.g. data/dpa-albania): bodies.csv, accreditations.csv,
 * scopes.csv and the optional product_scopes.csv, parsed and checked for everything that
 * does not need the database.
 * {@code line} fields point back at the CSV row for error messages.
 */
public record Dataset(String name, List<Body> bodies, List<Accreditation> accreditations, List<Scope> scopes,
                      List<ProductScope> productScopes) {

    public record Body(int line, String name, String country, String registrationNo, String phone,
                       String email, String website, String address, String sourceUrl, LocalDate verifiedAt) {
    }

    public record Accreditation(int line, String abCode, String certificateNumber, String bodyName,
                                String bodyCountry, String accreditationStandard, String status,
                                LocalDate issueDate, LocalDate expiryDate, String proofUrl) {
    }

    /** One scopes.csv row; {@code eaCodes} is already expanded from "1-10;12" or "ALL". */
    public record Scope(int line, String certificateNumber, String certificationStandard,
                        SortedSet<Integer> eaCodes, String status, String scopeNote) {
    }

    /** One product_scopes.csv row: a line of an ISO/IEC 17065 scope annex, kept verbatim. */
    public record ProductScope(int line, String certificateNumber, int lineNo, String scheme, String industry,
                               String productText, String productTextEn, String schemeText,
                               String normativeDocs, String standardRefs, String status) {
    }
}
