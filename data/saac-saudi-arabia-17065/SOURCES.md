# SAAC - ISO/IEC 17065

Source: https://saac.gov.sa/en/accredited-cabs/?searchType=AdvancedSearch&serviceSearch=Products+Certificates

SAAC register, advanced search service type 'Products Certificates', each CAB's detail page (scope tables). Scraper `database/saudi-arabia/17065/scrape_sa_saac_17065.py`; converter `prepare_certifind_17065.py`. Dates on the register are month/day/year.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`saac-saudi-arabia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (385 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 17098
- not accredited (Expired): 2
- not accredited (Cancelled): 2

Reused body rows:

- N-P-00006 Branch of TUV Austria Shanghai Co. Ltd: reused (same country and name)
- N-P-00009 Bureau Veritas KSA: reused (same country and name)
- N-P-00018 National Inspection & Technical Testing Company Ltd. (FAHSS): reused (same country and name)
- N-P-00047 SGS Española de Control SA: reused (same country and name)
- N-P-00063 Nemko Group AS: reused (same country and name)
- N-P-00082 Intertek International Limited, Dubai Branch: reused (same country and name)
- N-P-00084 Intertek Testing Services Ltd Shanghai: reused (same country and name)
- N-P-00106 Branch of GulfTIC Certification LLC: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 45 | 45 | 597 | 0 | 597 |
