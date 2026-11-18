# TAF - ISO/IEC 17065

Source: https://www.taftw.org.tw/en/find-facility/scheme/pva/

TAF directory scheme 'pva' (ISO/IEC 17065 Product Certification Body), list JSON endpoint `cba-list-process.jsp?accId=CBA_PC_ID`, and each body's scope page (viewApplyItems, embedded item JSON). Scraper `database/taiwan/17065/scrape_tw_taf_17065.py` (then `--items`); converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`taf-taiwan`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (79 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 4

Reused body rows:

- PC002 Taiwan Testing and Certification Center: reused (same country and name)
- PC005 Taiwan Electric Research & Testing Center: reused (same country and name)
- PC011 Metal Industries Research & Development Centre: reused (same country and name)
- PC014 Universal Certification Service Co., LTD.: reused (same country and name)
- PC021 TÜV Rheinland Taiwan Ltd.: reused (same country and name)
- PC037 SGS Taiwan Limited: reused (same country and name)
- PC038 Japan Quality Assurance Organization: reused (same country and name)
- PC042 Food Industry Research and Development Institute: reused (same country and name)
- PC070 Universal Certification Service Co., LTD.: reused (same country and name)
- PC087 Food Industry Research and Development Institute: reused (same country and name)
- PC094 TUV NORD Taiwan Co., Ltd.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 70 | 70 | 1480 | 42 | 1438 |
