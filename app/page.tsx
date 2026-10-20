"use client";

import { FormEvent, useEffect, useState } from "react";

type Body = {
  id: number;
  name: string;
  country: string;
  accreditationBodyCode: string;
  isIafMla: boolean;
  hasItalianAuditors: boolean;
  isCommercialPartner: boolean;
  phone: string | null;
  email: string | null;
  website: string | null;
  address: string | null;
  proofUrl: string | null;
  eaCode: number;
  eaDescription: string;
  scopeSection: string;
};
type SearchResponse = {
  resolvedAteco: string;
  resolvedEaCode: number;
  resolvedEaDescription: string;
  totalResults: number;
  results: Body[];
};

const stages = [
  "Inserimento",
  "Ricerca",
  "Verifica",
  "Arricchimento",
  "Risultati",
];
const flags: Record<string, string> = {
  Italy: "🇮🇹",
  Romania: "🇷🇴",
  Poland: "🇵🇱",
  Germany: "🇩🇪",
  "United Kingdom": "🇬🇧",
};

const demoPresets = [
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

export default function Home() {
  const [iso, setIso] = useState("ISO 9001");
  const [sector, setSector] = useState("Asilo nido");
  const [ateco, setAteco] = useState("88.91.00");
  const [step, setStep] = useState(-1);
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<SearchResponse | null>(null);
  const [error, setError] = useState("");
  const [selected, setSelected] = useState<Body | null>(null);

  useEffect(() => {
    if (!selected) return;
    const close = (event: KeyboardEvent) => {
      if (event.key === "Escape") setSelected(null);
    };
    window.addEventListener("keydown", close);
    document.body.style.overflow = "hidden";
    return () => {
      window.removeEventListener("keydown", close);
      document.body.style.overflow = "";
    };
  }, [selected]);

  async function search(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (loading) return;
    setLoading(true);
    setError("");
    setData(null);
    setSelected(null);
    setStep(0);
    const animation = (async () => {
      for (let index = 1; index < stages.length; index += 1) {
        await new Promise((resolve) => window.setTimeout(resolve, 300));
        setStep(index);
      }
    })();
    try {
      const response = await fetch(
        `${process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:8080"}/api/v1/search`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            isoStandard: iso,
            sectorActivity: sector,
            atecoCode: ateco,
          }),
        },
      );
      if (!response.ok)
        throw new Error(
          response.status === 400
            ? "Settore non riconosciuto. Controlla il codice ATECO o la descrizione."
            : "Ricerca non riuscita. Riprova tra poco.",
        );
      const result = (await response.json()) as SearchResponse;
      setData(result);
    } catch (cause) {
      setError(
        cause instanceof Error
          ? cause.message
          : "Impossibile raggiungere il servizio. Verifica che l’API sia avviata.",
      );
    } finally {
      await animation;
      setStep(4);
      setLoading(false);
      document
        .getElementById("results")
        ?.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  return (
    <main>
      <header className="topbar">
        <a className="brand" href="#top">
          <span className="brand-mark">C</span>certi<span>find</span>
        </a>
        <div className="topbar-note">
          <span className="status-dot" /> Ricerca organismi accreditati
        </div>
        <a className="help-link" href="mailto:info@certifind.it">
          Hai bisogno di aiuto? <span>↗</span>
        </a>
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
        <div className="search-card">
          <div className="card-kicker">
            INIZIA LA RICERCA <span>01 / 03</span>
          </div>
          <h2>Di cosa hai bisogno?</h2>
          <p className="card-subtitle">
            Inserisci lo standard e l’attività della tua azienda.
          </p>
          <div className="demo-presets">
            <div className="demo-presets-label">SCENARIO DEMO RAPIDO</div>
            <div className="demo-presets-list">
              {demoPresets.map((preset) => (
                <button
                  className="demo-preset"
                  key={preset.label}
                  type="button"
                  onClick={() => {
                    setIso(preset.iso);
                    setSector(preset.sector);
                    setAteco(preset.ateco);
                  }}
                >
                  {preset.label}
                </button>
              ))}
            </div>
          </div>
          <form onSubmit={search}>
            <label htmlFor="standard">Standard ISO</label>
            <div className="input-wrap">
              <span className="input-icon">◎</span>
              <select
                id="standard"
                value={iso}
                onChange={(event) => setIso(event.target.value)}
              >
                <option>ISO 9001</option>
                <option>ISO 14001</option>
                <option>ISO 45001</option>
              </select>
              <span className="select-chevron">⌄</span>
            </div>
            <label htmlFor="sector">Settore di attività</label>
            <div className="input-wrap">
              <span className="input-icon">⌕</span>
              <input
                id="sector"
                value={sector}
                onChange={(event) => setSector(event.target.value)}
                placeholder="Es. Asilo nido, software…"
                required
              />
            </div>
            <label htmlFor="ateco">
              Codice ATECO <span className="optional">OPZIONALE</span>
            </label>
            <div className="input-wrap">
              <span className="input-icon code-icon">#</span>
              <input
                id="ateco"
                value={ateco}
                onChange={(event) => setAteco(event.target.value)}
                placeholder="Es. 88.91.00"
              />
            </div>
            <button className="search-button" type="submit" disabled={loading}>
              {loading ? (
                "Ricerca in corso…"
              ) : (
                <>
                  Avvia ricerca <span>→</span>
                </>
              )}
            </button>
          </form>
          <div className="privacy-note">
            <span>♢</span> Nessun dato aziendale viene salvato
          </div>
        </div>
      </section>

      <section className="workflow" aria-label="Fasi della ricerca">
        <div className="workflow-head">
          <span>IL PROCESSO</span>
          <span>Una ricerca, cinque passaggi</span>
        </div>
        <div className="steps">
          {stages.map((name, index) => (
            <div
              className={`step ${step >= index ? "step-done" : ""} ${step === index && loading ? "step-current" : ""}`}
              key={name}
            >
              <div className="step-node">
                {step > index ? "✓" : `0${index + 1}`}
              </div>
              <span>{name}</span>
            </div>
          ))}
        </div>
      </section>

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
        {data && (
          <>
            <div className="results-heading">
              <div>
                <div className="eyebrow">
                  <span className="eyebrow-line" /> RISULTATI DELLA RICERCA
                </div>
                <h2>
                  {data.totalResults} organismi <em>trovati</em>
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
              <div className="results-list">
                {data.results.map((body, index) => (
                  <button
                    className="result-card"
                    key={body.id}
                    onClick={() => setSelected(body)}
                  >
                    <div className="result-number">
                      {String(index + 1).padStart(2, "0")}
                    </div>
                    <div className="country-flag" aria-label={body.country}>
                      {flags[body.country] ?? "🌐"}
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
                        <i />{" "}
                        <span>
                          {iso} · EA {body.eaCode}
                        </span>
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
              <div className="empty-state">
                Nessun organismo trovato per i criteri selezionati.
              </div>
            )}
            <p className="data-note">
              <span>ⓘ</span> Verifica sempre lo stato corrente
              dell’accreditamento presso l’ente nazionale competente. I dati
              mostrati sono dimostrativi.
            </p>
          </>
        )}
        {!data && !error && (
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
        )}
      </section>

      <footer>
        <a className="brand footer-brand" href="#top">
          <span className="brand-mark">C</span>certi<span>find</span>
        </a>
        <span>Organismi, competenze, trasparenza.</span>
        <span>© 2026 CertiFind</span>
      </footer>

      {selected && (
        <div
          className="drawer-backdrop"
          onMouseDown={(event) => {
            if (event.target === event.currentTarget) setSelected(null);
          }}
        >
          <aside
            className="drawer"
            role="dialog"
            aria-modal="true"
            aria-labelledby="drawer-title"
          >
            <div className="drawer-top">
              <span>SCHEDA ORGANISMO</span>
              <button aria-label="Chiudi" onClick={() => setSelected(null)}>
                ×
              </button>
            </div>
            <div className="drawer-identity">
              <div className="drawer-flag">
                {flags[selected.country] ?? "🌐"}
              </div>
              <div>
                <div className="verified-label">
                  <span>✓</span> {selected.accreditationBodyCode}
                  {selected.isIafMla ? " · IAF/MLA" : ""}
                </div>
                <h2 id="drawer-title">{selected.name}</h2>
                <p>
                  {selected.country} <span>·</span> EA {selected.eaCode}{" "}
                  {selected.eaDescription}
                </p>
              </div>
            </div>
            <div className="drawer-divider" />
            <section className="drawer-section">
              <div className="drawer-section-title">
                <span>03</span> CAMPO DI APPLICAZIONE ACCREDITATO
              </div>
              <div className="scope-highlight">
                <strong>
                  {iso} • EA {selected.eaCode} ({selected.eaDescription})
                </strong>
                <p>{selected.scopeSection}</p>
              </div>
              <div className="contact-list">
                {selected.phone && (
                  <a href={`tel:${selected.phone}`}>
                    <span>☎</span>
                    <div>
                      <small>Telefono</small>
                      {selected.phone}
                    </div>
                    <b>↗</b>
                  </a>
                )}
                {selected.email && (
                  <a href={`mailto:${selected.email}`}>
                    <span>✉</span>
                    <div>
                      <small>Email</small>
                      {selected.email}
                    </div>
                    <b>↗</b>
                  </a>
                )}
                {selected.website && (
                  <a href={selected.website} target="_blank" rel="noreferrer">
                    <span>↗</span>
                    <div>
                      <small>Sito web</small>
                      {selected.website.replace(/^https?:\/\//, "")}
                    </div>
                    <b>↗</b>
                  </a>
                )}
                {selected.address && (
                  <div className="address-row">
                    <span>⌖</span>
                    <div>
                      <small>Sede</small>
                      {selected.address}
                    </div>
                  </div>
                )}
              </div>
            </section>
            <section className="drawer-section criteria-section">
              <div className="drawer-section-title">
                <span>02</span> CRITERI DI COLLABORAZIONE
              </div>
              <p className="criteria-intro">
                Informazioni utili per valutare una possibile collaborazione.
              </p>
              <div className="criteria-list">
                <Criterion
                  label="Accreditamento IAF/MLA"
                  ok={selected.isIafMla}
                  detail={selected.accreditationBodyCode}
                />
                <Criterion
                  label="Scope ISO pertinente"
                  ok
                  detail={`${iso} · EA ${selected.eaCode}`}
                />
                <Criterion
                  label="Auditor di lingua italiana"
                  ok={selected.hasItalianAuditors}
                  detail={
                    selected.hasItalianAuditors
                      ? "Disponibilità indicata"
                      : "Non indicati"
                  }
                />
                <Criterion
                  label="Partner commerciale"
                  ok={selected.isCommercialPartner}
                  detail={
                    selected.isCommercialPartner
                      ? "Partner CertiFind"
                      : "Collaborazione da valutare"
                  }
                />
              </div>
            </section>
            {selected.proofUrl && (
              <a
                className="source-link"
                href={selected.proofUrl}
                target="_blank"
                rel="noreferrer"
              >
                Consulta la fonte dell’accreditamento <span>↗</span>
              </a>
            )}
            <p className="drawer-disclaimer">
              Le informazioni e la disponibilità dei servizi vanno confermate
              direttamente con l’organismo.
            </p>
          </aside>
        </div>
      )}
    </main>
  );
}

function Criterion({
  label,
  ok,
  detail,
}: {
  label: string;
  ok: boolean;
  detail: string;
}) {
  return (
    <div className="criterion">
      <span className={`criterion-icon ${ok ? "yes" : "no"}`}>
        {ok ? "✓" : "–"}
      </span>
      <div>
        <strong>{label}</strong>
        <small>{detail}</small>
      </div>
      <span className={ok ? "criterion-status yes-text" : "criterion-status"}>
        {ok ? "PRESENTE" : "DA VERIFICARE"}
      </span>
    </div>
  );
}
