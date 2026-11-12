"use client";

import { FormEvent, useEffect, useRef, useState } from "react";
import { OrganizationDrawer } from "../components/OrganizationDrawer";
import { ResultsSection } from "../components/ResultsSection";
import { SearchForm } from "../components/SearchForm";
import { ThemeToggle } from "../components/ThemeToggle";
import { Workflow } from "../components/Workflow";
import { API_URL, stages } from "./search-data";
import type {
  Body,
  ResultFilter,
  SearchPreset,
  SearchResponse,
  SearchOptions,
} from "./search-types";

const RECENT_SEARCHES_KEY = "certifind:recent-searches:v2";
const MAX_RECENT_SEARCHES = 5;
const SERVICE_UNAVAILABLE =
  "Impossibile raggiungere il servizio. Verifica che l’API sia avviata.";
/** A results request still unanswered after this long is aborted and reported. */
const REQUEST_TIMEOUT_MS = 20_000;
const TIMED_OUT = "Il servizio non ha risposto in tempo. Riprova tra poco.";
/** While the options cannot be loaded, retry this often (and on every search). */
const OPTIONS_RETRY_MS = 5_000;

export default function Home() {
  const [iso, setIso] = useState("ISO 9001");
  const [sector, setSector] = useState("EA 12 - Prodotti chimici e fibre");
  const [step, setStep] = useState(-1);
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<SearchResponse | null>(null);
  // The standard the shown results were searched for: the dropdown may change afterwards.
  const [resultIso, setResultIso] = useState("ISO 9001");
  const [error, setError] = useState("");
  const [selected, setSelected] = useState<Body | null>(null);
  const [resultFilter, setResultFilter] = useState<ResultFilter>("all");
  const [recentSearches, setRecentSearches] = useState<SearchPreset[]>([]);
  const [options, setOptions] = useState<SearchOptions>({
    standards: [],
    sectorsByStandard: {},
  });
  const [optionsError, setOptionsError] = useState("");
  const optionsLoaded = useRef(false);

  useEffect(() => {
    // Deferred so the first render matches the server render (no localStorage there).
    const timeoutId = window.setTimeout(() => {
      setRecentSearches(readRecentSearches());
    }, 0);
    return () => window.clearTimeout(timeoutId);
  }, []);

  /** Loads standards and sectors; on failure, shows a notice in the form and retries. */
  async function loadOptions() {
    if (optionsLoaded.current) return;
    try {
      const response = await fetchWithTimeout(`${API_URL}/api/v1/options`);
      if (!response.ok) throw new Error();
      setOptions((await response.json()) as SearchOptions);
      optionsLoaded.current = true;
      setOptionsError("");
    } catch {
      setOptionsError(
        "Standard e settori non disponibili: il servizio non risponde. Nuovo tentativo in corso…",
      );
    }
  }

  useEffect(() => {
    // Keep trying until the API answers, so a page opened while it was down recovers by itself.
    // Deferred like the recent searches above, so the first render matches the server's.
    const first = window.setTimeout(loadOptions, 0);
    const retry = window.setInterval(() => {
      if (optionsLoaded.current) window.clearInterval(retry);
      else loadOptions();
    }, OPTIONS_RETRY_MS);
    return () => {
      window.clearTimeout(first);
      window.clearInterval(retry);
    };
  }, []);

  // Lock page scroll while the drawer is open (the drawer itself handles Escape).
  useEffect(() => {
    if (!selected) return;
    document.body.style.overflow = "hidden";
    return () => {
      document.body.style.overflow = "";
    };
  }, [selected]);

  /** Shared flow for every results request: reset state, animate, fetch, report errors. */
  async function runSearch(
    request: (signal: AbortSignal) => Promise<Response>,
    errorFor: (status: number) => string,
    onSuccess?: () => void,
  ) {
    if (loading) return;
    void loadOptions(); // the API may be back: refill the form too
    setLoading(true);
    setError("");
    setData(null);
    setSelected(null);
    setResultFilter("all");
    // Steps follow the request itself, so none is ticked before that stage has happened:
    // 1 Ricerca = request sent, 2 Verifica = response arrived, 3 Arricchimento = reading the
    // body, 4 Risultati = results shown.
    setStep(1);
    try {
      // The whole exchange (response and body) has a deadline, so the page cannot stay on
      // "Ricerca in corso…" when the API never answers.
      const results = await withDeadline(async (signal) => {
        const response = await request(signal);
        setStep(2);
        if (!response.ok) {
          // 400s carry an RFC 7807 problem whose detail is written for the user (e.g. too short).
          const problem = response.status === 400
            ? ((await response.json().catch(() => null)) as { detail?: string } | null)
            : null;
          throw new Error(problem?.detail || errorFor(response.status));
        }
        setStep(3);
        return (await response.json()) as SearchResponse;
      });
      setData(results);
      onSuccess?.();
    } catch (cause) {
      // fetch() rejects with a TypeError when the API cannot be reached.
      setError(
        cause instanceof DeadlineError
          ? TIMED_OUT
          : cause instanceof Error && !(cause instanceof TypeError)
            ? cause.message
            : SERVICE_UNAVAILABLE,
      );
    } finally {
      setStep(stages.length - 1);
      setLoading(false);
      document
        .getElementById("results")
        ?.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  function search(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    const searchedIso = iso;
    return runSearch(
      (signal) =>
        fetch(`${API_URL}/api/v1/search`, {
          signal,
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            isoStandard: iso,
            sectorActivity: sector,
          }),
        }),
      (status) =>
        status === 400
          ? "Settore non riconosciuto. Controlla la descrizione del settore."
          : "Ricerca non riuscita. Riprova tra poco.",
      () => {
        setResultIso(searchedIso);
        saveRecentSearch({ iso, sector });
      },
    );
  }

  function showAllCompanies() {
    return runSearch(
      (signal) => fetch(`${API_URL}/api/v1/companies`, { signal }),
      () => "Impossibile caricare l'elenco delle aziende.",
    );
  }

  function saveRecentSearch(searchPreset: Omit<SearchPreset, "label">) {
    const nextSearch: SearchPreset = {
      ...searchPreset,
      label: `${searchPreset.sector} (${searchPreset.iso})`,
    };
    const nextSearches = [
      nextSearch,
      ...recentSearches.filter(
        (recent) =>
          recent.iso !== nextSearch.iso || recent.sector !== nextSearch.sector,
      ),
    ].slice(0, MAX_RECENT_SEARCHES);

    setRecentSearches(nextSearches);
    window.localStorage.setItem(
      RECENT_SEARCHES_KEY,
      JSON.stringify(nextSearches),
    );
  }

  return (
    <main>
      <header className="topbar">
        <Brand className="brand" />
        <div className="topbar-note">
          <span className="status-dot" /> Ricerca organismi accreditati
        </div>
        <div className="topbar-actions">
          <ThemeToggle />
          <a className="help-link" href="mailto:info@certifind.it">
            Hai bisogno di aiuto? <span>↗</span>
          </a>
        </div>
      </header>
      <section className="hero" id="top">
        <div className="hero-copy">
          <div className="eyebrow">
            <span className="eyebrow-line" /> CERTIFICAZIONI, SENZA
            COMPLICAZIONI
          </div>
          <h1>
            Il partner giusto
            <br />
            per <em>certificarti.</em>
          </h1>
          <p>
            Trova gli organismi accreditati per il tuo settore. Confronta le
            competenze, verifica gli accreditamenti, scegli con consapevolezza.
          </p>
          <div className="hero-proof">
            <span className="proof-icon">✓</span>
            <span>
              Dati di accreditamento e contatti{" "}
              <strong>in un unico posto</strong>
            </span>
          </div>
        </div>
        <SearchForm
          iso={iso}
          sector={sector}
          loading={loading}
          onIsoChange={setIso}
          onSectorChange={setSector}
          recentSearches={recentSearches}
          onSubmit={search}
          onShowAllCompanies={showAllCompanies}
          options={options}
          optionsError={optionsError}
        />
      </section>
      <Workflow step={step} loading={loading} />
      <ResultsSection
        data={data}
        error={error}
        iso={resultIso}
        resultFilter={resultFilter}
        onFilterChange={setResultFilter}
        onSelect={setSelected}
      />
      <footer>
        <Brand className="brand footer-brand" />
        <span>Organismi, competenze, trasparenza.</span>
        <span>© 2026 CertiFind</span>
      </footer>
      <OrganizationDrawer body={selected} iso={resultIso} onClose={() => setSelected(null)} />
    </main>
  );
}

function Brand({ className }: { className: string }) {
  return (
    <a className={className} href="#top">
      <span className="brand-mark">C</span>certi<span>find</span>
    </a>
  );
}

function isSearchPreset(value: unknown): value is SearchPreset {
  if (!value || typeof value !== "object") return false;
  const preset = value as Partial<SearchPreset>;
  return (
    typeof preset.label === "string" &&
    typeof preset.iso === "string" &&
    typeof preset.sector === "string"
  );
}

function readRecentSearches(): SearchPreset[] {
  try {
    const stored = window.localStorage.getItem(RECENT_SEARCHES_KEY);
    if (!stored) return [];

    const parsed = JSON.parse(stored);
    return Array.isArray(parsed)
      ? parsed.filter(isSearchPreset).slice(0, MAX_RECENT_SEARCHES)
      : [];
  } catch {
    window.localStorage.removeItem(RECENT_SEARCHES_KEY);
    return [];
  }
}

class DeadlineError extends Error {}

/**
 * Runs work(signal) with a REQUEST_TIMEOUT_MS deadline. At the deadline the signal is aborted
 * (cancelling a real fetch) and the returned promise rejects with DeadlineError, even if the
 * work ignores the signal and never settles.
 */
function withDeadline<T>(work: (signal: AbortSignal) => Promise<T>): Promise<T> {
  const controller = new AbortController();
  let timer = 0;
  const deadline = new Promise<never>((_, reject) => {
    timer = window.setTimeout(() => {
      controller.abort();
      reject(new DeadlineError());
    }, REQUEST_TIMEOUT_MS);
  });
  return Promise.race([work(controller.signal), deadline]).finally(() =>
    window.clearTimeout(timer),
  );
}

/** fetch() with the same deadline. */
function fetchWithTimeout(url: string, init: RequestInit = {}) {
  return withDeadline((signal) => fetch(url, { ...init, signal }));
}
