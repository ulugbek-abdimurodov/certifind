# INAB - ISO/IEC 17065

Source: https://www.inab.ie/inab-directory/certification-bodies/product-certification/

INAB directory, Certification Bodies > Product Certification, and each body's scope PDF. INAB publishes no accreditation dates on the directory, so `issue_date` is the run date. Scraper `database/ireland/17065/scrape_ie_inab_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`inab-ireland`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (30 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 29
- boilerplate / header line: 4

Reused body rows:

- 6001 NSAI: reused (same country and name)
- 6025 OMNI Assured Certification International Limited: reused (same country and name)
- 6030 Hartford Steam Boiler Ireland Ltd.: reused (same country and name)
- 6037 Amtivo (Ireland) Limited: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 25 | 25 | 154 | 20 | 134 |
