# UKAS (United Kingdom) - ISO/IEC 17065 product, process and service certification

Source: the UKAS register, product certification category,
https://www.ukas.com/find-an-organisation/browse-by-category/?cat=323: 145 accreditations, each with a Schedule of
Accreditation PDF (`https://www.ukas.com/download-schedule/<no>/Product`). Scraped with
`../database/uk/ukas-uk-17065/scrape_uk_ukas_17065.py`, which also saves each schedule's tables
(`schedule_tables/*.json`). Converted with `prepare_certifind_17065.py` in the same folder. Notes are in
`ukas_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty. `proof_url` is the schedule. The
UKAS row comes from the MS import; no new schemes were needed, so there is no migration.

Extraction rules:

- **One `ISO/IEC 17065` accreditation per body.** UKAS uses the same number for a body's MS and product schedules, so
  38 numbers that are also in `ukas-united-kingdom` get the ` (17065)` suffix (for example `0001 (17065)`).
  - SGS United Kingdom Limited holds three numbers (0005, 0191 and 5927). Its lines are merged under
    `0005 (17065)`, which gives 143 bodies for 145 register entries (142 imported, see below).
  - `issue_date` is the schedule's issue date. `expiry_date` is empty, since UKAS accreditations are valid until
    withdrawn.
- **One line per table row** of the schedule.
  - Voluntary schemes use "Product | Standard" (sometimes with a Location column, which is dropped).
  - Statutory activity uses "Directive / Regulation | Conformity Assessment procedure | Category of products |
    Essential requirements" under an "Accreditation for the purpose of … activity" row. The legislation and procedure
    go into `scheme_text` together with that activity row and any one-cell group heading ("Construction Products",
    "Personal Protective Equipment").
  - Merged legislation and product cells repeat the cell above.
  - Header-less statutory tables (rail) use default columns.
- **Schemes.**
  - **UK Approved Body activity** (UKCA, GB legislation including "retained EU law", the Railways
    (Interoperability) Regulations 2011) is national, so those lines get no EU scheme.
  - **Notified Body activity** (EU law, for Northern Ireland) gets the EU scheme: CPR, MID, PPE, ATEX, PED, lifts,
    machinery, EMC, RED, recreational craft, gas appliances, rail and others. A Notified Body row without its own
    directive takes the directive of the rows above in the same block.
  - Voluntary private schemes: BRCGS (food, packaging, storage, agents, consumer), IFS (food, logistics, broker),
    GLOBALG.A.P., PEFC, LEAF Marque, eIDAS, ISO 3834, IEC 61508 and others.
  - UK national schemes stay as text with an industry: NSI, STS, BAFE, MCS, Red Tractor, LPCB, Certifire, BSI PAS
    specifications, UK PGI, Building Regulations competent-person schemes, MCERTS, and gambling regulators' schemes.
  - Every line has a scheme or an industry.
- **Left out:**
  - page headers and location tables: 2,096 rows
  - rows before any column header, mostly site addresses: 322
  - "END" markers: 178
  - rows without product or standard: 273
  - ✓-matrix and location rows: 8
  - 609 activity headings and 958 group headings, carried into `scheme_text` rather than imported as lines
- **Not imported:** Ex Veritas Limited (8613). Its schedule returned HTTP 502 in the scrape and on a retry, and the
  register gives no issue date. Re-run the scraper to add it.
- **Bodies.** 41 rows are copied from `ukas-united-kingdom` (same UKAS number, or same name for SGS and BTTG). The rest
  are built like the MS converter: `+44 …` phones (first number only, unspaced numbers split after the country code),
  and the address without the country.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 142 | 142 | 3,789 (978 with a scheme) |
