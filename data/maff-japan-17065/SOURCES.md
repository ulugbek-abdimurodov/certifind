# MAFF - ISO/IEC 17065

Source: https://www.maff.go.jp/e/policies/standard/

MAFF lists of registered certifying bodies: JAS (excluding organic) system-27.pdf, organic JAS domestic CBs organic_JAS-114.pdf, organic JAS overseas CBs organic_JAS-115.pdf. No numbers or dates are published: certificate = <list>-<row #>, issue_date = conversion date.

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

- body with no importable scope line: 1

Reused body rows:

- ORG-12 Japan Organic & Natural Foods Association: reused (same country and name)
- ORGOV-1 ACO Certification Ltd.: reused (same country and name)
- ORGOV-10 OneCert International Pvt. Ltd.: reused (same country and name)
- ORGOV-11 CERTIMEX, CERTIFICADORA MEXICANA DE PRODUCTOS Y PROCESOS ECOLÓGICOS S.C.: reused (same country and name)
- ORGOV-12 SRS Certification GmbH: reused (same country and name)
- ORGOV-14 MAYACERT S.A.: reused (same country and name)
- ORGOV-15 Beijing Continental Hengtong Certification Co. Ltd.: reused (same country and name)
- ORGOV-18 ECOGLOBE LLC: reused (same country and name)
- ORGOV-2 Kiwa BCS Öko-Garantie GmbH: reused (same country and name)
- ORGOV-21 CSQA Certificazioni S.r.l.: reused (same country and name)
- ORGOV-22 INDOCERT: reused (same country and name)
- ORGOV-4 Ceres CERtification of Environmental Standards GmbH: reused (same country and name)
- ORGOV-5 Istituto per la Certificazione Etica e Ambientale (ICEA): reused (same country and name)
- ORGOV-6 CCPB S.r.l.: reused (same country and name)
- ORGOV-7 BioGro New Zealand Ltd: reused (same country and name)
- ORGOV-8 BIOAGRIcert S.r.l.: reused (same country and name)
- ORGOV-9 Suolo e Salute S.r.l.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 91 | 91 | 170 | 0 | 170 |
