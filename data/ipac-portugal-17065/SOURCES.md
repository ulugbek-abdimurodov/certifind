# IPAC - ISO/IEC 17065

Source: https://www.ipac.pt/pesquisa/acredita.asp

IPAC register, scheme filter 17065 (Products, Processes and Services Certification Bodies), profile pages `ficha_ocp.asp`. Scraper `database/portugal/17065/scrape_pt_ipac_17065.py` (runs ipac_scraper.py --scheme 17065); converter `prepare_certifind_17065.py`. 412 sector heading rows (no criteria) are not imported.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`ipac-portugal`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (192 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 590

Reused body rows:

- C0001 SGS ICS - Serviços Internacionais de Certificação, Lda.: reused (same country and name)
- C0002 EIC - Empresa Internacional de Certificação, S.A.: reused (same country and name)
- C0004 CERTIF - Associação para a Certificação: reused (same country and name)
- C0005 Kiwa Sativa – Unipessoal, Lda.: reused (same country and name)
- C0009 APCER - Associação Portuguesa de Certificação: reused (same country and name)
- C0011 Bureau Veritas Certification Portugal, Unipessoal, Lda.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 51 | 51 | 861 | 287 | 574 |
