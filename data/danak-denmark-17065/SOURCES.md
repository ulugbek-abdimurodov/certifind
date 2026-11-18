# DANAK - ISO/IEC 17065

Source: https://registry.danak.dk/registry

DANAK registry GraphQL API, cases with standard group 15 (DS/EN ISO/IEC 17065:2012). Scraper `database/denmark/17065/scrape_dk_danak_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`danak-denmark`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (15 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (Suspended): 1
- duplicate line within the accreditation: 1

Reused body rows:

- 01-7001 Dancert A/S: reused (same country and name)
- 01-7009 Bureau Veritas Denmark A/S: reused (same country and name)
- 01-7010 DNV Business Assurance Denmark A/S: reused (same country and name)
- 01-7020 FORCE Certification A/S: reused (same country and name)
- 01-7026 FORCE Certification A/S: reused (same country and name)
- 01-7033 Bureau Veritas Denmark A/S: reused (same country and name)
- 01-7038 Intertek DIC A/S: reused (same country and name)
- 01-7043 DNV Business Assurance Denmark A/S: reused (same country and name)
- 01-7047 Bruun Inspektion A/S: reused (same country and name)
- 01-7050 FORCE Certification A/S: reused (same country and name)
- 01-7055 Bureau Veritas Denmark A/S: reused (same country and name)
- 01-7057 Baltic Control Certification A/S: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 19 | 19 | 170 | 89 | 81 |
