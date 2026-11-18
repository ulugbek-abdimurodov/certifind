# SWEDAC - ISO/IEC 17065

Source: https://ackrediteringar.swedac.se/en

Swedac register JSON API, standard filter `iso-17065-2012` (SS-EN ISO/IEC 17065:2012). Scraper `database/sweden/17065/scrape_se_swedac_17065.py`; converter `prepare_certifind_17065.py` next to it. Scope rows outside ISO/IEC 17065 (17021-1 lines of the same accreditation) are ignored.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`swedac-sweden`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (100 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 375

Reused body rows:

- 1002 RISE Research Institutes of Sweden AB: reused from swedac-sweden (same number 1002)
- 1053 DNV Business Assurance Sweden AB: reused from swedac-sweden (same number 1053)
- 1236 Bureau Veritas Certification Sverige AB: reused from swedac-sweden (same number 1236)
- 1273 Qvalify AB: reused from swedac-sweden (same number 1273)
- 1631 Svensk Brand- och Säkerhetscertifiering AB: reused from swedac-sweden (same number 1631)
- 1639 Intertek Certification AB: reused from swedac-sweden (same number 1639)
- 1939 AAA Certification AB: reused from swedac-sweden (same number 1939)
- 2064 ControlCert Scandinavia AB: reused from swedac-sweden (same number 2064)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 25 | 25 | 1281 | 705 | 576 |
