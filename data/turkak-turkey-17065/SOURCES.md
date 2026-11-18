# TÜRKAK (Turkey) - ISO/IEC 17065 product, process and service certification

Source: TÜRKAK's list of Product Certification bodies (institution type `U`, codes `AB-nnnn-U`),
https://asist.turkak.org.tr/en/accreditation/accreditationagencysearch?institutionType=U. Contacts, status and dates
come from the TÜRKAK API; scopes come from the annex tables of the signed certificate: the English PDF, or the
Turkish one when no English certificate is published. `proof_url` and `source_url` are each body's TÜRKAK
certificate page. Not yet verified by a person, so `verified_at` is empty.

Generated with `database/turkey/17065/scrape_tr_turkak_17065.py` (built on `../17021/turkak_scraper.py`) and
`prepare_certifind_17065.py` in the same folder; notes are in `turkak_17065_review.md` there. The accreditation body
row comes from `V3__turkak_reference_data.sql`; no new schemes, so no migration.

Annex types (tables read with PyMuPDF, one scope line per table row):

- EU notified-body annexes: a heading per directive / regulation ("Pressure Equipment Directive (2014/68/EU) -
  Additional assessment document ..."), then rows "product family | module / annex". Construction Products
  Regulation annexes have "Commission decision | product family | AVCP system | harmonised standards".
- Voluntary-field annexes: a sector heading ("Construction Products (Voluntary Field)", "Welding", "Playgrounds and
  Sports Equipments") then "product / product group | standard / certification scheme".
- Agriculture annexes: "product group | body function and technical requirements" (Turkish organic farming law
  and regulation, Turkish good agricultural practices regulation, EU organic, GLOBALG.A.P.).
- 18 bodies publish only a Turkish certificate (listed in the review); their lines are Turkish.

Extraction rules:

- One `ISO/IEC 17065` accreditation per TÜRKAK code. The 17065 codes end in `-U` and never match the 17021 codes
  (`-YS`), so no ` (17065)` suffix. `issue_date` is the initial accreditation date, `expiry_date` the validity date.
- Only bodies with a currently valid accreditation are kept (as in `turkak-turkey`): 4 withdrawn and 1 suspended
  bodies are left out, plus AB-0198-U, whose register detail returned HTTP 500 on every attempt.
  "Active, Withdraw Some Scopes" is treated as active; the annex lists the scopes still held.
- `product_scopes.csv`: one row per product row. Section headings are not imported as lines: their text goes into
  `scheme_text` and their scheme is carried to the rows below. Cells naming standards, modules or regulations go to
  `normative_docs`; the rest is `product_text`. Page banners, address rows and column headers are dropped.
- `scheme` from the heading or row: EU directives / regulations (CPR, PPE, PED, Lifts, ATEX, gas appliances,
  machinery, recreational craft, measuring instruments, ...), EU organic, GLOBALG.A.P., BRCGS, IFS, PEFC,
  ISO 3834 and EN 15085-2. The Turkish Organic Farming Law / Regulation and Good Agricultural Practices
  Regulation are national schemes: imported as text with industry `agriculture`, no scheme code. Other voluntary-field lines (Turkish standards, playground EN 1176/1177,
  software process ISO/IEC 33000) have no scheme and get an `industry`.
- Bodies already in `turkak-turkey` reuse that row (33, matched by name). Country is Turkey, except AB-0081-U
  (Lefkoşa: Cyprus) and AB-0199-U (Amman: Jordan). One active body (AB-0101-U) has no certificate published.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 131 | 131 | 1,339 (1,103 with a scheme) |
