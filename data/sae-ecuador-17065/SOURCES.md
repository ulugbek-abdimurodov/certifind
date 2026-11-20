# SAE - ISO/IEC 17065

Source: https://sistema.acreditacion.gob.ec/

SAE register, area CERTIFICACIÓN, activity 6 (products, ISO/IEC 17065). Lines are the register scope rows (levels 4-6 joined with ' - '); the accreditation resolution PDFs carry no scope (they refer to the register) and are only kept as proof_url.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`sae-ecuador`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 86

Reused body rows:

- SAE CP 07-001 CONTROL UNION SERVICES S.A.C.: reused (same country and name)
- SAE CP 14-001 Bureau Veritas Ecuador S.A.: reused (same country and name)
- SAE CP 15-001 LENOR ECUADOR Cía. Ltda.: reused (same country and name)
- SAE CP 21-001 ASIAMBUSINESS DEL ECUADOR S.A: reused (same country and name)
- SAE CP 25-001 SERVICIO DE CERTIFICACIÓN CAAE, S.L. (Unipersonal): reused (same country and name)
- SAE CP 25-003 Fundacion Natura Certificacion (NaturaCert): reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 19 | 19 | 248 | 9 | 239 |
