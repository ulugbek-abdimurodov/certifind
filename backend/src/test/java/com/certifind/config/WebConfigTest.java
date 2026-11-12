package com.certifind.config;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

class WebConfigTest {

    @ParameterizedTest
    @ValueSource(strings = {"https://certifind.it", "https://app.certifind.it", "https://app.certifind.it:8443"})
    void acceptsPublicHttpsOrigins(String origin) {
        assertDoesNotThrow(() -> WebConfig.checkProductionOrigin(origin));
    }

    @ParameterizedTest
    @ValueSource(strings = {
            "http://localhost:3000", "https://localhost:3000", "http://certifind.it",
            "https://app.example.com", "https://example.org", "https://127.0.0.1",
            "https://app.certifind.it/", "https://app.certifind.it/path", "https://*.certifind.it",
            "*", "https://app.local.test"})
    void rejectsLocalPlaceholderAndMalformedOrigins(String origin) {
        assertThrows(IllegalStateException.class, () -> WebConfig.checkProductionOrigin(origin));
    }
}
