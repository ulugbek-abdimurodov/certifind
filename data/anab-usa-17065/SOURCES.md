# ANAB - ISO/IEC 17065

Source: https://anabpd.ansi.org/Accreditation/product-certification/AllDirectoryListing?prgID=1&statusID=4

ANSI/ANAB product certification directory (anabpd.ansi.org, Product Certification Accreditation Program, accredited list) and each organization's detail page (address, letter code, website, accreditation certificate, accredited scopes). The directory publishes no accreditation dates, so `issue_date` is the run date. Collected in a browser (Cloudflare check) with the collector in `database/usa/anab-usa_certifind/17065/scrape_us_anab_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`anab-usa`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (412 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- none

Reused body rows:

- 0198 UL LLC: reused (same country and name)
- 0204 Intertek Testing Services NA Inc.: reused (same country and name)
- 0526 TÜV SÜD America Inc.: reused (same country and name)
- 0828 SGS North America Inc.: reused (same country and name)
- 0835 AIB International Certification Services, Inc: reused (same country and name)
- 0842 Liftinstituut b.v.: reused (same country and name)
- 0848 DNV Business Assurance USA Inc.: reused (same country and name)
- 0894 EAGLE Food Registrations Inc.: reused (same country and name)
- 0956 Bureau Veritas Consumer Products Services, Inc.: reused (same country and name)
- 1000 ICC Evaluation Service, LLC: reused (same country and name)
- 1119 DQS Inc.: reused (same country and name)
- 1125 Fundacion Natura Certificacion (NaturaCert): reused (same country and name)
- 1127 CCOF Certification Services (CCOF CS), LLC: reused (same country and name)
- 1153 Kiwa Nederland B.V.: reused (same country and name)
- 1160 Global Standards S.C.: reused (same country and name)
- 1206 TÜV NORD CERT GmbH: reused (same country and name)
- 8915 Quality Assurance International: reused (same country and name)
- 9120 CONTROL UNION SERVICES S.A.C.: reused (same country and name)
- 9138 Control Union Certifications B.V.: reused (same country and name)
- 9145 DNV Business Assurance Finland Oy Ab: reused (same country and name)
- 9207 SBC - Servico Brasileiro de Certificacoes: reused (same country and name)
- 9224 Beijing Cotecna Kaixin Certification Co., Ltd: reused (same country and name)
- 9228 GCL International Ltd: reused (same country and name)
- 9230 Baltic Control Certification A/S: reused (same country and name)
- 9232 CEPREI Certification Body: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 113 | 113 | 2357 | 813 | 1544 |
