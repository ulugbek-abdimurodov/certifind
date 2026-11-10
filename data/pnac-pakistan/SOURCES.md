# PNAC (Pakistan)

Source: the scope-of-accreditation documents ("Accreditation Document", form F-06/04) of the
Pakistan National Accreditation Council (PNAC), https://www.pnac.gov.pk, for the management
system certification bodies accredited to ISO/IEC 17021-1 (CB 001 … CB 014; 12 documents, text
PDFs in English, stored in `database/pakistan/`). Converted with
`database/pakistan/prepare_certifind.py`; the parser's log is `database/pakistan/pnac_review.md`.
Not yet verified by a person, so `verified_at` is empty. The download URL of each PDF was not
recorded, so `source_url` and `proof_url` are the PNAC home page.

Extraction rules:

- One document is one PNAC accreditation (`CB 001` …), AB code `PNAC`. Body name and address
  from "Awarded to"; issue date = "first time granted on", expiry = "valid until". All bodies
  are in Pakistan. The documents carry no phone, e-mail or website; these are left empty.
  CB 002 is recorded as "Bureau Veritas Pakistan (Pvt) Limited" (printed in capitals, with the
  trade name "Bureau Veritas Certification"); CB 005's "M/S" prefix is dropped.
- ISO 22000 gets its own accreditation row, ISO 22003-1 (`CB 0xx (22000)`). Everything else is
  under the ISO/IEC 17021-1 row, which every body keeps.
- ISO 9001 / 14001 / 45001 tables list IAF codes, taken as EA codes. CB 001 ISO 14001 EA 17 is
  "Limited to fabricated metal products" (noted in the scope note).
- ISO 22000 tables list ISO 22003-1 sub-categories (all in category C: C0, CI, CII, CIII, C-IV),
  classified to EA 3 with the ESYD table. ISO 13485 (CB 003) lists IAF MD 9 main technical areas
  (non-active devices, sterilization), classified to EA with the ESYD table.
- No struck-through (withdrawn) text in any document.
- Left out: the national GDPMD scheme (Good Distribution Practice for Medical Devices, Drug
  Regulatory Authority of Pakistan, Medical Devices Rules 2015) on CB 005's scope. No body was
  left out. CB 004 and CB 011 are not in the scrape (presumably withdrawn or not published).

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-06 | 12 | 17 | 33 |
