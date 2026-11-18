# NAAU - ISO/IEC 17065

Source: https://naau.org.ua/3-reiestr-akreditovanikh-oov

NAAU register page, row 'Органи з сертифікації продукції, процесів та послуг (ДСТУ EN ISO/IEC 17065)': Ukrainian XLSX (17065_18_11_2026.xlsx) and English DOC. Scope = the register's scope summary column. Scraper `database/ukraine/17065/scrape_ua_naau_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`naau-ukraine`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (95 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (expired): 31
- not accredited (suspended): 25
- not accredited (cancelled): 20

Reused body rows:

- none

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 121 | 121 | 558 | 0 | 558 |
