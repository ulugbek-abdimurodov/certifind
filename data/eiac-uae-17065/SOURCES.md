# EIAC - ISO/IEC 17065

Source: https://eiac.gov.ae/directory/

EIAC directory, main field "CB Products certification" (CB-PRD-xxx). Lines from the register scope table (category: product; applicable standard; certification type / scheme in scheme_text).

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`eiac-uae`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 2

Reused body rows:

- CB-PRD-007 Tasneef-Rina Business Assurance LLC: reused (same country and name)
- CB-PRD-009 BM Trada Ventures LLC: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 10 | 10 | 446 | 0 | 446 |
