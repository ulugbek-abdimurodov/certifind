# ATS (Serbia) - ISO/IEC 17065 product, process and service certification

Source: the Accreditation Body of Serbia register, http://www.registar.ats.rs/, searched by accreditation type
14 = SRPS EN ISO/IEC 17065:2016, 12 = SRPS ISO/IEC 17065:2013 and 6 = SRPS EN 45011, all statuses (37 records). Each
body's scope PDF is `/obim/<hash>`, saved as 2-04-NNN.pdf. Scraped with
`../database/serbia/ats-serbia-17065/scrape_rs_ats_17065.py`, converted with `prepare_certifind_17065.py` in the same
folder. Notes are in `ats_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty. `proof_url`
is the register case page `/predmet/<id>/`. The ATS row comes from the MS import; no new schemes were needed, so there
is no migration.

Extraction rules:

- **Only "Akreditovan" bodies: 25.** The 12 withdrawn ("Ukinuta akreditacija") are skipped and listed in the review.
  One `ISO/IEC 17065` accreditation per ATS number (04-NNN). These don't collide with the MS numbers (08-NNN), so there
  is no suffix. `issue_date` is the first accreditation date and `expiry_date` the register's expiry.
- **One line per row of the "Детаљан обим акредитације" table,** read with pdfplumber. The header row (Р. бр. |
  Производ / Група производа | Поступак оцењивања усаглашености | Референтна документа) assigns the columns to
  `product_text`, `scheme_text` and `normative_docs`.
  - A cell split over several PDF rows is joined back to its line.
  - Numbered children ("2.1", "MD 0105", GI products under a category) are their own lines.
  - Texts are verbatim and mostly Cyrillic. Some annexes are bilingual inside a cell ("Serbian / English"); these are
    kept as one text, and `product_text_en` is empty.
- **Industry from the sector rows:** С-01 electrical, С-03 construction, С-04 and С-07 machinery, С-08 electrical,
  С-09 agriculture, С-10 food (private security services: professional), С-11 health. Every line has an industry or a
  scheme.
- **Schemes.** Serbia is not in the EU, and almost all lines cite Serbian rulebooks and laws (Правилник, Закон, Уредба:
  gas appliances, radio equipment, medical devices, ATEX, pressure equipment, construction products, organic
  production, geographical indications). These are national, so they get no scheme and stay text plus industry.
  Only the 3 lines on organic certification in third countries, which cite Regulation (EU) 2018/848 itself, carry
  `EU Organic Regulation (EU) 2018/848`.
- **Left out:**
  - sector headings: 55
  - nested one-cell tables that repeat a cell's text: 152
  - "(наставак)" parent rows repeated on the next page: 5
  - site "Локација" rows: 7
- **Bodies.** 3 rows are copied from `ats-serbia` (same PIB): KVALITET AD Niš, TMS CEE DOO BEOGRAD and SGS BEOGRAD DOO
  Beograd. The other 22 use the register's Latin name, with `registration_no` = PIB. Phones are normalised to `+381 …`.
  "Privredna komora Srbije, Privredna komora Srbije, …" is collapsed to one occurrence.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 25 | 25 | 157 (3 with a scheme) |
