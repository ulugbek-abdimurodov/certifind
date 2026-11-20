# A2LA - ISO/IEC 17065

Source: https://customer.a2la.org/index.cfm?event=directory.index

A2LA directory, program 87 "ISO/IEC 17065:2012 Product Certification Bodies" (all commercial statuses), each lab's detail page and its "Accreditation Scope & Certificate" PDF. `issue_date` is the certificate's "Presented this ... day of" date, `expiry_date` the directory expiration date. Scraper `database/usa/a2la-usa-17065/scrape_us_a2la_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`none`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (380 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 47

Reused body rows:

- 1350.02 Intertek Testing Services NA Inc.: reused (same country and name)
- 3212.02 SGS North America Inc.: reused (same country and name)
- 3212.03 SGS North America Inc.: reused (same country and name)
- 3212.07 SGS North America Inc.: reused (same country and name)
- 3331.07 TUV Rheinland of North America, Inc.: reused (same country and name)
- 5530.01 ICC Evaluation Service, LLC: reused (same country and name)
- 5530.02 ICC Evaluation Service, LLC: reused (same country and name)
- 5530.03 ICC Evaluation Service, LLC: reused (same country and name)
- 6811.01 TÜV SÜD America Inc.: reused (same country and name)
- 6811.02 TÜV SÜD America Inc.: reused (same country and name)
- 7201.01 TÜRK STANDARDLARI ENSTİTÜSÜ: reused (same country and name)
- 7805.01 LGAI TECHNOLOGICAL CENTER, S.A. (APPLUS+): reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 51 | 51 | 1026 | 52 | 974 |
