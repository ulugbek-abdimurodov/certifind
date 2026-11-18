# SNAS - ISO/IEC 17065

Source: https://ais.snas.sk/web-report

SNAS register (ais.snas.sk web-report API), field 6 'CAB Certifying Products', and each certificate's published annex. Scraper `database/slovakia/17065/scrape_sk_snas_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`snas-slovakia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (97 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 29
- boilerplate / header line: 24
- not accredited (expired): 3

Reused body rows:

- P-009 Výskumný ústav zváračský: reused (same country and name)
- P-018 Technický skúšobný ústav Piešťany, a. s.: reused (same country and name)
- P-019 Technická inšpekcia, a.s.: reused (same country and name)
- P-020 TÜV SÜD Slovakia s.r.o.: reused (same country and name)
- P-032 E.I.C.Engineering inspection company s.r.o.: reused (same country and name)
- P-041 PRVÁ ZVÁRAČSKÁ, a.s.: reused (same country and name)
- P-048 LIGNOTESTING, a.s.: reused (same country and name)
- P-049 QSCert, spol. s r.o.: reused (same country and name)
- P-053 QUALIFORM SLOVAKIA s.r.o.: reused (same country and name)
- P-057 TÜV Thüringen Slovakia s.r.o.: reused (same country and name)
- P-059 Cech zváračských odborníkov: reused (same country and name)
- P-063 Certifikačný a inšpekčný orgán SR, s. r. o.: reused (same country and name)
- P-068 SMC Slovensko a. s.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 39 | 39 | 364 | 147 | 217 |
