# HAA (Croatia) - ISO/IEC 17065

Source: Hrvatska akreditacijska agencija (HAA) register of accreditations,
https://akreditacija.gov.hr/frontend/registar-akreditacija, filtered to the scheme "Certifikacijska tijela za
certifikaciju proizvoda" (standard HRN EN ISO/IEC 17065:2013). Scrape: `database/croatia/17065/haa_prod_data/`
(`bodies.json`, and per accreditation `record.json`, `certificate.pdf`, `document_text.txt`). Converted with
`database/croatia/17065/prepare_certifind_17065.py`; notes in `database/croatia/17065/haa_17065_review.md`.
Not verified by a person, so `verified_at` is empty.

Extraction rules:

- One register entry is one accreditation; the certificate number is HAA's `BrojPotvrde` (no collision with the
  management-system dataset `haa-croatia`, so no suffix). Issue date: "Prva akreditacija / Initial accreditation"
  in the certificate text (ISO or dd.mm.yyyy dates), else "Akreditacija vrijedi od". Expiry: the register's
  `DatumIsteka`.
- Product lines: one row per standard / regulation cited in each annex section ("Certifikacijska shema utemeljena
  na / Certification scheme based on"); `product_text` is the English half of the bilingual section heading,
  `scheme_text` the scheme basis, `normative_docs` the cited document plus applicable documents. Product rows inside
  the flattened annex tables are not split further. `product_text_en` is empty (no line-by-line pairing).
- `scheme`: regex table (Croatian-specific rules, then the shared ACCREDIA table). EU directives and regulations map
  to the V69 / V73 codes (CPR, PPE, ATEX, organic, geographical indications, machinery, PED, SPV, MI, rail, lifts,
  marine equipment, recreational craft), plus ISO 3834. Croatian national schemes (mine-action equipment
  certification, Hrvatska kvaliteta / Izvorno hrvatsko) have no code and keep their text with an industry.
  IECEx lines (one body) are text with industry `electrical`.
- Bodies reused exactly: Bureau Veritas Croatia d.o.o. and Hrvatski registar brodova (rows from `haa-croatia`),
  CAC Conformity Assessment Center (row from `ias-usa`). Other names are the register's "AkreditornoTijelo" text.
- Nothing was dropped: every register entry under the 17065 standard has at least one line.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-18 | 34 (3 reused) | 34 | 851 (798 with scheme, 53 with industry only) |
