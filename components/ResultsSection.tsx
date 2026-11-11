"use client";

import { useRef } from "react";
import type { Body, ResultFilter, SearchResponse } from "../app/search-types";
import {
  countryLabel,
  flagFor,
  formatDate,
  matchesFilter,
  shortStandard,
  standardsLabel,
} from "../app/search-data";
import { RecognitionLabels } from "./RecognitionLabels";

type ResultsSectionProps = {
  data: SearchResponse | null;
  error: string;
  iso: string;
  resultFilter: ResultFilter;
  onFilterChange: (filter: ResultFilter) => void;
  onSelect: (body: Body) => void;
};

export function ResultsSection({
  data,
  error,
  iso,
  resultFilter,
  onFilterChange,
  onSelect,
}: ResultsSectionProps) {
  // One pill per (country, accreditation body): ESYD accredits Greek, Cypriot and Maltese bodies.
  const accreditorInfo = data
    ? Array.from(
        new Map(
          data.results
            .filter((body) => body.accreditationBodyCode !== "ACCREDIA")
            .map((body) => [
              `${body.accreditationBodyCode}|${body.country}`,
              { code: body.accreditationBodyCode, country: body.country },
            ]),
        ).values(),
      ).sort(
        (a, b) => countryLabel(a.country).localeCompare(countryLabel(b.country), "it") || a.code.localeCompare(b.code),
      )
    : [];
  const listRef = useRef<HTMLDivElement>(null);
  // Picking a filter jumps straight to the matching companies instead of leaving them below the pills.
  const selectFilter = (filter: ResultFilter) => {
    onFilterChange(filter);
    requestAnimationFrame(() =>
      listRef.current?.scrollIntoView({ behavior: "smooth", block: "start" }),
    );
  };
  const results = data?.results ?? [];
  const filteredResults = results.filter((body) => matchesFilter(body, resultFilter));
  const countForFilter = (filter: ResultFilter) =>
    results.filter((body) => matchesFilter(body, filter)).length;
  const italyCount = countForFilter("italy");

  return (
    <section className="results-section" id="results">
      {error && (
        <div className="notice error-notice">
          <span>!</span>
          <div>
            <strong>Non siamo riusciti a completare la ricerca</strong>
            <p>{error}</p>
          </div>
        </div>
      )}
      {data ? (
        <>
          <div className="results-heading">
            <div>
              <div className="eyebrow">
                <span className="eyebrow-line" /> RISULTATI DELLA RICERCA
              </div>
              <h2>
                {filteredResults.length} organismi{" "}
                <em>{data.directory ? "nel database" : "trovati"}</em>
              </h2>
              <p>
                {data.directory
                  ? "Elenco completo delle aziende presenti nel database"
                  : `Per ${shortStandard(iso)} · ${data.resolvedEaDescription} (EA ${data.resolvedEaCode})`}
              </p>
            </div>
            <div className="results-mark">
              <span>ⓘ</span> Dati da verificare
            </div>
          </div>
          {data.results.length ? (
            <>
              <div className="results-filters" aria-label="Filtra risultati">
                <div
                  className="filter-pills"
                  role="group"
                  aria-label="Autorità di accreditamento"
                >
                  <FilterButton
                    active={resultFilter === "all"}
                    onClick={() => selectFilter("all")}
                  >
                    Tutti ({results.length})
                  </FilterButton>
                  {italyCount > 0 && (
                    <FilterButton
                      active={resultFilter === "italy"}
                      onClick={() => selectFilter("italy")}
                    >
                      Italia • ACCREDIA ({italyCount})
                    </FilterButton>
                  )}
                  {accreditorInfo.map(({ code, country }) => {
                    const filter = `accreditor:${code}|${country}` as const;
                    return (
                      <FilterButton
                        key={filter}
                        active={resultFilter === filter}
                        onClick={() => selectFilter(filter)}
                      >
                        {countryLabel(country)} • {code} ({countForFilter(filter)})
                      </FilterButton>
                    );
                  })}
                </div>
              </div>
              <div ref={listRef} style={{ scrollMarginTop: "1rem" }} />
              {filteredResults.length ? (
                <div className="results-list">
                  {filteredResults.map((body, index) => (
                    <button
                      className="result-card"
                      key={body.id}
                      type="button"
                      onClick={() => onSelect(body)}
                    >
                      <div className="result-number">
                        {String(index + 1).padStart(2, "0")}
                      </div>
                      <div className="country-flag" aria-label={countryLabel(body.country)}>
                        {flagFor(body.country)}
                      </div>
                      <div className="result-main">
                        <div className="name-line">
                          <h3>{body.name}</h3>
                        </div>
                        <div className="scope-subtitle">
                          Scopo accreditato:{" "}
                          {body.scopes.length
                            ? standardsLabel(body.scopes)
                            : data.directory
                              ? body.scopeSection
                              : iso}
                        </div>
                        <div className="result-meta">
                          <span>{countryLabel(body.country)}</span>
                          <i /> <RecognitionLabels abCode={body.accreditationBodyCode} />
                          <i /> <span>{body.accreditationBodyCode}</span>
                          <i /> <span>{expiryLabel(body)}</span>
                        </div>
                        <div className="verified-label">
                          <span>ⓘ</span> Accreditamento dichiarato ·{" "}
                          {body.accreditationBodyCode}
                        </div>
                        {body.verifiedAt && (
                          <div className="provenance-label">
                            Ultimo controllo {formatDate(body.verifiedAt)}
                          </div>
                        )}
                      </div>
                      <span className="card-arrow">↗</span>
                    </button>
                  ))}
                </div>
              ) : (
                <EmptyState>
                  Nessun organismo corrisponde ai filtri selezionati.
                </EmptyState>
              )}
            </>
          ) : (
            <EmptyState>
              Nessun organismo trovato per i criteri selezionati.
            </EmptyState>
          )}
          <p className="data-note">
            <span>ⓘ</span> Verifica sempre lo stato corrente
            dell’accreditamento presso l’ente nazionale competente. I dati
            provengono da fonti dichiarate, ma non costituiscono una verifica
            indipendente dell’accreditamento corrente.
          </p>
        </>
      ) : (
        !error && (
          <div className="before-results">
            <div className="before-icon">⌕</div>
            <div>
              <strong>La tua ricerca inizia qui</strong>
              <p>
                Inserisci i criteri e avvia la ricerca per vedere gli organismi
                pertinenti.
              </p>
            </div>
            <span>01—05</span>
          </div>
        )
      )}
    </section>
  );
}

function expiryLabel(body: Body) {
  const expiry = formatDate(
    body.expiryDate ?? body.scopes.find((s) => s.expiryDate)?.expiryDate ?? null,
  );
  return expiry ? `Scadenza ${expiry}` : "Scadenza non disponibile";
}

function FilterButton({
  active,
  onClick,
  children,
}: {
  active: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      className={`filter-pill ${active ? "filter-pill-active" : ""}`}
      type="button"
      onClick={onClick}
      aria-pressed={active}
    >
      {children}
    </button>
  );
}

function EmptyState({ children }: { children: React.ReactNode }) {
  return <div className="empty-state">{children}</div>;
}
