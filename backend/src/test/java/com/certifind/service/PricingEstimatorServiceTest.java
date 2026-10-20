package com.certifind.service;

import com.certifind.domain.AccreditationBody;
import com.certifind.domain.CertificationBody;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.junit.jupiter.api.Assertions.*;

class PricingEstimatorServiceTest {

    private PricingEstimatorService pricingService;

    @BeforeEach
    void setUp() {
        pricingService = new PricingEstimatorService();
    }

    @Test
    @DisplayName("Calculate with parent accreditation body fallback rate (e.g. RENAR 650 EUR)")
    void testCalculationWithAccreditationFallback() {
        AccreditationBody renar = new AccreditationBody(
                "RENAR", "Organismul National de Acreditare", "Romania",
                true, new BigDecimal("650.00"), "https://www.renar.ro"
        );
        CertificationBody srac = new CertificationBody(
                "SRAC Cert S.R.L.", "Romania", renar,
                true, true, null,
                "+40 21 313 6335", "office@srac.ro", "https://www.srac.ro", "Str. Vasile Parvan 14"
        );

        PricingEstimatorService.PriceCalculation calc = pricingService.calculate(srac, 3);

        assertEquals(3, calc.estimatedManDays());
        assertEquals(650.0, calc.dailyRateEur());
        assertEquals(350.0, calc.baseAdminFeeEur());
        assertEquals(2300.0, calc.totalCostEur()); // 3 * 650 + 350
        assertEquals(3650.0, calc.italianBenchmarkCostEur()); // 3 * 1100 + 350
        assertEquals(1350.0, calc.savingsEur());
        assertEquals(37, calc.savingsPercentage()); // round((1350 / 3650) * 100) = 37%
    }

    @Test
    @DisplayName("Calculate with custom daily rate overriding accreditation body")
    void testCalculationWithCustomRate() {
        AccreditationBody accredia = new AccreditationBody(
                "ACCREDIA", "L'Ente Italiano di Accreditamento", "Italy",
                true, new BigDecimal("1100.00"), "https://www.accredia.it"
        );
        CertificationBody dnv = new CertificationBody(
                "DNV Business Assurance Italy S.r.l.", "Italy", accredia,
                true, false, new BigDecimal("950.00"),
                "+39 039 6899 905", "info@dnv.com", "https://www.dnv.com", "Vimercate"
        );

        PricingEstimatorService.PriceCalculation calc = pricingService.calculate(dnv, 3);

        assertEquals(950.0, calc.dailyRateEur());
        assertEquals(3200.0, calc.totalCostEur()); // 3 * 950 + 350
        assertEquals(3650.0, calc.italianBenchmarkCostEur());
        assertEquals(450.0, calc.savingsEur());
        assertEquals(12, calc.savingsPercentage());
    }

    @Test
    @DisplayName("Calculate benchmark domestic rate with 0% savings")
    void testDomesticBenchmarkCalculation() {
        AccreditationBody accredia = new AccreditationBody(
                "ACCREDIA", "L'Ente Italiano di Accreditamento", "Italy",
                true, new BigDecimal("1100.00"), "https://www.accredia.it"
        );
        CertificationBody sgs = new CertificationBody(
                "SGS Italia S.p.A.", "Italy", accredia,
                true, false, null,
                null, null, null, null
        );

        PricingEstimatorService.PriceCalculation calc = pricingService.calculate(sgs);

        assertEquals(3, calc.estimatedManDays());
        assertEquals(1100.0, calc.dailyRateEur());
        assertEquals(3650.0, calc.totalCostEur());
        assertEquals(3650.0, calc.italianBenchmarkCostEur());
        assertEquals(0.0, calc.savingsEur());
        assertEquals(0, calc.savingsPercentage());
    }
}
