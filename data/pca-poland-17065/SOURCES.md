# PCA - ISO/IEC 17065

Source: https://www.pca.gov.pl/en/accredited-organizations/accredited-organizations/product-certification-bodies

PCA register, section Product certification bodies (that section's search endpoint). Scraper `database/poland/17065/scrape_pl_pca_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`pca-poland`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (39 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- none

Reused body rows:

- AC 001 Sieć Badawcza Łukasiewicz - Przemysłowy Instytut Motoryzacji: reused (same country and name)
- AC 002 Sieć Badawcza Łukasiewicz - Warszawski Instytut Technologiczny: reused (same country and name)
- AC 005 Zakłady Badań i Atestacji "Zetom" im. Profesora Fryderyka Stauba w Katowicach Sp. z o.o.: reused (same country and name)
- AC 010 Instytut Nafty i Gazu - Państwowy Instytut Badawczy: reused (same country and name)
- AC 013 Polskie Centrum Badań i Certyfikacji S.A.: reused (same country and name)
- AC 020 Instytut Techniki Budowlanej: reused (same country and name)
- AC 029 Sieć Badawcza Łukasiewicz - Górnośląski Instytut Technologiczny: reused (same country and name)
- AC 038 Główny Instytut Górnictwa - Państwowy Instytut Badawczy: reused (same country and name)
- AC 041 Sieć Badawcza Łukasiewicz - Warszawski Instytut Technologiczny: reused (same country and name)
- AC 093 "PNG" Sp. z o.o.: reused (same country and name)
- AC 099 Ośrodek Badań, Atestacji i Certyfikacji OBAC Sp. z o.o.: reused (same country and name)
- AC 100 Urząd Dozoru Technicznego: reused (same country and name)
- AC 103 TUV Nord Polska Sp. z o.o.: reused (same country and name)
- AC 114 Polski Rejestr Statków S.A.: reused (same country and name)
- AC 126 Transportowy Dozór Techniczny: reused (same country and name)
- AC 141 TUV Rheinland Polska Sp. z o.o.: reused (same country and name)
- AC 149 J.S. Hamilton Poland Sp. z o.o.: reused (same country and name)
- AC 159 DEKRA Certification Sp. z o.o.: reused (same country and name)
- AC 161 TUV SUD Polska Sp. z o.o.: reused (same country and name)
- AC 169 GLOBAL QUALITY Sp. z o.o.: reused (same country and name)
- AC 182 Bureau Veritas Polska Sp. z o.o.: reused (same country and name)
- AC 188 Polska Akademia Jakości Cert Sp. z o.o.: reused (same country and name)
- AC 193 DQS Polska Sp. z o.o.: reused (same country and name)
- AC 203 Wojskowa Akademia Techniczna im. Jarosława Dąbrowskiego: reused (same country and name)
- AC 204 Grand Cert Sp. z o.o.: reused (same country and name)
- AC 214 TUV Thuringen Polska Sp. z o.o.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 103 | 103 | 329 | 132 | 197 |
