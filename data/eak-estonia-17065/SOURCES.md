# EAK - ISO/IEC 17065

Source: https://eak.ee/index_eng.php?pageId=32

EAK register list 'Product, process and service certification bodies' (pageId 32) and each body's annex PDF (tables extracted with pdfplumber). Scraper `database/estonia/17065/scrape_ee_eak_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`eak-estonia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (24 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- body with no importable scope line: 5
- boilerplate / header line: 2
- duplicate line within the accreditation: 2

Reused body rows:

- PC002 Metrosert Ltd.: reused (same country and name)
- PC005 KIWA Estonia OÜ: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 13 | 13 | 164 | 3 | 161 |
