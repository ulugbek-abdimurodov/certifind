package com.certifind.service;

import com.certifind.domain.CertificationBody;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Service
public class PricingEstimatorService {

    public static final double ITALIAN_BENCHMARK_DAY_RATE = 1100.0;
    public static final double BASE_ADMIN_FEE_EUR = 350.0;
    public static final int DEFAULT_MAN_DAYS = 3;

    public record PriceCalculation(
        int estimatedManDays,
        double dailyRateEur,
        double baseAdminFeeEur,
        double totalCostEur,
        double italianBenchmarkCostEur,
        double savingsEur,
        int savingsPercentage
    ) {}

    public PriceCalculation calculate(CertificationBody cb) {
        return calculate(cb, DEFAULT_MAN_DAYS);
    }

    public PriceCalculation calculate(CertificationBody cb, int manDays) {
        if (manDays <= 0) {
            manDays = DEFAULT_MAN_DAYS;
        }

        BigDecimal rateBd = (cb != null && cb.getCustomDailyRateEur() != null)
                ? cb.getCustomDailyRateEur()
                : (cb != null && cb.getAccreditationBody() != null ? cb.getAccreditationBody().getAvgDailyRateEur() : null);

        double effectiveRate = rateBd != null ? rateBd.doubleValue() : ITALIAN_BENCHMARK_DAY_RATE;

        return calculate(effectiveRate, manDays);
    }

    public PriceCalculation calculate(double dailyRateEur, int manDays) {
        if (manDays <= 0) {
            manDays = DEFAULT_MAN_DAYS;
        }

        double totalCost = roundCurrency((manDays * dailyRateEur) + BASE_ADMIN_FEE_EUR);
        double benchmarkCost = roundCurrency((manDays * ITALIAN_BENCHMARK_DAY_RATE) + BASE_ADMIN_FEE_EUR);
        double savings = roundCurrency(Math.max(0.0, benchmarkCost - totalCost));

        int savingsPercentage = benchmarkCost > 0
                ? (int) Math.round((savings / benchmarkCost) * 100.0)
                : 0;

        return new PriceCalculation(
                manDays,
                roundCurrency(dailyRateEur),
                BASE_ADMIN_FEE_EUR,
                totalCost,
                benchmarkCost,
                savings,
                savingsPercentage
        );
    }

    private double roundCurrency(double value) {
        return BigDecimal.valueOf(value)
                .setScale(2, RoundingMode.HALF_UP)
                .doubleValue();
    }
}
