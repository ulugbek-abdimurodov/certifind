# BAS (Bulgaria) - ISO/IEC 17065

Source: Bulgarian Accreditation Service (ИА БСА), register of product certification bodies,
https://www.nab-bas.bg/en/registers (field "Certification Bodies - Products"), Bulgarian and English detail pages.
Scraped with `database/bulgaria/17065/nab_prod_scraper.py` (29 records), converted with
`database/bulgaria/17065/prepare_certifind_17065.py`; review in `database/bulgaria/17065/bas_17065_review.md`.
Not yet verified by a person, so `verified_at` is empty.

Rules:

- One accreditation per certificate number ("N ОСП"); `issue_date` = initial accreditation date, `expiry_date` =
  certificate valid-to; `proof_url` = English register page. Withdrawn records ("Отнета акредитация": 6, 17 x2,
  18, 24 ОСП) are left out. 22 ОСП has three records: the newest (PEFC, valid from 2026-08-18) is used.
- Body rows: 7 bodies with the same Bulgarian legal-entity name as a `bas-bulgaria` row reuse that row exactly.
  Others are named "<Latin transliteration> (<Bulgarian legal entity>)" (Bulgarian streamlined system), with
  the city of the main office as address and the office phone (+359) and email. The register gives no English
  company names, so the transliteration is not a translation.
- Lines from the register's scope text (English when given, Bulgarian for 22, 26 and 27 ОСП), one line per
  scope row; a row ending in ':' is the `scheme_text` of the rows under it. The full-scope Word annexes are not
  read. "To perform certification..." lines and footnotes are left out (18).
- `scheme`: EU organic regulation, EU geographical indications, CPR 305/2011, PEFC etc. via the shared tables;
  other lines get a sector.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 22 | 22 | 105 (71 with a scheme) |
