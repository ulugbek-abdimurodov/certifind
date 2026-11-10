# OUA (Uruguay)

Source: OUA register of accredited management system certification bodies (ISO/IEC 17021-1),
https://www.organismouruguayodeacreditacion.org/organismos-de-certificacion-de-sistemas-de-gestion-ocs/,
plus each body's scope PDF (OUAIMP034, linked as `proof_url`). Scraper: `database/uruguay/database/uruguay/scrape_uy_oua.py`
(snapshot `raw_oua.json`, captured in-browser because direct HTTP access to the site was blocked);
converter: `database/uruguay/prepare_certifind.py`. Not verified by a person, so `verified_at` is empty.

Extraction rules:
- OUA issues one registration per scheme (OCSC quality, OCSGA environment, OCSST OHS, OCSGIA food).
  These are merged under one ISO/IEC 17021-1 row numbered with the OCSC registration; each scope row's
  note keeps its original OUA registration number. ISO 22000 has its own ISO 22003-1 row, `OCSC xxx (22000)`.
- ISO 9001/14001/45001: IAF codes marked "X" in the scope PDF tables. ISO 22000: ISO 22003-1 categories
  classified to EA with the ESYD table.
- `issue_date`/`expiry_date` are the current accreditation cycle. Phones normalised to +598.

Left out:
- SGS Uruguay Ltda (OCSGF 001): forestry only (PEFC Uruguay / UNIT 1152, IRAM 39801), national schemes.
- LSQA S.A. BIC: accreditation suspended.
- UNIT's ISO/IEC 17021-2/-3/-10 entries: competence requirements, not certification schemes.

| Retrieved | Bodies | Accreditations | Scope rows |
| --- | --- | --- | --- |
| 2026-11-10 | 3 | 4 | 10 |
