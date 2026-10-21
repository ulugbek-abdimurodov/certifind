package com.certifind;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;

/**
 * Integration tests that require a live PostgreSQL instance with seed data.
 *
 * These tests are tagged "integration" and are excluded from the default
 * unit-test phase. Run the full suite (including these) with:
 *
 *   ./mvnw verify                          # all tests
 *   ./mvnw test -Dgroups=integration       # integration only
 *   ./mvnw test -Dgroups='!integration'    # unit tests only
 */
@Tag("integration")
@SpringBootTest
class CertifindApplicationTests {

    @Autowired
    private AtecoEaMappingRepository atecoEaMappingRepository;

    @Autowired
    private AccreditedScopeRepository accreditedScopeRepository;

    @Test
    @DisplayName("Context loads successfully and validates JPA schema against PostgreSQL")
    void contextLoads() {
        assertNotNull(atecoEaMappingRepository);
        assertNotNull(accreditedScopeRepository);
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
    @DisplayName("Verify querying active scopes for ISO 9001 + EA 37")
    void testQueryActiveScopes() {
        List<AccreditedScope> scopes = accreditedScopeRepository.findActiveScopesWithCabAndAb("ISO 9001", 37);
        assertFalse(scopes.isEmpty(), "Should find active accredited scopes for ISO 9001 and EA 37");
        AccreditedScope first = scopes.get(0);
        assertNotNull(first.getCertificationBody());
        assertNotNull(first.getCertificationBody().getAccreditationBody());
    }
}