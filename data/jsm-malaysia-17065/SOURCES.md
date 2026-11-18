# JSM - ISO/IEC 17065

Source: https://cab.jsm.gov.my/cab-directories/srchAcb

JSM CAB directory, scheme PACB0003 'Product Certification Systems (PC)', all statuses searched, and each body's accreditation schedule PDF (product certification section only). JSM gives no accreditation dates in the directory, so `issue_date` is the run date. Scraper `database/malaysia/17065/scrape_my_jsm_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`jsm-malaysia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (156 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 25
- body with no importable scope line: 6

Reused body rows:

- ACB001 SIRIM QAS International Sdn Bhd: reused from jsm-malaysia (same number ACB001)
- ACB027 PLATINUM SHAUFFMANTZ VERITAS SDN. BHD.: reused from jsm-malaysia (same number ACB027)
- ACB035 SGS (MALAYSIA) SDN. BHD.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 16 | 16 | 1231 | 5 | 1226 |
