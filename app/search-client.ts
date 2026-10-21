import type { SearchResponse } from "./search-types";
import { DEFAULT_API_URL } from "./search-defaults";

export class SearchApiError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "SearchApiError";
  }
}

type SearchPayload = {
  isoStandard: string;
  sectorActivity: string;
  atecoCode: string;
};

export async function searchOrganizations(
  payload: SearchPayload,
): Promise<SearchResponse> {
  const baseUrl = (process.env.NEXT_PUBLIC_API_URL ?? DEFAULT_API_URL).replace(/\/+$/, "");
  const searchUrl = baseUrl.endsWith("/api/v1")
    ? `${baseUrl}/search`
    : baseUrl.endsWith("/api")
    ? `${baseUrl}/v1/search`
    : `${baseUrl}/api/v1/search`;

  const response = await fetch(
    searchUrl,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    },
  );

  if (!response.ok) {
    throw new SearchApiError(
      response.status === 400
        ? "Settore non riconosciuto. Controlla il codice ATECO o la descrizione."
        : "Ricerca non riuscita. Riprova tra poco.",
    );
  }

  return (await response.json()) as SearchResponse;
}
