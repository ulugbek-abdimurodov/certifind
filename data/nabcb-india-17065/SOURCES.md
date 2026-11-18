# NABCB - ISO/IEC 17065

Source: https://nabcb.qci.org.in/product-certification/

NABCB directory page Product Certification Bodies and each body's detail page (scope table). Scraper `database/india/17065/scrape_in_nabcb_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`nabcb-india`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (514 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 301
- boilerplate / header line: 25
- body with no importable scope line: 2
- not accredited (Suspended): 1

Reused body rows:

- PC001 TQ cert Services Private Limited: reused (same country and name)
- PC005 Bureau Veritas (India) Pvt. Ltd.: reused (same country and name)
- PC007 SGS India Private Limited: reused (same country and name)
- PC013 Cotecna Inspection India Pvt. Ltd.: reused (same country and name)
- PC016 TUV SUD South Asia Pvt. Ltd.: reused (same country and name)
- PC030 Equalitas SystemCert Pvt. Ltd.: reused (same country and name)
- PC040 Trace Assure Global Certifications Pvt. Ltd.: reused (same country and name)
- PC042 DNV Business Assurance India Pvt. Ltd.: reused (same country and name)
- PC049 TRANS CERTIFICATION & INSPECTION SDN. BHD.: reused (same country and name)
- PC059 MS Certification Services Pvt. Ltd.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 44 | 44 | 1368 | 30 | 1338 |
