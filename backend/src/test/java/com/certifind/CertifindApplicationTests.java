package com.certifind;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;
import com.certifind.service.PricingEstimatorService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class CertifindApplicationTests {

    @Autowired
    private AtecoEaMappingRepository atecoEaMappingRepository;

    @Autowired
    private AccreditedScopeRepository accreditedScopeRepository;

    @Autowired
    private PricingEstimatorService pricingService;

    @Test
    @DisplayName("Context loads successfully and validates JPA schema against PostgreSQL")
    void contextLoads() {
        assertNotNull(atecoEaMappingRepository);
        assertNotNull(accreditedScopeRepository);
        assertNotNull(pricingService);
    }

    @Test
    @DisplayName("Verify ATECO 88.91.00 resolves to EA 37")
    void testAtecoResolution() {
        Optional<AtecoEaMapping> mapping = atecoEaMappingRepository.findByAtecoCode("88.91.00");
        assertTrue(mapping.isPresent(), "Mapping for ATECO 88.91.00 should exist in seed database");
        assertEquals(37, mapping.get().getEaCode());
        assertEquals("Education", mapping.get().getEaDescription());

        Optional<AtecoEaMapping> byKeyword = atecoEaMappingRepository.findFirstByDescriptionContainingIgnoreCase("asilo");
        assertTrue(byKeyword.isPresent());
        assertEquals(37, byKeyword.get().getEaCode());
    }

    @Test
    @DisplayName("Verify querying active scopes for ISO 9001 + EA 37 orders by daily rate ASC")
    void testQueryActiveScopes() {
        List<AccreditedScope> scopes = accreditedScopeRepository.findActiveScopesWithCabAndAb("ISO 9001", 37);
        assertFalse(scopes.isEmpty(), "Should find active accredited scopes for ISO 9001 and EA 37");

        // First CAB should be cost leader (SRAC / CertRom from RENAR @ 650 EUR)
        AccreditedScope first = scopes.get(0);
        assertNotNull(first.getCertificationBody());
        assertNotNull(first.getCertificationBody().getAccreditationBody());

        PricingEstimatorService.PriceCalculation price = pricingService.calculate(first.getCertificationBody());
        assertEquals(650.0, price.dailyRateEur());
        assertEquals(2300.0, price.totalCostEur());
        assertTrue(price.savingsEur() > 0);
    }
}
