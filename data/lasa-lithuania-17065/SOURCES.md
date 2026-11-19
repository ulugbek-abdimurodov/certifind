# LASA / NAB (Lithuania) - ISO/IEC 17065 product, process and service certification

Source: the National Accreditation Bureau (Nacionalinis akreditacijos biuras) register, http://db.nab.lt/ais/,
product certification bodies (LST EN ISO/IEC 17065): 24 accreditations, 16 active and 8 withdrawn. Each body has its
certificate and scope as one PDF in Lithuanian ("Akreditavimo pažymėjimas ir sritis") and one in English. Scraped with
`../database/lithuania/nab-lithuania-17065/scrape_lt_nab_17065.py`, converted with `prepare_certifind_17065.py` in the
same folder. Notes are in `nab_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty.
`proof_url` is the register document. The accreditation body is LASA (row from the MS import); no new schemes.

Extraction rules:

- **Only active accreditations: 16.** Skipped as withdrawn: LA.025-03, LA.03.001, LA.03.013, LA.03.015, LA.143-03-1,
  LA.165-03, LA.189-03 and LA.192-03.
  - Bodies are named by the legal entity, as in `lasa-lithuania`. UAB „Kiwa Inspecta" holds two active
    accreditations (LA.143-03-2 and -3), which are merged under `LA.143-03-2`, so there are 15 bodies.
  - The LA.0x numbers don't collide with the MS numbers. `issue_date` / `expiry_date` are the register's.
- **The Lithuanian scope (the original) is read from word positions,** because its tables have no ruled lines.
  - Header labels give the columns: Produkto / Produktų grupės pavadinimas → product; Atitikties vertinimo
    sistema / procedūra, ES direktyva, ESPVT / AVCP sistema, Produktų sritis → scheme; Norminio dokumento žymuo,
    Techninės specifikacijos, Atitinkami darnieji standartai → normative. Eil. Nr. and Srities kodas are dropped.
  - Header lines wrapped over several lines are read as one band. Column boundaries lie halfway between centred
    labels.
  - A line with upper-case product text starts a record; standards-only and lower-case lines continue it.
  - Full-width legislation lines ("Europos Parlamento ir Tarybos reglamentas (ES) Nr. 305/2011", ministerial
    orders) are carried into `scheme_text`. A record with legislation but no product is merged into the next.
  - `product_text_en` is empty, since the English PDF is a separate document that wasn't paired.
- **Schemes.**
  - EU regulations and directives win over the Lithuanian implementing orders: CPR 305/2011, PED, PPE, MID, NAWI,
    lifts. Module and annex lines inherit the directive of the rows above.
  - Private schemes: EN 15343 and ISO 3834. RecyClass, cited at one body only, stays as text.
  - Lithuanian national rules stay as text with an industry: STR 1.01.04:2015 construction products without
    harmonised specifications, the national food quality system, and the rail rolling-stock orders.
  - Every line has a scheme or an industry.
- **Left out:**
  - page headers, footers, signatures and footnotes: 172
  - certificate-page and title text before the first table header: 96
  - table headers: 58
  - site addresses and numbering fragments: 4
- **Bodies.**
  - UAB „Euromatas" reuses its `lasa-lithuania` row (same legal-entity code 300092852).
  - The other 14 are new, with the legal-entity code from the certificate in `registration_no`.
  - Phones keep the first number in `+370 …` form.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 15 | 15 | 348 (184 with a scheme) |
