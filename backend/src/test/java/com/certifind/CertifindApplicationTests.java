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

import com.certifind.domain.AccreditedScope;
import com.certifind.domain.AtecoEaMapping;
import com.certifind.repository.AccreditedScopeRepository;
import com.certifind.repository.AtecoEaMappingRepository;

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
        Optional<AtecoEaMapping> mapping = atecoEaMappingRepository.findFirstByAtecoCode("88.91.00");
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