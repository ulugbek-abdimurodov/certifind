"use client";

import { Fragment, useRef, useState } from "react";

/** Cards rendered per page; the rest appear on "Mostra altri". */
const PAGE_SIZE = 50;
import type { Body, ResultFilter, SearchResponse } from "../app/search-types";
import {
  countryLabel,
  formatDate,
  matchesFilter,
  productLineText,
  recognitionLabels,
  shortStandard,
  standardsLabel,
} from "../app/search-data";
import { CountryFlag } from "./CountryFlag";
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
  // First layer: EA / IAF recognition. ABs recognised by both appear under either.
  const [recognition, setRecognition] = useState<RecognitionFilter>("all");
  const [visibleCount, setVisibleCount] = useState(PAGE_SIZE);
  // Back to the first page whenever the result set or a filter changes.
  const [pageKey, setPageKey] = useState<unknown[]>([]);
  const currentKey = [data, recognition, resultFilter];
  if (currentKey.some((value, i) => value !== pageKey[i])) {
    setPageKey(currentKey);
    setVisibleCount(PAGE_SIZE);
  }
  const allResults = data?.results ?? [];
  const matchesRecognition = (
    body: Body,
    value: RecognitionFilter = recognition,
  ) =>
    value === "all" ||
    (value === "IAF"
      ? body.accreditationBodyCodes.some(
          (code) => !recognitionLabels(code).includes("EA"),
        )
      : body.accreditationBodyCodes.some((code) =>
          recognitionLabels(code).includes(value),
        ));
  const recognised = allResults.filter((body) => matchesRecognition(body));
  // One pill per (country, accreditation body): ESYD accredits Greek, Cypriot and Maltese bodies.
  const accreditorInfo = data
    ? Array.from(
        new Map(
          recognised.flatMap((body) =>
            body.accreditationBodyCodes.map(
              (code) =>
                [
                  `${code}|${body.country}`,
                  { code, country: body.country },
                ] as const,
            ),
          ),
        ).values(),
      ).sort(
        (a, b) =>
          countryLabel(a.country).localeCompare(
            countryLabel(b.country),
            "it",
          ) || a.code.localeCompare(b.code),
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
  const selectRecognition = (value: RecognitionFilter) => {
    setRecognition(value);
    onFilterChange("all");
  };
  const results = recognised;
  const filteredResults = results.filter((body) =>
    matchesFilter(body, resultFilter),
  );
  const countForFilter = (filter: ResultFilter) =>
    results.filter((body) => matchesFilter(body, filter)).length;

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
                {data.productSummary !== undefined
                  ? data.directory
                    ? "Certificazione di prodotto · elenco completo degli organismi"
                    : `Certificazione di prodotto · ${data.productSummary}`
                  : data.directory
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
                  aria-label="Riconoscimento"
                >
                  {(["all", "EA", "IAF"] as const).map((value) => (
                    <FilterButton
                      key={value}
                      active={recognition === value}
                      onClick={() => selectRecognition(value)}
                    >
                      {value === "all"
                        ? "Tutti"
                        : value === "IAF"
                          ? "IAF (senza EA)"
                          : value}{" "}
                      (
                      {
                        allResults.filter((body) =>
                          matchesRecognition(body, value),
                        ).length
                      }
                      )
                    </FilterButton>
                  ))}
                </div>
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
                  {accreditorInfo.map(({ code, country }) => {
                    const filter = `accreditor:${code}|${country}` as const;
                    return (
                      <FilterButton
                        key={filter}
                        active={resultFilter === filter}
                        onClick={() => selectFilter(filter)}
                      >
                        {countryLabel(country)} • {code} (
                        {countForFilter(filter)})
                      </FilterButton>
                    );
                  })}
                </div>
              </div>
              <div ref={listRef} style={{ scrollMarginTop: "1rem" }} />
              {filteredResults.length ? (
                <div className="results-list">
                  {filteredResults.slice(0, visibleCount).map((body, index) => (
                    <button
                      className="result-card"
                      key={body.id}
                      type="button"
                      onClick={() => onSelect(body)}
                    >
                      <div className="result-number">
                        {String(index + 1).padStart(2, "0")}
                      </div>
                      <div
                        className="country-flag"
                        aria-label={countryLabel(body.country)}
                      >
                        <CountryFlag country={body.country} />
                      </div>
                      <div className="result-main">
                        <div className="name-line">
                          <h3>{body.name}</h3>
                        </div>
                        {body.product ? (
                          <ProductMatchSummary
                            match={body.product}
                            directory={data.directory}
                          />
                        ) : (
                          <div className="scope-subtitle">
                            Scopo accreditato:{" "}
                            {body.standards.length
                              ? standardsLabel(body.standards)
                              : data.directory
                                ? body.scopeSection
                                : iso}
                          </div>
                        )}
                        <div className="result-meta">
                          <span>{countryLabel(body.country)}</span>
                          {body.accreditationBodyCodes.map((code) => (
                            <Fragment key={code}>
                              <i /> <RecognitionLabels abCode={code} />{" "}
                              <span>{code}</span>
                            </Fragment>
                          ))}
                          <i /> <span>{expiryLabel(body)}</span>
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
                  {filteredResults.length > visibleCount && (
                    <button
                      className="filter-pill"
                      type="button"
                      onClick={() =>
                        setVisibleCount((count) => count + PAGE_SIZE)
                      }
                    >
                      Mostra altri ({filteredResults.length - visibleCount}{" "}
                      rimanenti)
                    </button>
                  )}
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
            <span>ⓘ</span> Verifica sempre lo stato corrente dell’accreditamento
            presso l’ente nazionale competente. I dati provengono da fonti
            dichiarate, ma non costituiscono una verifica indipendente
            dell’accreditamento corrente.
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

type RecognitionFilter = "all" | "EA" | "IAF";

/** What matched on a product certification card: the schemes, then the first scope line. */
function ProductMatchSummary({
  match,
  directory,
}: {
  match: NonNullable<Body["product"]>;
  /** Full list: the lines are the whole scope, not search matches. */
  directory: boolean;
}) {
  const first = match.lines[0] ? productLineText(match.lines[0]) : null;
  const detail =
    first && (first.product ?? first.documents ?? first.schemeNote);
  return (
    <>
      <div className="scope-subtitle">
        {match.schemes.length ? (
          <>Schema: {match.schemes.join(", ")}</>
        ) : (
          <>Scopo accreditato: {first?.title}</>
        )}
      </div>
      {detail && <div className="product-line">{detail}</div>}
      {match.matchCount > 1 && (
        <div className="provenance-label">
          {directory
            ? `${match.matchCount} voci nello scopo`
            : `${match.matchCount} voci dello scopo corrispondono`}
        </div>
      )}
    </>
  );
}

function expiryLabel(body: Body) {
  const expiry = formatDate(body.expiryDate);
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
