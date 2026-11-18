package com.certifind.service;

import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;

/**
 * Keyword matching shared by the management system and product searches. Each typed word
 * becomes a case-insensitive PostgreSQL regex ({@code ~*}) and every word must match.
 */
final class KeywordPattern {

    static final int MAX_TOKENS = 6;

    private KeywordPattern() {
    }

    /**
     * Adds one condition per word: every word must appear in {@code haystack}. Parameters are
     * named {@code prefix0}, {@code prefix1}, ...
     */
    static void appendTokens(StringBuilder sql, MapSqlParameterSource params, String haystack,
                             String prefix, String text) {
        if (text == null || text.isBlank()) return;
        String[] tokens = text.trim().split("\\s+");
        for (int i = 0; i < Math.min(tokens.length, MAX_TOKENS); i++) {
            String name = prefix + i;
            sql.append(" AND ").append(haystack).append(" ~* :").append(name);
            params.addValue(name, of(tokens[i]));
        }
    }

    /**
     * The regex for one typed word. Words match anywhere ("packag" finds "packaging"), but a
     * number must be a whole number: "11951" finds "EN 11951" and "11951-2", never "119511";
     * "17021" finds "17021-1". Spaces are optional where letters meet digits, so "EN1090"
     * finds "EN 1090" and "EN 1090" finds "EN1090".
     */
    static String of(String token) {
        StringBuilder out = new StringBuilder();
        if (Character.isDigit(token.charAt(0))) out.append("(?<![0-9])");
        for (int k = 0; k < token.length(); k++) {
            char c = token.charAt(k);
            char prev = k > 0 ? token.charAt(k - 1) : ' ';
            if (k > 0 && Character.isDigit(c) != Character.isDigit(prev)
                    && Character.isLetterOrDigit(c) && Character.isLetterOrDigit(prev)) {
                out.append("\\s*");
            }
            out.append(Character.isLetterOrDigit(c) ? String.valueOf(c) : "\\" + c);
        }
        if (Character.isDigit(token.charAt(token.length() - 1))) out.append("(?![0-9])");
        return out.toString();
    }
}
