package com.certifind.repository;

import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.TreeSet;
import java.util.function.Predicate;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.certifind.domain.SectorKeyword;

@Repository
public interface SectorKeywordRepository extends JpaRepository<SectorKeyword, Integer> {

    /**
     * Every keyword the text could mean: keywords containing the text, and keywords the
     * text contains. {@code pattern} is {@code text} with LIKE wildcards escaped
     * (see {@link #escapeLike}). {@link #match} picks among them.
     */
    @Query(value = """
        SELECT * FROM sector_keywords k
        WHERE lower(k.keyword) LIKE '%' || lower(:pattern) || '%' ESCAPE '!'
           OR lower(:text) LIKE '%' || lower(k.keyword) || '%'
        ORDER BY k.id
        """, nativeQuery = true)
    List<SectorKeyword> findCandidates(@Param("text") String text, @Param("pattern") String pattern);

    /**
     * Resolves free sector text to one EA code, by the strongest kind of match found:
     * <ol>
     *   <li>a keyword equal to the text;</li>
     *   <li>keywords starting with the text ("metall" -> "metallo", "metallurgia");</li>
     *   <li>keywords with a word starting with the text ("software" -> "produzione di software");</li>
     *   <li>the longest keywords inside the text ("carpenteria metallica Brescia").</li>
     * </ol>
     * The first level with any match decides. If its keywords point to different EA codes
     * the text is ambiguous ("produzione" -> software, gas, water, electricity) and no sector
     * is guessed.
     */
    default KeywordMatch match(String text) {
        String query = text.trim().toLowerCase(Locale.ROOT);
        List<SectorKeyword> candidates = findCandidates(query, escapeLike(query));
        List<Predicate<String>> levels = List.of(
                keyword -> keyword.equals(query),
                keyword -> keyword.startsWith(query),
                keyword -> WORD_START.matcher(keyword).results()
                        .anyMatch(m -> keyword.startsWith(query, m.start())));
        for (Predicate<String> level : levels) {
            KeywordMatch result = KeywordMatch.of(candidates.stream()
                    .filter(k -> level.test(k.getKeyword().toLowerCase(Locale.ROOT)))
                    .toList());
            if (result != null) return result;
        }
        int longest = candidates.stream()
                .filter(k -> query.contains(k.getKeyword().toLowerCase(Locale.ROOT)))
                .mapToInt(k -> k.getKeyword().length()).max().orElse(0);
        KeywordMatch result = KeywordMatch.of(candidates.stream()
                .filter(k -> k.getKeyword().length() == longest
                        && query.contains(k.getKeyword().toLowerCase(Locale.ROOT)))
                .toList());
        return result != null ? result : new KeywordMatch(null, Set.of());
    }

    /** Start of each word: the first letter, and any letter after a space, hyphen, slash or quote. */
    Pattern WORD_START = Pattern.compile("(?<![\\p{L}\\p{N}])[\\p{L}\\p{N}]");

    /**
     * Outcome of {@link #match}: {@code eaCode} when the text points to one sector;
     * otherwise {@code eaCode} is null and {@code ambiguousCodes} lists the sectors it
     * could mean (empty when nothing matched).
     */
    record KeywordMatch(Integer eaCode, Set<Integer> ambiguousCodes) {
        static KeywordMatch of(List<SectorKeyword> keywords) {
            Set<Integer> codes = keywords.stream().map(SectorKeyword::getEaCode)
                    .collect(Collectors.toCollection(TreeSet::new));
            if (codes.isEmpty()) return null;
            return codes.size() == 1 ? new KeywordMatch(codes.iterator().next(), Set.of())
                                     : new KeywordMatch(null, codes);
        }
    }

    /** Escapes LIKE wildcards with '!' (the query's ESCAPE character). */
    static String escapeLike(String text) {
        return text.replace("!", "!!").replace("%", "!%").replace("_", "!_");
    }
}
