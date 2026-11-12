import { countryCodeFor } from "../app/search-data";

/**
 * Flag image from flag-icons (bundled SVGs). Emoji flags are not used: Windows has no
 * flag glyphs and renders them as letter pairs ("MX").
 */
export function CountryFlag({ country }: { country: string }) {
  const code = countryCodeFor(country);
  return code ? (
    <span className={`fi fis fi-${code} country-flag-image`} aria-hidden="true" />
  ) : (
    <span aria-hidden="true">🌐</span>
  );
}
