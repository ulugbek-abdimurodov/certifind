export const stages = [
  "Inserimento",
  "Ricerca",
  "Verifica",
  "Arricchimento",
  "Risultati",
];

export const DEFAULT_SEARCH_FORM = {
  iso: "ISO 9001",
  sector: "Asilo nido",
  ateco: "88.91.00",
};

/**
 * Fallback API base URL used only when NEXT_PUBLIC_API_URL is not set.
 * In production (behind Caddy) NEXT_PUBLIC_API_URL is always "/api/v1".
 */
export const DEFAULT_API_URL = "/api/v1";

export const countryFlags: Record<string, string> = {
  Italy: "🇮🇹",
  Romania: "🇷🇴",
  Poland: "🇵🇱",
  Germany: "🇩🇪",
  "United Kingdom": "🇬🇧",
};

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
