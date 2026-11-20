# ONAC - ISO/IEC 17065

Source: https://onac.org.co/directorio-de-acreditados/

Register listing: scheme "Organismos de Certificación de Producto (CPR)" (browser export onac_17065_list.tsv). Lines: one per annex table row (category -> product_text, documento normativo -> normative_docs); the "Esquema de Certificación" column (own procedure + ISO/IEC 17067 type) is read only to detect private schemes. Industry from the NACE division.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`onac-colombia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 23

Reused body rows:

- 09-CPR-002 INSTITUTO COLOMBIANO DE NORMAS TÉCNICAS Y CERTIFICACIÓN - ICONTEC: reused (same country and name)
- 09-CPR-005 KIWA CQR SAS Sigla: KIWA CQR: reused (same country and name)
- 09-CPR-008 BVQI COLOMBIA LTDA.: reused (same country and name)
- 10-CPR-009 SGS COLOMBIA S.A.S. – SGS: reused (same country and name)
- 11-CPR-002 INTERTEK COLOMBIA S.A.: reused (same country and name)
- 15-CPR-002 INTERNATIONAL TESTING INSPECTION & CERTIFICATION COLOMBIA S A S Sigla: ITICCOL S.A.S.: reused (same country and name)
- 15-CPR-004 NYCE COLOMBIA S.A.S: reused (same country and name)
- 15-CPR-005 CONTROL UNION SERVICES S.A.C.: reused (same country and name)
- 16-CPR-001 GLOBAL COLOMBIA CERTIFICACIÓN S.A.S: reused (same country and name)
- 17-CPR-002 SERVIMETERS S.A.S: reused (same country and name)
- 17-CPR-005 ASOCIACIÓN DE NORMALIZACIÓN Y CERTIFICACIÓN, S.A. DE C.V.: reused (same country and name)
- 18-CPR-002 CELAC - CENTRO LATINOAMERICANO DE CERTIFICACION S.A.S. SIGLA: CELAC S.A.S: reused (same country and name)
- 22-CPR-010 CONSEJO COLOMBIANO DE SEGURIDAD: reused (same country and name)
- 22-CPR-017 ASIAMBUSINESS DEL ECUADOR S.A: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 48 | 48 | 5777 | 42 | 5735 |
