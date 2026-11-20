# ECA - ISO/IEC 17065

Source: https://eca.or.cr/organismos-de-certificacion-de-productos/

Scope lines are a hand transcription of the 12 annex PDFs (annex_transcription.csv, make_annex_transcription.py): one line per product entry, normative documents of the entry in normative_docs; internal procedures and the ISO/IEC 17067 scheme type column left out. Accreditation has no expiry (ECA: indefinite, subject to surveillance).

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`eca-costa-rica`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- none

Reused body rows:

- OCP-002 Asociación Instituto de Normas Técnicas de Costa Rica (INTECO): reused (same country and name)
- OCP-008 Eco-LÓGICA: reused (same country and name)
- OCP-011 ASOCIACIÓN DE NORMALIZACIÓN Y CERTIFICACIÓN, S.A. DE C.V.: reused (same country and name)
- OCP-012 UL de México, S.A. de C.V.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 12 | 12 | 36 | 2 | 34 |
