# ARMNAB (Armenia) - ISO/IEC 17065 product, process and service certification

Source: ARMNAB's register of product certification bodies, https://armnab.am/certification-bodies, and each
body's detail page (https://armnab.am/certification-bodies-n/CBnnnnnnnn), Armenian only. The register publishes no
annex files: the scope is the "Հավատարմագրման ոլորտը" (accreditation scope) text on the detail page, which is
the `proof_url` and `source_url`. Not yet verified by a person, so `verified_at` is empty.

Generated with `database/armenia/armnab-armenia-17065/scrape_am_armnab_17065.py` (built on
`../armnab_scraper.py`) and `prepare_certifind_17065.py` in the same folder; notes are in `armnab_17065_review.md`
there. The accreditation body row is added in `V77__armnab_17065_reference_data.sql`; no new schemes.

Annex types (one scope text per body, all the same layout):

- "ԿԱՆՈՆԱԿԱՐԳՎՈՂ ՈԼՈՐՏ" (regulated area): mandatory certification under Armenian government technical
  regulations (government decisions), with the procedures of government decision N 56-Ն (2014).
- "ՉԿԱՆՈՆԱԿԱՐԳՎՈՂ ՈԼՈՐՏ" (non-regulated area): voluntary certification against GOST / AST (ՀՍՏ) standards or
  Armenian laws (organic agriculture, geographical indications), with the body's own procedure.
- Within each: numbered product groups and products, HS (EAEU CN FEA) codes, then the documents and the procedure.

Extraction rules:

- One `ISO/IEC 17065` accreditation per ARMNAB certificate number (`009/S-047`). Product numbers (`/S-`) never
  match the management-system ones in `armnab-armenia` (`/M-`), so no ` (17065)` suffix. `issue_date` / `expiry_date` are the certificate's validity period.
- Only active bodies (`Գործող`) are kept: 41 terminated records (`Դադարեցված`) are left out.
- `product_scopes.csv`: one row per product, `product_text` = "group: product (HS codes)" in Armenian,
  `scheme_text` = the regulated / non-regulated heading, `normative_docs` = the documents listed after the product.
  Procedure / scheme lines, test-method lines, "and per submitted documents" notes, separators and scope-amendment
  notes are dropped. `standard_refs` lists ISO/EN/IEC refs and GOST / GOST R / AST (ՀՍՏ) / ASTM numbers.
- No line has a `scheme`: every scope cites Armenian national documents, kept as text (as in the TUNAC and
  TURKAK datasets). `industry` comes from the HS chapter of the product's codes (fallback: Armenian keywords).
- Bodies already in other datasets reuse that row: Narek (009/S-047), Certification and Quality (018/S-058) and
  the National Body of Standards and Metrology (008/S-060) from `armnab-armenia`, matched on the «quoted» Armenian
  name; ԷԿՈԳԼՈԲ (033/S-059) from `dakks-germany-17065` (`ECOGLOBE LLC`). Other names are the register's Armenian
  names. `product_text_en` is empty (Armenian-only register).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 13 | 13 | 268 (0 with a scheme) |
