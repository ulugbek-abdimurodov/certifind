package com.certifind.config;

import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig {

    /** Empty means no cross-origin access; local development sets localhost in application.yml. */
    @Value("${certifind.cors.allowed-origins:}")
    private String allowedOrigins;

    /** Set by the prod profile: every origin must be a public HTTPS origin, not a placeholder. */
    @Value("${certifind.cors.require-public-https:false}")
    private boolean requirePublicHttps;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins(parseAllowedOrigins())
                        .allowedMethods("GET", "POST", "OPTIONS")
                        .allowedHeaders("*")
                        .maxAge(3600);
            }
        };
    }

    private String[] parseAllowedOrigins() {
        List<String> origins = Arrays.stream(allowedOrigins.split(","))
                .map(String::trim)
                .filter(origin -> !origin.isEmpty())
                .toList();
        if (requirePublicHttps) {
            origins.forEach(WebConfig::checkProductionOrigin);
        }
        return origins.toArray(String[]::new);
    }

    private static final Pattern PRODUCTION_ORIGIN =
            Pattern.compile("https://[a-z0-9]([a-z0-9.-]*[a-z0-9])?(:[0-9]{1,5})?");

    /** Fails startup on an origin that would be wrong or unsafe in production. */
    static void checkProductionOrigin(String origin) {
        String lower = origin.toLowerCase(Locale.ROOT);
        String host = lower.replaceFirst("^https://", "").replaceFirst(":[0-9]+$", "");
        boolean placeholder = host.equals("localhost") || host.endsWith(".localhost")
                || host.matches("[0-9.]+") || host.startsWith("[")
                || host.matches("(.*[.])?example[.](com|org|net)") || host.endsWith(".example")
                || host.endsWith(".test") || host.endsWith(".invalid");
        if (!PRODUCTION_ORIGIN.matcher(lower).matches() || placeholder) {
            throw new IllegalStateException("CERTIFIND_CORS_ALLOWED_ORIGINS: '" + origin
                    + "' is not allowed in production. Use the frontend's exact public HTTPS origin"
                    + " (scheme and host, no path, wildcard or trailing slash), or leave it empty"
                    + " for a same-origin reverse proxy.");
        }
    }
}
