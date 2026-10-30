"use client";

import { useState, type FormEvent } from "react";
import { demoPresets } from "../app/search-data";
import type { SearchOptions, SearchPreset } from "../app/search-types";

type SearchFormProps = {
  iso: string;
  sector: string;
  loading: boolean;
  onIsoChange: (value: string) => void;
  onSectorChange: (value: string) => void;
  recentSearches: SearchPreset[];
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
  onShowAllCompanies: () => void;
  options: SearchOptions;
};

export function SearchForm({
  iso,
  sector,
  loading,
  onIsoChange,
  onSectorChange,
  recentSearches,
  onSubmit,
  onShowAllCompanies,
  options,
}: SearchFormProps) {
  const presets = recentSearches.length ? recentSearches : demoPresets;
  const [sectorFocused, setSectorFocused] = useState(false);
  const sectorQuery = sector.trim().toLocaleLowerCase();
  const sectorSuggestions = options.sectors.filter(
    (option) =>
      sectorQuery.length === 0 ||
      `EA ${option.code} ${option.name}`.toLocaleLowerCase().includes(sectorQuery),
  );

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
        <div className="demo-presets-label">
          {recentSearches.length ? "RICERCHE RECENTI" : "SCENARIO DEMO RAPIDO"}
        </div>
        <div className="demo-presets-list">
          {presets.map((preset) => (
            <button
              className="demo-preset"
              key={preset.label}
              type="button"
              onClick={() => {
                onIsoChange(preset.iso);
                onSectorChange(preset.sector);
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
            {options.standards.map((standard) => (
              <option key={standard}>{standard}</option>
            ))}
          </select>
          <span className="select-chevron">⌄</span>
        </div>
        <label htmlFor="sector">Settore di attività</label>
        <div className="sector-autocomplete">
          <div className="input-wrap">
          <input
            id="sector"
            value={sector}
            onChange={(event) => onSectorChange(event.target.value)}
            onFocus={() => setSectorFocused(true)}
            onBlur={() => {
              window.setTimeout(() => setSectorFocused(false), 150);
            }}
            placeholder="Es. Asilo nido, software…"
            aria-autocomplete="list"
            aria-controls="sector-suggestions"
            required
          />
          </div>
          {sectorFocused && sectorSuggestions.length > 0 && (
            <div
              className="sector-suggestions"
              id="sector-suggestions"
              role="listbox"
              aria-label="Settori disponibili"
            >
              {sectorSuggestions.map((suggestion) => (
                <button
                  className="sector-suggestion"
                  key={suggestion.code}
                  type="button"
                  role="option"
                  aria-selected={false}
                  onMouseDown={() => {
                    onSectorChange(`EA ${suggestion.code} - ${suggestion.name}`);
                    setSectorFocused(false);
                  }}
                >
                  EA {suggestion.code} - {suggestion.name}
                </button>
              ))}
            </div>
          )}
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
      <button
        className="directory-button"
        type="button"
        onClick={onShowAllCompanies}
        disabled={loading}
      >
        Vedi tutte le aziende <span>→</span>
      </button>
      <div className="privacy-note">
        <span>♢</span> Nessun dato aziendale viene salvato
      </div>
    </div>
  );
}
