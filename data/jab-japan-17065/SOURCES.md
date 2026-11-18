# JAB - ISO/IEC 17065

Source: https://www.jab.or.jp/en/certification_institutions

JAB Strapi API `/cms/api/certifications`, certificate numbers P + digit (product certification; PTP = proficiency testing providers excluded). Scraper `database/japan/jab-japan-17065/scrape_jp_jab_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`jab-japan`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (5 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- none

Reused body rows:

- P0020 Japan Power Engineering and Inspection Corporation Management System & Product Certification Center: reused (same country and name)
- P0060 Japan Management Association JMA QA Registration Center: reused (same country and name)
- P0070 NIPPON KAIJI KYOKAI: reused (same country and name)
- P0100 Japan Gas Appliances Inspection Association: reused (same country and name)
- P0110 SGS Japan Inc.: reused (same country and name)
- P0150 Bureau Veritas Japan Co., Ltd. Certification Division: reused (same country and name)
- P0240 NIPPON KAIJI KENTEI QUALITY ASSURANCE Ltd.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 21 | 21 | 47 | 5 | 42 |
