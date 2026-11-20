# EMA - ISO/IEC 17065

Source: https://catalogo.consultaema.mx:75/busqueda-organismos-certificacion

EMA register rows (no annex PDFs); one line per EMA scope code.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`ema-mexico`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (112 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- none

Reused body rows:

- 01/10 ASOCIACIÓN DE NORMALIZACIÓN Y CERTIFICACIÓN, S.A. DE C.V.: reused (same country and name)
- 02/10 Normalización y Certificación NYCE, S.C.: reused (same country and name)
- 04/11 Instituto Mexicano de Normalización y Certificación, A.C.: reused (same country and name)
- 06/10 Sociedad Mexicana de Normalización y Certificación, S.C.: reused from ema-mexico (same number 06/10)
- 06/22 Sociedad Mexicana de Normalización y Certificación, S.C.: reused (same country and name)
- 08/18 SGS de México, S.A. de C.V.: reused (same country and name)
- 09/10 Organismo Nacional de Normalización y Certificación de la Construcción y Edificación, S. C.: reused from ema-mexico (same number 09/10)
- 107/16 Instituto Dominicano para la Calidad (INDOCAL): reused (same country and name)
- 148/18 Nemko North America Inc.: reused (same country and name)
- 153/19 Global Standards S.C.: reused (same country and name)
- 153/25 Global Standards S.C.: reused (same country and name)
- 18/10 Certificación Mexicana, S.C.: reused from ema-mexico (same number 18/10)
- 188/21 CSA Group Testing & Certification Inc.: reused (same country and name)
- 195/21 CEMA INTERNATIONAL COMPLIANCE SERVICES, SA DE CV: reused (same country and name)
- 195/23 CEMA INTERNATIONAL COMPLIANCE SERVICES, SA DE CV: reused (same country and name)
- 20/12 Factual Services, S.C.: reused (same country and name)
- 201/22 CERTIFICATION GLOBAL SERVICES DIADECOR S DE RL DE CV: reused (same country and name)
- 212/25 EDUCERT, EDUCACIÓN CERTIFICADA SC: reused (same country and name)
- 22/12 TüV Rheinland de México, S.A. de C.V.: reused (same country and name)
- 222/24 GENERAL CERTIFICATIONS HOUSE, S. DE R.L. DE C.V.: reused (same country and name)
- 25/09 AENOR-MEXICO, S.A. DE C.V.: reused from ema-mexico (same number 25/09)
- 47/19 Auditores Asociados de México, S.C.: reused (same country and name)
- 49/21 ACCM América, S.de R.L. de C.V.: reused (same country and name)
- 57/11 UL de México, S.A. de C.V.: reused (same country and name)
- 81/ 23 COMPECER, S.C.: reused (same country and name)
- 97/13 IAPMO Research and Testing, Inc.: reused (same country and name)
- IFT-241/24 LENOR OEC S.A DE C.V.: reused (same country and name)
- PROD-163/26 Certificadora Mexicana Internacional S.A.P.I. de C.V.: reused (same country and name)
- PROD-174/26 TESTING CONFORMITY CERTIFICATION MEXICO, S.A. DE C.V.: reused (same country and name)
- PROD-241/24_ LENOR OEC S.A DE C.V.: reused (same country and name)
- PROD-90/26 QAC, Certificación, S.A. de C.V.: reused (same country and name)
- REA.EA.01.2015.-01/15 Normalización y Certificación NYCE, S.C.: reused (same country and name)
- REA.EA.01.2015.-02/19 Global Certification Bureau, S.A.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 106 | 106 | 128 | 3 | 125 |
