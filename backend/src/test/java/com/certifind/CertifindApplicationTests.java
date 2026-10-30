package com.certifind;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.certifind.domain.SectorKeyword;
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

    private List<String> namesFor(String iso, String sector) {
        SearchResponse response = searchService.search(new SearchRequest(iso, sector));
        return response.results().stream().map(CertificationBodyCardDto::name).toList();
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
        assertEquals(37, sectorKeywordRepository.findBestMatch("asilo").map(SectorKeyword::getEaCode).orElseThrow());
        assertEquals(17, sectorKeywordRepository.findBestMatch("Metall").map(SectorKeyword::getEaCode).orElseThrow());
        assertEquals(17, sectorKeywordRepository.findBestMatch("carpenteria metallica a Brescia")
                .map(SectorKeyword::getEaCode).orElseThrow());
        Optional<SectorKeyword> none = sectorKeywordRepository.findBestMatch("xyzxyz");
        assertTrue(none.isEmpty());
    }

    @Test
    @DisplayName("ISO 9001 in metal (EA 17) returns only bodies with a valid 17021-1 right for EA 17")
    void testIso9001Metal() {
        List<String> names = namesFor("ISO 9001", "metallo");
        assertEquals(List.of(
                "Adriatik Cert Sh.p.k.",
                "Albion Certification Services Ltd",
                "Mainfranken Zertifizierung GmbH",
                "Metalcert Europe S.r.l.",
                "Nord Est Certificazioni S.p.A.",
                "Polcert Sp. z o.o.",
                "Sigma Quality Registrar Ltd"), names);
        // No EA 17 right, 45001/14001 only, 27006 only, withdrawn scope, suspended accreditation.
        assertFalse(names.contains("Qualitas Certificazioni S.r.l."));
        assertFalse(names.contains("Lombardia Safety Cert S.r.l."));
        assertFalse(names.contains("InfoSec Assurance Italia S.r.l."));
        assertFalse(names.contains("Energia Certa S.r.l."));
        assertFalse(names.contains("CertRom Audit S.R.L."));
    }

    @Test
    @DisplayName("27006 accreditation covers ISO/IEC 27001 in every EA sector")
    void testIso27001AllSectors() {
        List<String> expected = List.of(
                "InfoSec Assurance Italia S.r.l.",
                "Qualitas Certificazioni S.r.l.",
                "Sigma Quality Registrar Ltd",
                "Tecno Audit Italia S.r.l.");
        assertEquals(expected, namesFor("ISO/IEC 27001", "EA 17"));
        assertEquals(expected, namesFor("ISO/IEC 27001", "EA 39"));
    }

    @Test
    @DisplayName("Expired 50003 accreditation is excluded")
    void testExpiredAccreditation() {
        assertFalse(namesFor("ISO 50001", "EA 17").contains("Polcert Sp. z o.o."));
    }

    @Test
    @DisplayName("Suspended single scope is excluded but the rest of the accreditation stays valid")
    void testSuspendedScope() {
        assertFalse(namesFor("ISO 9001", "EA 38").contains("Tecno Audit Italia S.r.l."));
        assertTrue(namesFor("ISO 9001", "EA 37").contains("Tecno Audit Italia S.r.l."));
    }
}
