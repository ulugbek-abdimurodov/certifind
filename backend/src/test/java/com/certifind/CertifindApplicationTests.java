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
                "AEROQ SA",
                "AQScert",
                "AUTORITATEA FEROVIARĂ ROMÂNĂ - AFER (OCSM - AFER)",
                "AXE Register sh.p.k",
                "CAREER CERT INSTITUTE sh.p.k",
                "CERTI AL sh.p.k",
                "CERTIND SA",
                "CERTINSPECT REGISTER SRL",
                "CERTIS sh.p.k",
                "CERTROM SRL",
                "e-Cert sh.p.k",
                "European Quality and Safety Control (EQSC) sh.p.k",
                "GRUPUL DE CERTIFICARE SISTEME DE MANAGEMENT SRL",
                "Legal Cert sh.p.k",
                "M.G BUGATTI CERTIFICATION sh.p.k",
                "MIȘCAREA ROMÂNĂ PENTRU CALITATE (MRC-OCS – Organism de Certificare Sisteme și Produse)",
                "MSC CERTIFICATIONS sh.p.k",
                "PROCERT LABORATORY SRL",
                "QUALITAS SA",
                "QUALITY CERT SA",
                "RAD CERT SRL",
                "RINA SIMTEX - ORGANISMUL DE CERTIFICARE SRL",
                "Risk Control Advisory – R.C.A sh.p.k",
                "SOCIETATEA ROMÂNĂ PENTRU CERTIFICARE ROCERT SRL",
                "SRAC CERT SRL",
                "SUCERT- RO SRL",
                "SUN CERT SRL",
                "TÜV AUSTRIA ROMÂNIA SRL (TAR CERT)",
                "UNICERT SRL"), names);
    }

    @Test
    @DisplayName("27006 accreditation covers ISO/IEC 27001 in every EA sector")
    void testIso27001AllSectors() {
        List<String> expected = List.of(
                "AEROQ SA",
                "AQScert",
                "AUTENTICERT Albania sh.p.k",
                "AXE Register sh.p.k",
                "CAREER CERT INSTITUTE sh.p.k",
                "CERTI AL sh.p.k",
                "CERTIND SA",
                "CERTINSPECT REGISTER SRL",
                "CERTIS sh.p.k",
                "e-Cert sh.p.k",
                "European Quality and Safety Control (EQSC) sh.p.k",
                "Legal Cert sh.p.k",
                "M.G BUGATTI CERTIFICATION sh.p.k",
                "MIȘCAREA ROMÂNĂ PENTRU CALITATE (MRC-OCS – Organism de Certificare Sisteme și Produse)",
                "MSC CERTIFICATIONS sh.p.k",
                "PROCERT LABORATORY SRL",
                "RINA SIMTEX - ORGANISMUL DE CERTIFICARE SRL",
                "Risk Control Advisory – R.C.A sh.p.k",
                "SRAC CERT SRL",
                "TÜV AUSTRIA ROMÂNIA SRL (TAR CERT)");
        assertEquals(expected, namesFor("ISO/IEC 27001", "EA 17"));
        assertEquals(expected, namesFor("ISO/IEC 27001", "EA 39"));
    }
}
