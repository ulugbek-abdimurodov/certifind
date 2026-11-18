# CYS-CYSAB (Cyprus) ISO/IEC 17065 product certification bodies

Accreditation body: Cyprus Organization for the Promotion of Quality, Cyprus Accreditation Body (CYS-CYSAB), code `CYSAB`.

## Source

- Register: https://www.gov.cy/meci-cysab/documents/diapisteymenoi-foreis/ (accredited product certification bodies).
  **Not captured.** The gov.cy page is behind an Azure WAF (HTTP 403 in `cysab_17065/scrape_17065.log`), and no
  `register.html` was saved. The body list therefore comes from the seven accreditation certificates and annexes
  only, and the register page is used as `source_url` / `proof_url` without having been opened.
- Annexes: seven PDF accreditation certificates with scope annexes, saved in `database/cyprus/cysab-cyprus-17065/cysab_17065/pdf/`.
  Certificates C 008-1 (3.pdf), ΦΠ 005-2 (6.pdf), ΦΠ 001-5 (C-001-ΦΠ001-LACON-GR.pdf), C 007-2 (C007_2.pdf),
  C 009 (C009-ΦΠ009-EN.pdf), C 006-2 (ΚΕΠ-C006-2025-En.pdf), C 004-4 (ΦΠΠ006-C004.pdf).
- Scraper: `scrape_cy_cysab_17065.py` (ran; stopped at the blocked register, no raw JSON or scope_lines.csv produced).
- Converter: `prepare_certifind_17065.py` with `annex_transcription.csv`, both next to the scraper in
  `database/cyprus/cysab-cyprus-17065/`.

## Extraction rules

- One row per annex entry in `annex_transcription.csv`, transcribed from the annex PDFs in certificate order
  (`line_no` 1, 2, 3... per certificate, in annex order). Text is verbatim, whitespace collapsed; the annex
  tables were read by eye because their multi-line cells do not survive text extraction intact.
- `scheme` only where an EA or catalogue code applies: EU Regulation/Directive lines map to their
  `EU_REGULATION` code (305/2011, 2014/33/EU, 2006/42/EC, 2014/68/EU, 2014/34/EU, DOP/IGP PDO, organic 2018/848),
  Keymark to `CEN Keymark`, welding (CYS ISO 3834) to `ISO 3834`. National Cypriot schemes and single-body schemes stay text.
- `industry` only on lines without a scheme (V70 codes).
- Certificate number as printed, with the revision marker kept: `C 008-1` (certificate header reads "C 008 -1").
- `issue_date` is the certificate's date line; for C 006-2 that is the signature date (29 June 2026), since no
  separate issue date is printed. `expiry_date` is the end of the validity period.
- `accreditation_standard` `ISO/IEC 17065`, one row per certificate. No ISO/IEC 17021-1 row (product search does not need one).

## Reused body row

- BUREAU VERITAS HELLAS SINGLE PERSON SOCIETE ANONYME (BUREAU VERITAS HELLAS S.P. S.A.): copied exactly from
  `data/esyd-greece/bodies.csv` (Greece, phone, email and address from ESYD). The certificate name
  "BUREAU VERITAS HELLAS M.A.E." is an alias of this row. Import: 1 unchanged.

## Left out

- Nothing. All 44 annex entries are kept. No body was dropped, and no entry was skipped as a national scheme.
- Two annex entries were not transcribed as lines: the boilerplate "Δεν περιλαμβάνεται η πιστοποίηση ομάδας
  επιχειρήσεων" (group certification excluded), and the page headers and footers.

## Retrieved

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-18 (from the annex PDFs; register not captured) | 7 | 7 | 44 |
