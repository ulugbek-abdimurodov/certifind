# IAS - ISO/IEC 17065

Source: https://www.iasonline.org/search-accredited-organizations-2/

IAS register, program "Product Certification Agencies" (service=13573), and each agency's certificate PDF (address, effective date, scope tables). `issue_date` is the effective date, `expiry_date` the register expiry. Scraper `database/usa/ias_certifind/17065/scrape_us_ias_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`ias-usa`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (115 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 8
- boilerplate / header line: 1

Reused body rows:

- PCA-101 Intertek Testing Services NA Inc.: reused (same country and name)
- PCA-160 Thomas Bell-Wright International Consultants: reused (same country and name)
- PCA-164 UL LLC: reused (same country and name)
- PCA-198 ACERTA CERTIFICACIÓN, S.L.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 54 | 54 | 724 | 38 | 686 |
