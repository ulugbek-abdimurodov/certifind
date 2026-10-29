"use client";

import type { Body } from "../app/search-types";
import { flagFor, scopeCode } from "../app/search-data";

export function OrganizationDrawer({
  body,
  iso,
  onClose,
}: {
  body: Body | null;
  iso: string;
  onClose: () => void;
}) {
  if (!body) return null;
  const { scopes } = body;
  const scopeDescriptions = scopes.map((scope) =>
    scope.eaCode == null
      ? `${scope.isoStandard} (${scope.scopeSection})`
      : `EA ${scope.eaCode} (${scope.eaDescription})`,
  );
  /** Scope codes when available, otherwise the given single-EA label, otherwise "all". */
  const scopeSummary = (singleEaLabel: string) =>
    scopes.length
      ? scopes.map(scopeCode).join(", ")
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
        role="dialog"
        aria-modal="true"
        aria-labelledby="drawer-title"
      >
        <div className="drawer-top">
          <span>SCHEDA ORGANISMO</span>
          <button type="button" aria-label="Chiudi" onClick={onClose}>
            ×
          </button>
        </div>
        <div className="drawer-identity">
          <div className="drawer-flag">{flagFor(body.country)}</div>
          <div>
            <div className="verified-label">
              <span>✓</span> {body.accreditationBodyCode}
              {body.isIafMla ? " · IAF/MLA" : ""}
            </div>
            <h2 id="drawer-title">{body.name}</h2>
            <p>
              {body.country} <span>·</span>{" "}
              {scopeSummary(`EA ${body.eaCode} ${body.eaDescription}`)}
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
              {scopeSummary(`${iso} • EA ${body.eaCode} (${body.eaDescription})`)}
            </strong>
            {scopes.length ? (
              <p>
                — {scopeDescriptions.join(" / ")}
              </p>
            ) : (
              <p>{body.scopeSection || "Tutti gli accreditamenti disponibili"}</p>
            )}
          </div>
          <div className="contact-list">
            {body.phone && (
              <ContactLink href={`tel:${body.phone}`} icon="☎" label="Telefono">
                {body.phone}
              </ContactLink>
            )}
            {body.email && (
              <ContactLink href={`mailto:${body.email}`} icon="✉" label="Email">
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
              ok={body.isIafMla}
              detail={body.accreditationBodyCode}
            />
            <Criterion
              label="Scope ISO pertinente"
              ok
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
            Consulta la fonte dell’accreditamento <span>↗</span>
          </a>
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
