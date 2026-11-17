# TUNAC (Tunisia) - ISO/IEC 17065 product, process and service certification

Source: register of the Tunisian accreditation council (Conseil National d'Accréditation, TUNAC),
https://www.tunac.tn/webtunac.nsf/rechercheroec.html (JSON agent `(jsongetsearchtowebis)`), domain "Cert.Produit"
(ISO/IEC 17065), and each body's technical annex (F.C.48B). Scraped with
`../database/tunisia/tunac-tunisia-17065/scrape_tn_tunac_17065.py`, converted with `prepare_certifind_17065.py` in the
same folder; notes are in `tunac_17065_review.md` there. The annexes are scanned PDFs without a text layer, so their
tables were transcribed by reading them (`annex_transcription.csv`). Not yet verified by a person, so `verified_at`
is empty. `proof_url` is the annex PDF on tunac.tn. The accreditation body row comes from
`V12__tunac_reference_data.sql`; new schemes are added in `V75__tunac_17065_reference_data.sql`.

Annex types (all F.C.48B, French only):

- "Programme spécifique de certification" tables: family / product / requirements / remarks, one table per scheme
  (INNORPI 3-0014, CERMED 3-0020, APAVE CI 3-0021, CTPC 3-0025).
- Ecocert Tunisie 3-0023: an EU organic third-country table (Reg. (EU) 2018/848, Art. 35(7) categories a, b, d, e, g)
  and a Tunisian organic farming table (Loi n°99-30, categories A, C, D).

Extraction rules:

- One `ISO/IEC 17065` accreditation per TUNAC number. None of the numbers is used in `tunac-tunisia`, so no
  ` (17065)` suffix. `issue_date` / `expiry_date` are the register's current cycle ("Accrédité entre").
- `product_scopes.csv`: one row per product row of an annex table, `product_text` = "family: product (remark)",
  `scheme_text` = the programme heading, `normative_docs` = the requirements column. `scopes.csv` is empty (no EA codes
  in 17065). `product_text_en` is empty (French-only annexes).
- Schemes: BRCGS Food Safety, BRCGS Packaging Materials, EU Organic Regulation (EU) 2018/848, and one new code:
  EN 15343. The Tunisian organic farming law 99-30 and quality label are national schemes, imported as text with an industry. CERMED's private
  "Pêche artisanale durable" guidelines (one body) are kept as text without a scheme (industry `food`).
- Left out: ISO/IEC 17067 scheme type rows, Ecocert's site addresses, "countries covered" and flexible-scope notes.
- Bodies reused from other datasets: INNORPI (from `tunac-tunisia`, row 3-0001) and APAVE CÔTE D'IVOIRE (from
  `soac-cote-divoire`). New rows use the annex's "Nom de l'organisme" and contact. CTPC is in Morocco.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 5 | 5 | 32 (31 with a scheme) |
