# NAH - ISO/IEC 17065

Source: https://nah.gov.hu/hu/kategoriak/termektanusitas--product-certification/

NAH register category Terméktanúsítás / Product certification (API `/admin/api/content/hu/kategoriak/termektanusitas--product-certification/`), each organisation's scope text. Scraper `database/hungary/17065/scrape_hu_nah_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`nah-hungary`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (68 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (WITHDRAWN): 2

Reused body rows:

- none

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 25 | 25 | 235 | 54 | 181 |
