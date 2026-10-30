import type { AccreditationScope, Body, ResultFilter } from "./search-types";

export const API_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080";

export const stages = [
  "Inserimento",
  "Ricerca",
  "Verifica",
  "Arricchimento",
  "Risultati",
];

const countryFlags: Record<string, string> = {
  Italy: "🇮🇹",
  Romania: "🇷🇴",
  Poland: "🇵🇱",
  Germany: "🇩🇪",
  "United Kingdom": "🇬🇧",
  Albania: "🇦🇱",
};

export const flagFor = (country: string) => countryFlags[country] ?? "🌐";

/** Short label for a scope: "EA 37", or "ISO 17025 (non-EA)" when no EA sector applies. */
export const scopeCode = (scope: AccreditationScope) =>
  scope.eaCode == null ? `${scope.isoStandard} (non-EA)` : `EA ${scope.eaCode}`;

const EA_SECTOR_COUNT = 39;

const coversAllSectors = (scopes: AccreditationScope[]) =>
  new Set(scopes.map((scope) => scope.eaCode).filter((code) => code != null)).size === EA_SECTOR_COUNT;

/** Scope list for one standard; a body covering all 39 EA sectors reads "Tutti i settori". */
export const scopeListLabel = (scopes: AccreditationScope[]) => {
  if (coversAllSectors(scopes)) return "Tutti i settori";
  return scopes.map(scopeCode).join(", ");
};

const scopeDetail = (scope: AccreditationScope) =>
  scope.eaCode == null ? scope.scopeSection : `EA ${scope.eaCode} (${scope.eaDescription})`;

/** One line per ISO standard, so the same EA sector is not repeated under each standard. */
export const scopeLinesByStandard = (scopes: AccreditationScope[]) => {
  const byStandard = new Map<string, AccreditationScope[]>();
  scopes.forEach((scope) => {
    byStandard.set(scope.isoStandard, [...(byStandard.get(scope.isoStandard) ?? []), scope]);
  });
  return [...byStandard].map(([iso, group]) => ({
    iso,
    label: coversAllSectors(group) ? "Tutti i settori" : group.map(scopeDetail).join(" / "),
  }));
};

export function matchesFilter(body: Body, filter: ResultFilter) {
  const isItalian = body.accreditationBodyCode === "ACCREDIA";
  if (filter === "all") return true;
  if (filter === "italy") return isItalian;
  if (filter === "foreign") return !isItalian;
  return body.accreditationBodyCode === filter.slice("accreditor:".length);
}

export const demoPresets = [
  {
    label: "Asilo Nido (ISO 9001 • EA 37)",
    iso: "ISO 9001",
    sector: "Asilo nido",
  },
  {
    label: "Software & IT (ISO 9001 • EA 33)",
    iso: "ISO 9001",
    sector: "Produzione di software",
  },
  {
    label: "Edilizia & Sicurezza (ISO 45001 • EA 28)",
    iso: "ISO 45001",
    sector: "Costruzione di edifici",
  },
  {
    label: "Studi Ingegneria (ISO 14001 • EA 34)",
    iso: "ISO 14001",
    sector: "Studi di ingegneria",
  },
];
