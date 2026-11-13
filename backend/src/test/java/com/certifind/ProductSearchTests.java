package com.certifind;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import com.certifind.dto.ProductDtos.BodyCard;
import com.certifind.dto.ProductDtos.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.importer.CsvImporter;
import com.certifind.importer.Dataset;
import com.certifind.service.ProductSearchService;
import com.certifind.service.SearchService;

/**
 * Imports a small made-up ISO/IEC 17065 dataset and searches it. Every test runs in a
 * transaction that is rolled back, so the database keeps no test rows.
 */
@SpringBootTest
@Transactional
class ProductSearchTests {

    private static final String COUNTRY = "Testland";
    private static final String FOOD_BODY = "Test Food Certification";
    private static final String MIXED_BODY = "Test Mixed Certification";

    @Autowired
    private CsvImporter importer;

    @Autowired
    private ProductSearchService productSearch;

    @Autowired
    private SearchService searchService;

    @BeforeEach
    void importDataset() {
        Dataset dataset = dataset(List.of(
                line("T-PRD-1", 1, "IFS Food", null, "Verarbeitung von Lebensmitteln", "Food processing",
                        "IFS Food Version 8", null, null, "ACTIVE"),
                line("T-PRD-1", 2, "BRCGS Packaging Materials", null, null, null, "BRC Packaging", null, null,
                        "ACTIVE"),
                line("T-PRD-2", 1, null, "packaging", "Kompostierbare Verpackungen", "Compostable packaging",
                        null, "DIN EN 13432:2000-12", "EN 13432", "ACTIVE"),
                line("T-PRD-2", 2, "IFS Food", null, null, null, "IFS Food", null, null, "WITHDRAWN")));
        assertTrue(importer.validate(dataset).isEmpty(), () -> importer.validate(dataset).toString());
        importer.load(dataset);
    }

    @Test
    @DisplayName("A scheme name finds the bodies holding an active line for it")
    void findsByScheme() {
        // MIXED_BODY's IFS Food line is withdrawn.
        assertEquals(List.of(FOOD_BODY), names(new SearchRequest("ifs food", null, null)));
        BodyCard card = productSearch.search(new SearchRequest("IFS", null, null)).results().get(0);
        assertEquals(List.of("IFS Food"), card.schemes());
        assertEquals(1, card.matchCount());
        assertEquals("DPA", card.accreditationBodyCode());
    }

    @Test
    @DisplayName("A standard number matches with or without the space")
    void findsByStandardNumber() {
        assertEquals(List.of(MIXED_BODY), names(new SearchRequest("EN 13432", null, null)));
        assertEquals(List.of(MIXED_BODY), names(new SearchRequest("en13432", null, null)));
    }

    @Test
    @DisplayName("An industry matches a line's own industry and its scheme's industries")
    void findsByIndustry() {
        // FOOD_BODY through BRCGS Packaging Materials, MIXED_BODY through the line's own industry.
        assertEquals(List.of(FOOD_BODY, MIXED_BODY), names(new SearchRequest(null, "packaging", null)));
        assertEquals(List.of(FOOD_BODY), names(new SearchRequest(null, "food", null)));
        assertEquals(List.of(), names(new SearchRequest("IFS Food", "packaging", null)));
    }

    @Test
    @DisplayName("Product text is searched in the original language and in English")
    void findsByProductText() {
        assertEquals(List.of(MIXED_BODY), names(new SearchRequest(null, null, "compostable")));
        assertEquals(List.of(MIXED_BODY), names(new SearchRequest(null, null, "Verpackungen kompostierbare")));
        // LIKE wildcards are literal.
        assertEquals(List.of(), names(new SearchRequest(null, null, "%%")));
    }

    @Test
    @DisplayName("An empty request and an unknown industry are rejected")
    void rejectsInvalidRequests() {
        assertThrows(IllegalArgumentException.class, () -> productSearch.search(new SearchRequest(" ", null, "")));
        assertThrows(IllegalArgumentException.class,
                () -> productSearch.search(new SearchRequest(null, "no-such-industry", null)));
    }

    @Test
    @DisplayName("The full list holds every body with an active line")
    void listsAllBodies() {
        List<BodyCard> ours = productSearch.findAll().results().stream()
                .filter(card -> COUNTRY.equals(card.country())).toList();
        assertEquals(List.of(FOOD_BODY, MIXED_BODY), ours.stream().map(BodyCard::name).toList());
        assertEquals(2, ours.get(0).matchCount());
        assertEquals(1, ours.get(1).matchCount());
    }

    @Test
    @DisplayName("The drawer endpoint returns a body's active lines only")
    void listsBodyScopes() {
        int bodyId = productSearch.search(new SearchRequest(null, null, "compostable")).results().get(0).id();
        assertEquals(List.of(1), productSearch.findScopes(bodyId).stream().map(l -> l.lineNo()).toList());
    }

    @Test
    @DisplayName("Importing the same lines again changes nothing; removed lines are withdrawn")
    void importIsIdempotent() {
        Dataset same = dataset(List.of(
                line("T-PRD-1", 1, "IFS Food", null, "Verarbeitung von Lebensmitteln", "Food processing",
                        "IFS Food Version 8", null, null, "ACTIVE")));
        String report = importer.load(same).toString();
        assertTrue(report.contains("product_scopes      0 inserted,     0 updated,     2 withdrawn,     1 unchanged"),
                report);
    }

    @Test
    @DisplayName("Product-only bodies stay out of the management system directory")
    void productBodiesAreNotManagementSystemBodies() {
        SearchResponse directory = searchService.findAllCompanies();
        assertTrue(directory.results().stream().noneMatch(card -> COUNTRY.equals(card.country())));
    }

    private List<String> names(SearchRequest request) {
        return productSearch.search(request).results().stream().map(BodyCard::name).toList();
    }

    private static Dataset dataset(List<Dataset.ProductScope> lines) {
        LocalDate issued = LocalDate.now().minusYears(1);
        return new Dataset("test-product", List.of(body(FOOD_BODY), body(MIXED_BODY)),
                List.of(accreditation("T-PRD-1", FOOD_BODY, issued), accreditation("T-PRD-2", MIXED_BODY, issued)),
                List.<Dataset.Scope>of(), lines);
    }

    private static Dataset.Body body(String name) {
        return new Dataset.Body(2, name, COUNTRY, null, null, null, null, null, null, null);
    }

    private static Dataset.Accreditation accreditation(String certificate, String body, LocalDate issued) {
        return new Dataset.Accreditation(2, "DPA", certificate, body, COUNTRY, "ISO/IEC 17065", "ACTIVE",
                issued, issued.plusYears(4), null);
    }

    private static Dataset.ProductScope line(String certificate, int lineNo, String scheme, String industry,
                                             String product, String productEn, String schemeText,
                                             String normativeDocs, String standardRefs, String status) {
        return new Dataset.ProductScope(lineNo + 1, certificate, lineNo, scheme, industry, product, productEn,
                schemeText, normativeDocs, standardRefs, status);
    }
}
