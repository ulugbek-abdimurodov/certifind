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

export function matchesFilter(body: Body, filter: ResultFilter) {
  const isItalian = body.accreditationBodyCode === "ACCREDIA";
  if (filter === "all") return true;
  if (filter === "italy") return isItalian;
  if (filter === "foreign") return !isItalian && body.isIafMla;
  return body.accreditationBodyCode === filter.slice("accreditor:".length);
}

export const demoPresets = [
  {
    label: "Asilo Nido (ISO 9001 • EA 37)",
    iso: "ISO 9001",
    sector: "Asilo nido",
    ateco: "88.91.00",
  },
  {
    label: "Software & IT (ISO 9001 • EA 33)",
    iso: "ISO 9001",
    sector: "Produzione di software",
    ateco: "62.01.00",
  },
  {
    label: "Edilizia & Sicurezza (ISO 45001 • EA 28)",
    iso: "ISO 45001",
    sector: "Costruzione di edifici",
    ateco: "41.20.00",
  },
  {
    label: "Studi Ingegneria (ISO 14001 • EA 34)",
    iso: "ISO 14001",
    sector: "Studi di ingegneria",
    ateco: "71.12.10",
  },
];
