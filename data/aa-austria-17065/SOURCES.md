# AA (Austria) - ISO/IEC 17065

Source: Akkreditierung Austria register, https://akkreditierung-austria.gv.at/ (public JSON API
`/api/accreditationCabRevisions`, program 929 "Produktzertifizierungsstelle", EN ISO/IEC 17065:2012). Scraped with
`database/austria/17065/scrape_at_aa_17065.py` (run in-browser on 2026-11-17: the register host is not reachable from
the workspace), converted with `database/austria/17065/prepare_certifind_17065.py`; every skipped row is listed in
`database/austria/17065/aa_17065_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url`
and `proof_url` are the register home page.

Rules:

- One AA identification number (e.g. 0901) is one accreditation under ISO/IEC 17065. When the same number also
  holds the 17021-1 accreditation (`aa-austria`), the body row is copied from that dataset and the certificate
  number is `<id> (17065)` (6 bodies). `issue_date` is the initial accreditation date; no `expiry_date`
  (Austrian accreditations are open-ended).
- Name, address and contacts from the register's business address and public contacts.
- `scopes.csv` is header only (no EA codes for 17065).
- One register row per certified standard. Row types N (accredited), C (construction products), S (national
  schemes) and B are lines: `normative_docs` = docNr, `product_text` = "field/ range" or the document title
  (German), `scheme_text` = "certification scheme(s)" attribute. Types E and D (applicable documents: scheme
  rules, EA/IAF documents) are not imported (109 rows); 4 duplicate rows dropped.
- `scheme`: EU regulations (CPR 305/2011, TSI 2016/797, lifts, radio, ATEX, EMC, PPE, cableways, organic, GI)
  and catalogue schemes (GLOBALG.A.P., IFS, BRCGS, PEFC, ISO 3834, EN 15085-2, IEC 62443, EN 50126/8/9, ...).
- Austrian national schemes have no catalogue scheme: their name goes to `scheme_text` and the line gets a
  sector (ÖVE Prüfzeichen -> electrical, ÖVGW Qualitätszeichen -> energy, AMA Gütesiegel / Ohne Gentechnik /
  Lebensmittelbuch -> food, Tierschutz geprüft -> agriculture; ÖNORM mark by product). Other scheme-less lines
  get a sector from the product text. No migration needed.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 51 | 51 | 2,582 (1,116 with a scheme) |
