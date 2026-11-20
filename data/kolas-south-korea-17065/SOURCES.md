# KOLAS - ISO/IEC 17065

Source: https://www.knab.go.kr/usr/inf/srh/InfoProductInsttSearchList.do

Register knab.go.kr, product certification bodies (제품인증기관, code 07). Lines from the English scope annex of each accreditation certificate (category rows; standard column in normative_docs; scheme heading in scheme_text; ISO/IEC 17067 scheme type dropped). English names and addresses read from page 1 of the English certificate.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`none`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 1

Reused body rows:

- KPC004 Korea Gas Safety Corporation: reused (same country and name)
- KPC006 Korea Electrotechnology Research Institute: reused (same country and name)
- KPC032 Korean Register of Shipping: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 25 | 25 | 847 | 14 | 833 |
