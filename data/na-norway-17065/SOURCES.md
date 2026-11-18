# NA - ISO/IEC 17065

Source: https://www.akkreditert.no/en/akkrediterte-organisasjoner/?scope=ProdCert

Norsk Akkreditering register, scope ProdCert (Product certification), record pages `/produkt/?AkkId=`. Scraper `database/norway/17065/scrape_no_akkreditert_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`na-norway`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (7 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 1

Reused body rows:

- PROD 001 Nemko Group AS: reused (same country and name)
- PROD 006 Stiftelsen Kontrollrådet: reused (same country and name)
- PROD 013 DNV Business Assurance Norway AS: reused (same country and name)
- PROD 021 DNV Product Assurance AS: reused (same country and name)
- PROD 024 Kiwa AS: reused (same country and name)
- PROD 025 Dovre Sertifisering AS: reused (same country and name)
- PROD 026 Akvasafe AS: reused (same country and name)
- PROD 035 Synfaring AS: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 20 | 20 | 154 | 96 | 58 |
