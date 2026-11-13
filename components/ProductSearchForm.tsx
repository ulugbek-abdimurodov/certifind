"use client";

import { useId, type FormEvent } from "react";
import type { ProductCriteria, ProductOptions } from "../app/search-types";

type ProductSearchFormProps = {
  criteria: ProductCriteria;
  onChange: (criteria: ProductCriteria) => void;
  options: ProductOptions;
  /** Shown above the fields while schemes and industries cannot be loaded. */
  optionsError?: string;
  loading: boolean;
  onSubmit: (event: FormEvent<HTMLFormElement>) => void;
  onShowAll: () => void;
};

/**
 * Product, process and service certification (ISO/IEC 17065): scheme or standard,
 * industry, and product. Any one of the three is enough to search.
 */
export function ProductSearchForm({
  criteria,
  onChange,
  options,
  optionsError,
  loading,
  onSubmit,
  onShowAll,
}: ProductSearchFormProps) {
  const schemeListId = useId();
  // With an industry chosen, only its schemes are suggested; any text can still be typed.
  const suggestedSchemes = options.schemes.filter(
    (scheme) =>
      !criteria.industry || scheme.industries.includes(criteria.industry),
  );
  const empty =
    !criteria.scheme.trim() && !criteria.industry && !criteria.product.trim();

  return (
    <>
    <form onSubmit={onSubmit}>
      {optionsError && (
        <div className="notice error-notice form-notice" role="status">
          <span>!</span>
          <p>{optionsError}</p>
        </div>
      )}
      <label htmlFor="product-scheme">Schema o norma</label>
      <div className="input-wrap">
        <span className="input-icon">◎</span>
        <input
          id="product-scheme"
          value={criteria.scheme}
          onChange={(event) =>
            onChange({ ...criteria, scheme: event.target.value })
          }
          list={schemeListId}
          placeholder="es. IFS Food, ISCC EU, EN 13432"
          maxLength={200}
          autoComplete="off"
        />
        <datalist id={schemeListId}>
          {suggestedSchemes.map((scheme) => (
            <option key={scheme.code} value={scheme.code} />
          ))}
        </datalist>
      </div>
      <label htmlFor="product-industry">Settore</label>
      <div className="input-wrap">
        <select
          id="product-industry"
          value={criteria.industry}
          onChange={(event) =>
            onChange({ ...criteria, industry: event.target.value })
          }
        >
          <option value="">Tutti i settori</option>
          {options.industries.map((industry) => (
            <option key={industry.code} value={industry.code}>
              {industry.name}
            </option>
          ))}
        </select>
        <span className="select-chevron">⌄</span>
      </div>
      <label htmlFor="product-text">Prodotto o attività</label>
      <div className="input-wrap">
        <input
          id="product-text"
          value={criteria.product}
          onChange={(event) =>
            onChange({ ...criteria, product: event.target.value })
          }
          placeholder="es. packaging, olive oil"
          maxLength={200}
        />
      </div>
      <p className="form-hint">
        Basta compilare un campo. Gli scopi sono nella lingua dell’ente di
        accreditamento e in inglese: per il prodotto prova anche il termine
        inglese.
      </p>
      <button className="search-button" type="submit" disabled={loading || empty}>
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
      onClick={onShowAll}
      disabled={loading}
    >
      Vedi tutti gli organismi di prodotto <span>→</span>
    </button>
    </>
  );
}
