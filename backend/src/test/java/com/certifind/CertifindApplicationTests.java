package com.certifind;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.certifind.dto.CertificationBodyCardDto;
import com.certifind.dto.SearchRequest;
import com.certifind.dto.SearchResponse;
import com.certifind.repository.SectorKeywordRepository;
import com.certifind.service.SearchService;

@SpringBootTest
class CertifindApplicationTests {

    @Autowired
    private SectorKeywordRepository sectorKeywordRepository;

    @Autowired
    private SearchService searchService;

    private void assertSearchResults(String iso, String sector, int expectedEaCode) {
        SearchResponse response = searchService.search(new SearchRequest(iso, sector));
        List<CertificationBodyCardDto> results = response.results();
        // One card per body. Checked by id, not name: names repeat legitimately across
        // countries ("LRQA Limited" in the UK and in Australia).
        List<Integer> ids = results.stream().map(CertificationBodyCardDto::id).toList();

        assertEquals(expectedEaCode, response.resolvedEaCode());
        assertEquals(ids.size(), ids.stream().distinct().count(), "a body appears in more than one card");
        assertTrue(results.stream().allMatch(card -> searchService.findScopes(card.id(), iso).stream()
                .anyMatch(scope -> scope.eaCode() == expectedEaCode
                        && iso.equals(scope.isoStandard()))));
    }

    @Test
    @DisplayName("Context loads successfully and validates JPA schema against PostgreSQL")
    void contextLoads() {
        assertNotNull(sectorKeywordRepository);
        assertNotNull(searchService);
    }

    @Test
    @DisplayName("Sector text resolves to EA codes")
    void testSectorResolution() {
        assertEquals(37, sectorKeywordRepository.match("asilo").eaCode());
        assertEquals(17, sectorKeywordRepository.match("Metall").eaCode());
        assertEquals(17, sectorKeywordRepository.match("carpenteria metallica a Brescia").eaCode());
        assertEquals(33, sectorKeywordRepository.match("software").eaCode());
        assertNull(sectorKeywordRepository.match("xyzxyz").eaCode());
        assertTrue(sectorKeywordRepository.match("xyzxyz").ambiguousCodes().isEmpty());
        // A fragment shared by several sectors is not resolved to one of them.
        assertEquals(java.util.Set.of(25, 26, 27, 33), sectorKeywordRepository.match("produzione").ambiguousCodes());
        assertNull(sectorKeywordRepository.match("prod").eaCode());
        // LIKE wildcards are literal.
        assertNull(sectorKeywordRepository.match("%%%").eaCode());
        assertNull(sectorKeywordRepository.match("___").eaCode());
    }

    @Test
    @DisplayName("ISO 9001 in metal (EA 17) returns matching certification bodies")
    void testIso9001Metal() {
        assertSearchResults("ISO 9001", "metallo", 17);
    }

    @Test
    @DisplayName("ISO/IEC 27001 searches resolve requested EA sectors")
    void testIso27001AllSectors() {
        assertSearchResults("ISO/IEC 27001", "EA 17", 17);
        assertSearchResults("ISO/IEC 27001", "EA 39", 39);
    }
}
