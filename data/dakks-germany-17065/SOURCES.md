# DAkkS (Germany) - ISO/IEC 17065 product, process and service certification

Source: DAkkS (Deutsche Akkreditierungsstelle) database of accredited bodies,
https://www.dakks.de/de/akkreditierte-stellen-suche.html, type ZE ("Zertifizierungsstelle für Produkte,
Prozesse und Dienstleistungen"), all statuses (518 records, 262 bodies). Each record's detail page
(`https://www.dakks.de/de/akkreditierte-stelle.html?id=<D-ZE-...>`), certificate and annex PDFs.

Scraped with `../database/germany/dakks_17065_scraper.py` into `../database/germany/dakks_ZE/`
(`accreditations.csv`, `bodies.csv`, `scope_lines.csv`), converted with
`../database/germany/prepare_certifind_17065.py` (review: `../database/germany/dakks_17065_review.md`).

## Rules

- One accreditation row per body (`ISO/IEC 17065`). A body's several ZE accreditations
  (`-01`, `-02` ...) are merged into the first (23 bodies); certificate number is the first
  `D-ZE-NNNNN-XX-00`. Withdrawn records (Zurückgezogen) are left out; lines of a fully suspended
  record are SUSPENDED. Issue date = earliest status date. DAkkS gives no expiry.
- Body rows: 50 bodies reuse the DAkkS management-system row (`data/dakks-germany`, same body
  number) exactly. Others are new, country from the address. DAkkS publishes no contacts; phone,
  email and website come from `contacts.csv` where known, otherwise empty (229 bodies without phone).
- Lines in annex order (document, page, row). Section headings ("Abschnitt") become `scheme_text`
  of the lines under them, or a line of their own when a section has no rows. Descriptive columns
  -> `product_text`, standard / document reference columns -> `normative_docs`. Annexes are
  German (48 English-only); `product_text_en` is not filled.
- Schemes: EU directives and regulations as in the ACCREDIA dataset; construction products
  (AVCP decisions `1995/467/EG`, EAD, ETAG, "Leistungsbeständigkeit") -> CPR 305/2011. New in
  `V72__dakks_17065_schemes.sql`: FSC, MSC, Common Criteria, IEC 62443, IEC 61508, ISO 26262,
  EN 50126/50128/50129, IEC 61400-22 / IECRE, IEC 61215 / IEC 61730, CEN Keymark.
- German national schemes kept as text with a sector but no scheme: QS, KAT, QM Milch, Ü-Zeichen /
  allgemeine bauaufsichtliche Zulassung (DIBt), VDE-AR-N / FGW TR grid connection, BSI TR, AZAV,
  Präqualifikation, Geprüfte Qualität Bayern. RSPO (one body) also has no scheme.
- 7 annexes headed "nach DIN EN ISO/IEC 17025" whose text certifies to ISO/IEC 17065 are kept
  (scraper fix). 3 bodies whose annex could not be parsed get one line each from the register's
  scope summary (D-ZE-11220, D-ZE-16034, D-ZE-18444).

## Left out

| Reason | Lines |
| --- | --- |
| Boilerplate (annex text, site legends, footnotes) | 583 |
| Empty or column-only rows (system / site codes) | 374 |
| Duplicate of an earlier line of the same body | 358 |
| Area list on page 1, repeated by the sections | 258 |

Bodies left out: 4 with all accreditations withdrawn (D-ZE-12142 QIMA, D-ZE-14160 ISEGA,
D-ZE-18688 Polymerbitumen, D-ZE-21586 FFCert).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-16 | 258 | 258 | 10,464 (3,681 with a scheme) |
