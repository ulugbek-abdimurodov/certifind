# Sources — EAS (Ethiopian Accreditation Service)

- Register: https://eas-eth.org/certification-bodies/
- Certificates/scopes (scanned PDFs, OCR text layer): https://eas-eth.org/wp-content/uploads/2026/02/
  `QMS-Scanned-Certificate.pdf`, `EMS-Scanned-Certificate.pdf`, `OHSMS-Scanned-Certificate.pdf`, `Fsms-scanned-certificate.pdf`
- Scraper: `../database/ethiopia/scrape_et_eas.py`; converter: `../database/ethiopia/prepare_certifind.py`.

## Extraction rules
- ISO 9001/14001/45001: IAF codes from the certificates. EMS0001 and OHSMS0001 are merged into the
  ISO/IEC 17021-1 row QMS0003 (one accreditation per body/AB/standard); original numbers are in `scope_note`.
- ISO 22000 (FSMS0001): ISO 22003-1 row `FSMS0001 (22000)`; categories B, C, I classified to EA with the ESYD table.

## Left out
- EOMS0001 — ISO 21001 (not in the standards table).
- CPr0001 (ECAE), CPr0002 (Bless-Agri-Food-Laboratory Services PLC) — ISO/IEC 17065 product certification.

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-09 | 1 | 2 | 4 |
