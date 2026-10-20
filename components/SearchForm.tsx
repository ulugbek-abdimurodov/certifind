"use client";

import type { FormEvent } from "react";
import { demoPresets } from "../app/search-data";

type SearchFormProps = {
  iso: string;
  sector: string;
  ateco: string;
  loading: boolean;
  onIsoChange: (value: string) => void;
  onSectorChange: (value: string) => void;
  onAtecoChange: (value: string) => void;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
};

export function SearchForm({
  iso,
  sector,
  ateco,
  loading,
  onIsoChange,
  onSectorChange,
  onAtecoChange,
  onSubmit,
}: SearchFormProps) {
  return (
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
                onIsoChange(preset.iso);
                onSectorChange(preset.sector);
                onAtecoChange(preset.ateco);
              }}
            >
              {preset.label}
            </button>
          ))}
        </div>
      </div>
      <form onSubmit={onSubmit}>
        <label htmlFor="standard">Standard ISO</label>
        <div className="input-wrap">
          <span className="input-icon">◎</span>
          <select
            id="standard"
            value={iso}
            onChange={(event) => onIsoChange(event.target.value)}
          >
            <option>ISO 9001</option>
            <option>ISO 14001</option>
            <option>ISO 45001</option>
          </select>
          <span className="select-chevron">⌄</span>
        </div>
        <label htmlFor="sector">Settore di attività</label>
        <div className="input-wrap">
          <input
            id="sector"
            value={sector}
            onChange={(event) => onSectorChange(event.target.value)}
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
            onChange={(event) => onAtecoChange(event.target.value)}
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
  );
}
