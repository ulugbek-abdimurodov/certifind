# FINAS - ISO/IEC 17065

Source: https://www.finas.fi/sites/en/operators/Pages/default.aspx

FINAS operator search (SharePoint search over https://www.finas.fi/Scopes), scope PDFs naming ISO/IEC 17065. Lines are the PDF's text lines (English half of bilingual pairs), not table cells. Scraper `database/finland/17065/scrape_fi_finas_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`finas-finland`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (79 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 30
- body with no importable scope line: 7
- boilerplate / header line: 3

Reused body rows:

- S018 DNV Business Assurance Finland Oy Ab: reused (same country and name)
- S048 DEKRA Industrial Oy: reused (same country and name)
- S060 Bureau Veritas Certification Finland: reused (same country and name)
- S071 Enemi Oy: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 9 | 9 | 186 | 25 | 161 |
