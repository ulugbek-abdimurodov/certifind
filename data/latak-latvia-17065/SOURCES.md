# LATAK (Latvia) - ISO/IEC 17065 product, process and service certification

Source: the LATAK register, https://www.latak.gov.lv/lv/akreditetas-institucijas, product certification bodies (ID prefix
S1, LVS EN ISO/IEC 17065): 27 entries, 22 active and 5 inactive. Each body has one PDF: the certificate followed by the
annex. Scraped with `../database/latvia/latak-latvia-17065/scrape_lv_latak_17065.py`, which extracts the annex tables to
`<S1-NNN>_annex_tables.csv`. Converted with `prepare_certifind_17065.py` in the same folder. Notes are in
`latak_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty. `proof_url` is the PDF. The
LATAK row comes from the MS import; no new schemes.

Extraction rules:

- **Only active bodies: 22.** Skipped as inactive: S1-159, S1-405, S1-556, S1-583 and S1-652. One `ISO/IEC 17065`
  accreditation per S1 number, which doesn't collide with the S2 numbers in `latak-latvia`. Dates are the register's.
- **One line per object.**
  - The annex table is "Objekts / Subjects | Sertifikācijas shēma / Certification scheme | Normatīvi-tehniskās
    dokumentācijas nosaukums / Normative document". Cells are bilingual (Latvian, then English) and kept verbatim
    in `product_text`; `product_text_en` is empty.
  - Rows with no object continue the line above (358).
  - An object cell continued on the next row or page (lower-case start) is joined (37).
  - Consecutive rows repeating the same object for further regulations are merged into one line (32).
- **Kiwa Latvia (S1-182):** its 32-page PDF has rotated annex pages whose text comes out reversed, so the register's
  scope text is imported with one line per item. A transcription of that annex would add more detail. Its issue date
  (2026-06-26) is the Accreditation Committee decision date printed on the certificate. Register dates written in
  Latvian ("2023. gada 23. aprīļa") are converted to ISO.
- **Schemes.**
  - EU directives and regulations win over the Latvian Cabinet regulations that transpose them: CPR, MID, NAWI,
    PED, ATEX, EMC, machinery, toys, lifts, PPE, rail and organic 2018/848.
  - Private schemes: PEFC, GLOBALG.A.P., ISCC PLUS and others.
  - Latvian national rules (MK noteikumi) and the EU food-hygiene regulations (no catalogue scheme) stay as text
    with an industry.
  - Every line has a scheme or an industry.
- **Left out:** column headers (86), the "1 | 2 | 3" column-number rows (13), and page headers repeating the
  certificate number (21).
- **Bodies.** 7 rows are copied from `latak-latvia`: 6 by company register number, and Kiwa Latvia by company, since
  the product unit "Produktu sertificēšanas institūcija" is the same AS Kiwa Latvia (40003130421). The other 15 use the
  register name and company number, with phones as `+371 xxxxxxxx`.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 22 | 22 | 230 (85 with a scheme) |
