# CAI - ISO/IEC 17065

Source: https://www.cai.cz/?page_id=4499&kategorie_subjektu=certifikacni-organy-certifikujici-produkty

CAI register category 'Certifikační orgány certifikující produkty' and each certificate's English annex PDF (tables read with pdfplumber). Scraper `database/czechia/17065/scrape_cz_cai_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`cai-czechia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (331 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 198
- boilerplate / header line: 6

Reused body rows:

- 3012 QUALIFORM, a.s.: reused (same country and name)
- 3013 Výzkumný ústav pozemních staveb – Certifikační společnost, s.r.o.: reused (same country and name)
- 3015 Technický a zkušební ústav stavební Praha, s.p.: reused (same country and name)
- 3018 Elektrotechnický zkušební ústav, s.p.: reused (same country and name)
- 3020 Institut pro testování a certifikaci, a.s.: reused (same country and name)
- 3040 Strojírenský zkušební ústav, s.p.: reused (same country and name)
- 3044 Textilní zkušební ústav, s.p.: reused (same country and name)
- 3048 Institut pro testování a certifikaci, a.s.: reused (same country and name)
- 3084 TÜV SÜD Czech s.r.o.: reused (same country and name)
- 3112 Český metrologický institut: reused (same country and name)
- 3121 SILMOS-Q s.r.o.: reused (same country and name)
- 3136 Český metrologický institut: reused (same country and name)
- 3148 DOM – ZO 13, s.r.o.: reused (same country and name)
- 3149 Výzkumný Ústav Železniční, a.s.: reused (same country and name)
- 3152 Česká společnost pro jakost, z.s.: reused (same country and name)
- 3157 BUREAU VERITAS CERTIFICATION CZ, s.r.o.: reused (same country and name)
- 3169 TESYDO, s.r.o.: reused (same country and name)
- 3170 TÜV NORD Czech, s.r.o.: reused (same country and name)
- 3190 LL-C (Certification) Czech Republic a. s.: reused (same country and name)
- 3203 3EC International, s.r.o.: reused (same country and name)
- 3239 TAYLLORCOX s.r.o.: reused (same country and name)
- 3255 United Registrar of Systems Czech, s.r.o.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 58 | 58 | 1598 | 388 | 1210 |
