# OUA - ISO/IEC 17065

Source: https://www.organismouruguayodeacreditacion.org/organismos-de-certificacion-de-productos-ocp/

OUA page 'Organismos de Certificación de Productos (OCP)' and each body's scope PDF (OUAIMP034, text layer). Scraper `database/uruguay/17065/scrape_uy_oua_17065.py`; converter `prepare_certifind_17065.py`. Scope lines are PDF text lines (table rows may be split over several lines).

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`oua-uruguay`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (371 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 158
- boilerplate / header line: 8

Reused body rows:

- OCP UNIT Instituto Uruguayo de Normas Técnicas (UNIT): reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 4 | 4 | 734 | 9 | 725 |
