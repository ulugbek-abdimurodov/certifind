"use client";

import { useEffect, useRef, useState } from "react";
import type { AccreditationScope, Body } from "../app/search-types";
import {
  API_URL,
  countryLabel,
  formatDate,
  scopeLinesByStandard,
  shortStandard,
  standardLabel,
} from "../app/search-data";
import { CountryFlag } from "./CountryFlag";
import { RecognitionLabels } from "./RecognitionLabels";

export function OrganizationDrawer({
  body,
  iso,
  onClose,
}: {
  body: Body | null;
  iso: string;
  onClose: () => void;
}) {
  const [selectedStandard, setSelectedStandard] = useState<string | null>(null);
  // Scope rows are not part of the result list; fetch them for the open body. null = loading.
  const [loaded, setLoaded] = useState<{ id: number; scopes: AccreditationScope[] } | null>(null);
  const returnFocusRef = useRef<HTMLElement | null>(null);
  useEffect(() => {
    if (!body) return;
    const controller = new AbortController();
    // A one-standard card (every search result) only needs that standard's rows.
    const query = body.standards.length === 1
      ? `?standard=${encodeURIComponent(body.standards[0])}`
      : "";
    fetch(`${API_URL}/api/v1/companies/${body.id}/scopes${query}`, { signal: controller.signal })
      .then((response) => (response.ok ? response.json() : []))
      .then((scopes: AccreditationScope[]) => setLoaded({ id: body.id, scopes }))
      .catch(() => {
        if (!controller.signal.aborted) setLoaded({ id: body.id, scopes: [] });
      });
    return () => controller.abort();
  }, [body]);
  const onCloseRef = useRef(onClose);
  useEffect(() => {
    onCloseRef.current = onClose;
  }, [onClose]);

  useEffect(() => {
    if (!body) return;
    returnFocusRef.current = document.activeElement as HTMLElement | null;
    const drawer = document.querySelector<HTMLElement>("[data-organization-drawer]");
    const closeButton = drawer?.querySelector<HTMLButtonElement>("[data-drawer-close]");
    closeButton?.focus();
    const onKeyDown = (event: globalThis.KeyboardEvent) => {
      if (event.key === "Escape") {
        event.preventDefault();
        onCloseRef.current();
        return;
      }
      if (event.key !== "Tab" || !drawer) return;
      const focusable = Array.from(
        drawer.querySelectorAll<HTMLElement>(
          'a[href], button:not([disabled]), input, select, textarea, [tabindex]:not([tabindex="-1"])',
        ),
      );
      if (!focusable.length) return;
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        last.focus();
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        first.focus();
      }
    };
    document.addEventListener("keydown", onKeyDown);
    return () => {
      document.removeEventListener("keydown", onKeyDown);
      returnFocusRef.current?.focus();
    };
  }, [body]);

  if (!body) return null;
  const scopes = loaded?.id === body.id ? loaded.scopes : null;
  const scopeLines = scopeLinesByStandard(scopes ?? []);
  // A standard picked for a previous body may not exist here: fall back to "Tutti".
  const activeStandard =
    selectedStandard !== null && scopeLines.some((l) => l.standard === selectedStandard)
      ? selectedStandard
      : null;
  /** Standards when scopes are available, otherwise the given single-EA label, otherwise "all". */
  const scopeSummary = (singleEaLabel: string) =>
    body.standards.length
      ? body.standards.join(", ")
      : body.eaCode > 0
        ? singleEaLabel
        : "Tutti gli standard e settori";

  return (
    <div
      className="drawer-backdrop"
      onMouseDown={(event) => {
        if (event.target === event.currentTarget) onClose();
      }}
    >
      <aside
        className="drawer"
        data-organization-drawer
        role="dialog"
        aria-modal="true"
        aria-labelledby="drawer-title"
      >
        <div className="drawer-top">
          <span>SCHEDA ORGANISMO</span>
          <button
            type="button"
            aria-label="Chiudi"
            data-drawer-close
            onClick={onClose}
          >
            ×
          </button>
        </div>
        <div className="drawer-identity">
          <div className="drawer-flag"><CountryFlag country={body.country} /></div>
          <div>
            <div className="verified-label">
              <span>ⓘ</span> Accreditamento dichiarato · {body.accreditationBodyCodes.join(", ")}
            </div>
            <h2 id="drawer-title">{body.name}</h2>
            <p>
              {countryLabel(body.country)}{" "}
              <RecognitionLabels abCodes={body.accreditationBodyCodes} />{" "}
              <span>·</span>{" "}
              {scopeSummary(`EA ${body.eaCode} ${body.eaDescription}`)}
            </p>
          </div>
        </div>
        <div className="drawer-divider" />
        <div className="contact-list">
          {body.phone && (
            <ContactLink href={`tel:${body.phone}`} icon="☎" label="Telefono">
              {body.phone}
            </ContactLink>
          )}
          {body.email && (
            <ContactLink href={mailtoHref(body.email)} icon="✉" label="Email">
              {body.email}
            </ContactLink>
          )}
          {body.website && (
            <ContactLink
              href={body.website}
              icon="↗"
              label="Sito web"
              external
            >
              {body.website.replace(/^https?:\/\//, "")}
            </ContactLink>
          )}
          {body.address && (
            <div className="address-row">
              <span>⌖</span>
              <div>
                <small>Sede</small>
                {body.address}
              </div>
            </div>
          )}
          {/* Own row, so the expiry shows whether or not the body has an address. */}
          {body.expiryDate && (
            <div className="address-row">
              <span>◷</span>
              <div>
                <small>Scadenza</small>
                {formatDate(body.expiryDate)}
              </div>
            </div>
          )}
        </div>
        <section className="drawer-section">
          <div className="drawer-section-title">
            CAMPO DI APPLICAZIONE ACCREDITATO
          </div>
          {scopeLines.length > 0 && (
            <div className="standard-filter">
              <button
                onClick={() => setSelectedStandard(null)}
                className={activeStandard === null ? "active" : ""}
              >
                Tutti
              </button>
              {scopeLines.map(({ standard }) => (
                <button
                  key={standard}
                  onClick={() => setSelectedStandard(standard)}
                  className={activeStandard === standard ? "active" : ""}
                >
                  {shortStandard(standard)}
                </button>
              ))}
            </div>
          )}
          <div className="scope-highlight">
            {scopes === null ? (
              <p>Caricamento del campo di applicazione…</p>
            ) : scopes.length ? (
              (activeStandard === null
                ? scopeLines
                : scopeLines.filter((line) => line.standard === activeStandard)
              ).map(({ standard, allSectors, sectors }) => (
                <div key={standard}>
                  <strong>{standardLabel(standard)}</strong>
                  {allSectors ? (
                    <p>Tutti i settori</p>
                  ) : (
                    sectors.map((sector) => <p key={sector}>{sector}</p>)
                  )}
                </div>
              ))
            ) : (
              <>
                <strong>
                  {scopeSummary(`${iso} • EA ${body.eaCode} (${body.eaDescription})`)}
                </strong>
                <p>{body.scopeSection || "Tutti gli accreditamenti disponibili"}</p>
              </>
            )}
          </div>
        </section>
        <section className="drawer-section criteria-section">
          <div className="drawer-section-title">
            CRITERI DI COLLABORAZIONE
          </div>
          <p className="criteria-intro">
            Informazioni utili per valutare una possibile collaborazione.
          </p>
          <div className="criteria-list">
            <Criterion
              label="Scope ISO pertinente"
              ok={body.standards.length > 0}
              detail={scopeSummary(`${iso} · EA ${body.eaCode}`)}
            />
          </div>
        </section>
        {body.proofUrl && (
          <a
            className="source-link"
            href={body.proofUrl}
            target="_blank"
            rel="noreferrer"
          >
            Visualizza il certificato <span>↗</span>
          </a>
        )}
        {(body.accreditationBodyWebsite || body.sourceUrl) && (
          <a
            className="source-link"
            href={body.accreditationBodyWebsite || body.sourceUrl!}
            target="_blank"
            rel="noreferrer"
          >
            Fonte dei dati: ente di accreditamento {body.accreditationBodyCode} <span>↗</span>
          </a>
        )}
        {body.verifiedAt && (
          <p className="drawer-disclaimer">
            Ultimo controllo registrato: {formatDate(body.verifiedAt)}.
          </p>
        )}
        <p className="drawer-disclaimer">
          Le informazioni e la disponibilità dei servizi vanno confermate
          direttamente con l’organismo.
        </p>
      </aside>
    </div>
  );
}

function ContactLink({
  href,
  icon,
  label,
  children,
  external = false,
}: {
  href: string;
  icon: string;
  label: string;
  children: React.ReactNode;
  external?: boolean;
}) {
  return (
    <a
      href={href}
      target={external ? "_blank" : undefined}
      rel={external ? "noreferrer" : undefined}
    >
      <span>{icon}</span>
      <div>
        <small>{label}</small>
        {children}
      </div>
      <b>↗</b>
    </a>
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

/**
 * mailto: link for an address. Characters that mean something in a mailto URL
 * ("&", "?", "#", "%") are percent-encoded, so "cb&IB@masci.or.th" stays one address
 * instead of being cut at "&".
 */
function mailtoHref(email: string) {
  return `mailto:${email.trim().replace(/[&?#%]/g, (c) => encodeURIComponent(c))}`;
}
