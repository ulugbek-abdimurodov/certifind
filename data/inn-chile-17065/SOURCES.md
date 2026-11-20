# INN - ISO/IEC 17065

Source: https://directorio.inn.cl/

INN directory export (no annex PDFs: DOCUMENTO_ENCRYPT tokens missing); one line per accreditation = the register's accreditation area.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`inn-chile`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (Suspendido): 3
- not accredited (expired 2025-05-10 (register still says Vigente)): 1
- not accredited (expired 2026-02-04 (register still says Vigente)): 1
- not accredited (expired 2025-03-31 (register still says Vigente)): 1
- not accredited (expired 2026-01-29 (register still says Vigente)): 1

Reused body rows:

- CP 071 ICOMCER SpA: reused (same country and name)
- CP 080 TÜV Rheinland Chile S.A.: reused (same country and name)
- CP 092 Bureau Veritas Certification Chile S.A.: reused (same country and name)
- CP 093 SGS Chile Ltda.: reused (same country and name)
- CP 126 SBC - Servico Brasileiro de Certificacoes: reused (same country and name)
- ST 012 Certhia Ltda.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 48 | 48 | 80 | 0 | 80 |
