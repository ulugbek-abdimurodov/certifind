# GAC - ISO/IEC 17065

Source: https://gac.org.sa/accredited-bodies/

GAC register https://gac.org.sa/accredited-bodies/ (scopes 8 Product Certification APC, 5 Halal Product Certification HPC). Lines from the scope PDFs (item rows with their standards; GCC technical regulation in scheme_text; halal rows -> scheme Halal, suspended rows SUSPENDED, withdrawn rows dropped). Only register status Accredited.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`gac-saudi-arabia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 1185
- boilerplate / header line: 175
- body with no importable scope line: 4

Reused body rows:

- APC 0002 SGS Gulf Limited: reused (same country and name)
- APC 0020 UL International Demko A/S: reused (same country and name)
- APC 0041 Intertek Testing Services Ltd Shanghai: reused (same country and name)
- APC 0046 SIRIM QAS International Sdn Bhd: reused (same country and name)
- APC 0051 TUV Rheinland Middle East FZE: reused (same country and name)
- APC 0058 SAUDI INSPECTION & TESTING CO. (SAITCO: reused (same country and name)
- APC 0060 TUV Rheinland Middle East FZE: reused (same country and name)
- APC 0062 Nemko Korea Co., Ltd: reused (same country and name)
- APC 0065 TUV Rheinland Arabia LLC: reused (same country and name)
- APC 0071 SGS South Africa (Pty) Ltd: reused (same country and name)
- APC 0072 TUV AUSTRIA (Shanghai) CO., LTD.: reused (same country and name)
- APC 0080 IPS Certification Services: reused (same country and name)
- APC 0093 SGS Société Générale de Surveillance SA: reused (same country and name)
- APC 0094 SGS Española de Control SA: reused (same country and name)
- APC 0095 SGS North America Inc.: reused (same country and name)
- APC 0098 IMQ GULF FZCO: reused (same country and name)
- APC 0113 DEKRA Testing and Certification (Shanghai) Ltd: reused (same country and name)
- APC 0116 Bureau Veritas (India) Pvt. Ltd.: reused (same country and name)
- APC 0122 Bay Area Compliance Laboratories Corp.(Shenzhen): reused (same country and name)
- APC 0137 SUNCHINE QUALITY CONTROL TECHNOLOGY SERVICE CO., LTD.: reused (same country and name)
- APC 0147 (Raqabah For Inspection, Testing and Certifications (RITC: reused (same country and name)
- HPC 0068 JUHF Certification Pvt. Ltd.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 197 | 197 | 42697 | 654 | 42043 |
