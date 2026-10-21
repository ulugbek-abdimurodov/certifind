import type { SearchResponse } from "./search-types";
import { DEFAULT_API_URL } from "./search-data";

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

/**
 * Resolves the API base URL, normalising any trailing slashes.
 * NEXT_PUBLIC_API_URL should already be "/api/v1" in all deployed environments.
 */
function resolveSearchUrl(): string {
  const base = (process.env.NEXT_PUBLIC_API_URL ?? DEFAULT_API_URL).replace(
    /\/+$/,
    "",
  );
  return `${base}/search`;
}

export async function searchOrganizations(
  payload: SearchPayload,
): Promise<SearchResponse> {
  const response = await fetch(resolveSearchUrl(), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    // Try to extract the backend's structured error message before falling
    // back to a generic string. The ApiExceptionHandler returns a JSON body
    // with a "message" field on 4xx errors.
    let detail: string | undefined;
    try {
      const json = (await response.json()) as { message?: string };
      detail = json.message;
    } catch {
      // Response body was not JSON — ignore and use the fallback below.
    }

    throw new SearchApiError(
      detail?.trim() ||
        (response.status === 400
          ? "Settore non riconosciuto. Controlla il codice ATECO o la descrizione."
          : "Ricerca non riuscita. Riprova tra poco."),
    );
  }

  return (await response.json()) as SearchResponse;
}
