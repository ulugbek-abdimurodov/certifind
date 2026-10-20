"use client";

import { FormEvent, useEffect, useState } from "react";
import { OrganizationDrawer } from "../components/OrganizationDrawer";
import { ResultsSection } from "../components/ResultsSection";
import { SearchForm } from "../components/SearchForm";
import { Workflow } from "../components/Workflow";
import { stages } from "./search-data";
import type { Body, ResultFilter, SearchResponse } from "./search-types";

export default function Home() {
  const [iso, setIso] = useState("ISO 9001");
  const [sector, setSector] = useState("Asilo nido");
  const [ateco, setAteco] = useState("88.91.00");
  const [step, setStep] = useState(-1);
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<SearchResponse | null>(null);
  const [error, setError] = useState("");
  const [selected, setSelected] = useState<Body | null>(null);
  const [resultFilter, setResultFilter] = useState<ResultFilter>("all");
  const [partnerOnly, setPartnerOnly] = useState(false);

  useEffect(() => {
    if (!selected) return;
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === "Escape") setSelected(null);
    };
    window.addEventListener("keydown", closeOnEscape);
    document.body.style.overflow = "hidden";
    return () => {
      window.removeEventListener("keydown", closeOnEscape);
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
    setResultFilter("all");
    setPartnerOnly(false);
    setStep(0);

    const animation = animateWorkflow();
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
      if (!response.ok) {
        throw new Error(
          response.status === 400
            ? "Settore non riconosciuto. Controlla il codice ATECO o la descrizione."
            : "Ricerca non riuscita. Riprova tra poco.",
        );
      }
      setData((await response.json()) as SearchResponse);
    } catch (cause) {
      setError(
        cause instanceof Error
          ? cause.message
          : "Impossibile raggiungere il servizio. Verifica che l’API sia avviata.",
      );
    } finally {
      await animation;
      setStep(stages.length - 1);
      setLoading(false);
      document
        .getElementById("results")
        ?.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }

  async function animateWorkflow() {
    for (let index = 1; index < stages.length; index += 1) {
      await new Promise((resolve) => window.setTimeout(resolve, 300));
      setStep(index);
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
        <SearchForm
          iso={iso}
          sector={sector}
          ateco={ateco}
          loading={loading}
          onIsoChange={setIso}
          onSectorChange={setSector}
          onAtecoChange={setAteco}
          onSubmit={search}
        />
      </section>
      <Workflow step={step} loading={loading} />
      <ResultsSection
        data={data}
        error={error}
        iso={iso}
        resultFilter={resultFilter}
        partnerOnly={partnerOnly}
        onFilterChange={setResultFilter}
        onPartnerChange={setPartnerOnly}
        onSelect={setSelected}
      />
      <footer>
        <a className="brand footer-brand" href="#top">
          <span className="brand-mark">C</span>certi<span>find</span>
        </a>
        <span>Organismi, competenze, trasparenza.</span>
        <span>© 2026 CertiFind</span>
      </footer>
      <OrganizationDrawer body={selected} iso={iso} onClose={() => setSelected(null)} />
    </main>
  );
}
