"use client";

import type { ResultFilter, SearchResponse } from "../app/search-types";
import { countryFlags } from "../app/search-data";

type ResultsSectionProps = {
  data: SearchResponse | null;
  error: string;
  iso: string;
  resultFilter: ResultFilter;
  partnerOnly: boolean;
  onFilterChange: (filter: ResultFilter) => void;
  onPartnerChange: (onlyPartners: boolean) => void;
  onSelect: (body: SearchResponse["results"][number]) => void;
};

export function ResultsSection({
  data,
  error,
  iso,
  resultFilter,
  partnerOnly,
  onFilterChange,
  onPartnerChange,
  onSelect,
}: ResultsSectionProps) {
  const accreditorCodes = data
    ? Array.from(
        new Set(
          data.results
            .map((body) => body.accreditationBodyCode)
            .filter((code) => code !== "ACCREDIA"),
        ),
      ).sort()
    : [];
  const filteredResults =
    data?.results.filter((body) => {
      const matchesFilter =
        resultFilter === "all" ||
        (resultFilter === "italy" &&
          body.accreditationBodyCode === "ACCREDIA") ||
        (resultFilter === "foreign" &&
          body.accreditationBodyCode !== "ACCREDIA" &&
          body.isIafMla) ||
        (resultFilter.startsWith("accreditor:") &&
          body.accreditationBodyCode === resultFilter.slice(11));
      return matchesFilter && (!partnerOnly || body.isCommercialPartner);
    }) ?? [];
  const resultCount = filteredResults.length;
  const countForFilter = (filter: ResultFilter) =>
    data?.results.filter((body) => {
      const matchesFilter =
        filter === "all" ||
        (filter === "italy" && body.accreditationBodyCode === "ACCREDIA") ||
        (filter === "foreign" &&
          body.accreditationBodyCode !== "ACCREDIA" &&
          body.isIafMla) ||
        (filter.startsWith("accreditor:") &&
          body.accreditationBodyCode === filter.slice(11));
      return matchesFilter && (!partnerOnly || body.isCommercialPartner);
    }).length ?? 0;

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
                {resultCount} organismi <em>trovati</em>
              </h2>
              <p>
                Per {iso} · {data.resolvedEaDescription} (EA{" "}
                {data.resolvedEaCode}) · ATECO {data.resolvedAteco}
              </p>
            </div>
            <div className="results-mark">
              <span>✓</span> Accreditamenti consultabili
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
                    onClick={() => onFilterChange("all")}
                  >
                    Tutti ({countForFilter("all")})
                  </FilterButton>
                  <FilterButton
                    active={resultFilter === "italy"}
                    onClick={() => onFilterChange("italy")}
                  >
                    Italia • ACCREDIA ({countForFilter("italy")})
                  </FilterButton>
                  <FilterButton
                    active={resultFilter === "foreign"}
                    onClick={() => onFilterChange("foreign")}
                  >
                    Estero • IAF/MLA ({countForFilter("foreign")})
                  </FilterButton>
                  {accreditorCodes.map((code) => {
                    const filter = `accreditor:${code}` as const;
                    return (
                      <FilterButton
                        key={code}
                        active={resultFilter === filter}
                        onClick={() => onFilterChange(filter)}
                      >
                        {code} ({countForFilter(filter)})
                      </FilterButton>
                    );
                  })}
                </div>
                <label
                  className={`partner-filter ${
                    partnerOnly ? "partner-filter-active" : ""
                  }`}
                >
                  <input
                    type="checkbox"
                    checked={partnerOnly}
                    onChange={(event) => onPartnerChange(event.target.checked)}
                  />
                  <span>Solo Partner CertiFind</span>
                </label>
              </div>
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
                      <div className="country-flag" aria-label={body.country}>
                        {countryFlags[body.country] ?? "🌐"}
                      </div>
                      <div className="result-main">
                        <div className="name-line">
                          <h3>{body.name}</h3>
                          {body.isCommercialPartner && (
                            <span className="partner-pill">
                              <span>✦</span> Partner
                            </span>
                          )}
                        </div>
                        <div className="scope-subtitle">
                          Scopo accreditato: {body.scopeSection}
                        </div>
                        <div className="result-meta">
                          <span>{body.country}</span>
                          <i /> <span>{body.accreditationBodyCode}</span>
                          <i /> <span>{iso} · EA {body.eaCode}</span>
                        </div>
                        <div className="verified-label">
                          <span>✓</span> Accreditamento{" "}
                          {body.accreditationBodyCode}
                          {body.isIafMla ? " · IAF/MLA" : ""}
                        </div>
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
            mostrati sono dimostrativi.
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
