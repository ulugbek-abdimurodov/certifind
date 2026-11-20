# IOAS - ISO/IEC 17065

Source: https://ioas.org/accredited-certification-bodies/

IOAS accredited-body pages (sitemap), the 17065 sections of each page, the register status table and each body's ISO/IEC 17065 accreditation certificate (effective date, renewal date) and certificate annex (standard / categories / geographical scope). Bodies holding only COR, NATRUE, IFOAM, GOTS or Textile Exchange recognition are not 17065 and are left out by the scraper. Scraper `database/usa/ioas-usa-17065/scrape_us_ioas_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`none`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (4 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (applicant): 7

Reused body rows:

- 112 USB CERTIFICATION DENETİM GÖZETİM VE BELGELENDİRME HİZMETLERİ ANONİM ŞİRKETİ: reused (same country and name)
- 125 GCL International Ltd: reused (same country and name)
- 151 IFC GLOBAL SERTİFİKASYON MUAYENE VE EĞİTİM HİZMETLERİ ANONİM ŞİRKETİ: reused (same country and name)
- 302 Baltic Testing India Pvt. Ltd.: reused (same country and name)
- 350 Eurofins Assurance India Pvt. Ltd.: reused (same country and name)
- 81 CU Inspections & Certifications India Pvt. Ltd.: reused (same country and name)
- OneCert_International_Pvt._Ltd OneCert International Pvt. Ltd.: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-19 | 47 | 47 | 195 | 130 | 65 |
