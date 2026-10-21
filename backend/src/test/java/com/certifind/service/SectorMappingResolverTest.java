package com.certifind.service;

import com.certifind.domain.AtecoEaMapping;
import com.certifind.exception.InvalidSearchRequestException;
import com.certifind.repository.AtecoEaMappingRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class SectorMappingResolverTest {

    @Mock
    private AtecoEaMappingRepository repository;

    private SectorMappingResolver resolver;

    @BeforeEach
    void setUp() {
        resolver = new SectorMappingResolver(repository);
    }

    // ------------------------------------------------------------------
    // Resolution by ATECO code
    // ------------------------------------------------------------------

    @Test
    @DisplayName("Resolves mapping when a valid ATECO code is supplied")
    void resolveByAtecoCode_found() {
        AtecoEaMapping mapping = mapping("88.91.00", 37, "Education");
        when(repository.findByAtecoCode("88.91.00")).thenReturn(Optional.of(mapping));

        AtecoEaMapping result = resolver.resolve("88.91.00", null);

        assertThat(result.getEaCode()).isEqualTo(37);
        assertThat(result.getEaDescription()).isEqualTo("Education");
        // keyword search must NOT have been called
        verify(repository, never()).findFirstByDescriptionContainingIgnoreCase(any());
    }

    @Test
    @DisplayName("Falls through to keyword search when ATECO code is not found")
    void resolveByAtecoCode_fallsThrough_toKeyword() {
        AtecoEaMapping mapping = mapping("88.91.00", 37, "Education");
        when(repository.findByAtecoCode("88.91.00")).thenReturn(Optional.empty());
        when(repository.findFirstByDescriptionContainingIgnoreCase("asilo"))
                .thenReturn(Optional.of(mapping));

        AtecoEaMapping result = resolver.resolve("88.91.00", "asilo");

        assertThat(result.getEaCode()).isEqualTo(37);
        verify(repository).findByAtecoCode("88.91.00");
        verify(repository).findFirstByDescriptionContainingIgnoreCase("asilo");
    }

    // ------------------------------------------------------------------
    // Resolution by keyword only (no ATECO code)
    // ------------------------------------------------------------------

    @Test
    @DisplayName("Resolves by sector-activity keyword when no ATECO code is given")
    void resolveByKeyword_found() {
        AtecoEaMapping mapping = mapping("88.91.00", 37, "Education");
        when(repository.findFirstByDescriptionContainingIgnoreCase("asilo nido"))
                .thenReturn(Optional.of(mapping));

        AtecoEaMapping result = resolver.resolve(null, "asilo nido");

        assertThat(result.getAtecoCode()).isEqualTo("88.91.00");
        verify(repository, never()).findByAtecoCode(any());
    }

    // ------------------------------------------------------------------
    // Error paths
    // ------------------------------------------------------------------

    @Test
    @DisplayName("Throws IllegalArgumentException when neither ATECO nor keyword matches anything")
    void resolve_nothingMatches_throwsIllegalArgument() {
        when(repository.findByAtecoCode("99.99.99")).thenReturn(Optional.empty());
        when(repository.findFirstByDescriptionContainingIgnoreCase("xyzzy"))
                .thenReturn(Optional.empty());

        assertThatThrownBy(() -> resolver.resolve("99.99.99", "xyzzy"))
                .isInstanceOf(InvalidSearchRequestException.class)
                .hasMessageContaining("No sector mapping found");
    }

    @Test
    @DisplayName("Throws IllegalArgumentException when only keyword is given and does not match")
    void resolve_keywordOnly_noMatch_throwsIllegalArgument() {
        when(repository.findFirstByDescriptionContainingIgnoreCase("unknown"))
                .thenReturn(Optional.empty());

        assertThatThrownBy(() -> resolver.resolve(null, "unknown"))
                .isInstanceOf(InvalidSearchRequestException.class);
    }

    // ------------------------------------------------------------------
    // Helper
    // ------------------------------------------------------------------

    private AtecoEaMapping mapping(String ateco, int ea, String description) {
        return new AtecoEaMapping(ateco, "test description", ea, description);
    }
}
