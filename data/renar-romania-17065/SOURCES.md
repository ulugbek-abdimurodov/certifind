# RENAR - ISO/IEC 17065

Source: https://www.renar.ro/index.php/oec

RENAR register (DataTables API), category 6 = '4 Organisme de certificare produse', and each body's annex PDF. Scraper `database/romania/17065/scrape_ro_renar_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`renar-romania`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (33 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 33
- boilerplate / header line: 21

Reused body rows:

- PR 008 AEROQ SA: reused (same country and name)
- PR 015 QUALITAS SA: reused (same country and name)
- PR 027 QUALITY CERT SA: reused (same country and name)
- PR 087 RAD CERT SRL: reused (same country and name)
- PR 089 RINA SIMTEX - ORGANISMUL DE CERTIFICARE SRL: reused (same country and name)
- PR 095 SRAC CERT SRL: reused (same country and name)
- PR 096 EXPERT CERT SYSTEMS SRL: reused (same country and name)
- PR 100 CERTIND SA: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 15 | 15 | 166 | 0 | 166 |
