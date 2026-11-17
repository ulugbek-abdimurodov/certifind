# EGAC (Egypt) - ISO/IEC 17065 product, process and service certification

Source: Egyptian Accreditation Council register, https://egac.gov.eg/en/ (entity details, accreditation
"Product Certification - <ref>"), and each body's Schedule of Accreditation (annex PDF). Scraped with
`../database/egypt/egac-egypt-17065/scrape_eg_egac_17065.py`, converted with `prepare_certifind_17065.py` in the same
folder; notes are in `egac_17065_review.md` there. Not yet verified by a person for reused rows (`verified_at` empty);
new rows carry the conversion date. The EGAC accreditation body row already exists (MS import); no migration.

Extraction rules:

- The register's scope tree is EGAC's whole product catalogue (the same 310 nodes for every body), so it is not used.
  Lines come from the annex tables, transcribed into `annex_transcription.csv` (8 of 14 active annexes are scans).
- One `ISO/IEC 17065` accreditation per register reference (trailing dot of `062402.` removed). None collides with
  `egac-egypt`, so no ` (17065)` suffix. Dates are the register's accreditation / expiry dates.
- `product_scopes.csv`: one row per numbered annex row (welding: one row per sub-scheme). `product_text` = product
  column, `scheme_text` = certification scheme column, `normative_docs` = standards column. Scheme types
  (ISO/IEC 17067) are left out. `scopes.csv` is header only.
- Schemes: EU Organic Regulation (EU) 2018/848 (COAE, EGYCert), GLOBALG.A.P. IFA (Infinity), ISO 3834 and EN 15085-2
  (Research-training center), Gas Appliances Regulation (EU) 2016/426 (GOEIC gas cookers).
- Text with an industry, no scheme: SASO / GSO technical regulations (Saudi / Gulf national), Egyptian ES standards,
  in-house schemes, Proudly Made in Egypt (national); Demeter, Economy of Love, ISO 22716 cosmetics GMP, OIML legal
  metrology (one body each, not in the catalogue).
- Not imported: 6 bodies not "Accredited" (4 withdrawn: 062302, 062307, 062305, 062203; 2 expired: 062201, 062102).
- Bodies reused from `egac-egypt`: Bureau Veritas Egypt, INFINITY CERT INTERNATIONAL ICI, IEMA STANDARDS LTD.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 14 | 14 | 94 (6 with a scheme) |
