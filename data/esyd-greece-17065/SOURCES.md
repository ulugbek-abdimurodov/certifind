# ESYD (Greece) - ISO/IEC 17065 product, process and service certification

Source: the Hellenic Accreditation System register, http://www.esydops.gr/portal/p/esyd/en/ (body detail pages
`showOrgInfo.jsp?id=…`). ESYD still labels product certification with the old standard "ELOT EN 45011"; the filter is
standard ~ 17065|45011 (site search `accStd:45011`), and it matches all 69 bodies of the site's own search. Scraped with
`../database/greece/esyd-greece-17065/scrape_gr_esyd_17065.py` (English scope annexes, Word .doc), converted with
`prepare_certifind_17065.py` in the same folder. Notes are in `esyd_17065_review.md` there. Not yet verified by a person,
so `verified_at` is empty. `proof_url` is the body's register page. The ESYD row comes from the MS import; no new schemes
were needed, so there is no migration.

Extraction rules:

- **One `ISO/IEC 17065` accreditation per body.** ESYD gives a body one registration per field (E.C. directives,
  voluntary / national, organic, GLOBALG.A.P., AGRO 2, QS, GHG verification). These are merged, with lines in register
  order. The certificate number is the base of the body's most frequent registration ("256-10" becomes `256`), skipping
  the separate GHG-verification numbers. None collides with `esyd-greece`, so there is no `(17065)` suffix. Three bodies
  have no number other than their register id and use `ESYD-<id>`. `issue_date` is the earliest registration; `expiry_date`
  is the latest "valid until" date in the annexes, or empty.
- **One line per annex table row.** Rows are rebuilt from the Word cell marks. The header row ("Field of certification
  | Type of certification | Normative Regulations / Standards…") assigns the columns to `product_text`, `scheme_text`
  and `normative_docs`.
  - A row split by an empty merged cell is rejoined when that restores the header width. Other rows of the wrong width
    keep all their cells in `product_text`.
  - An empty "Field" cell (vertically merged) repeats the field above.
  - `line_no` follows register order, then annex order.
- **Schemes.** A directive or regulation in a row (2014/33, 2014/68, 305/2011, 2014/30, 2013/53, 2016/797…) sets
  the scheme and carries it down until the next scheme or table header. A row citing a Greek decision (M.D., J.M.D.,
  G.G., Law) ends a directive block.
  - Organic and GLOBALG.A.P. annexes default to `EU Organic Regulation (EU) 2018/848` and `GLOBALG.A.P. IFA`.
  - Private schemes and standards (ISO 3834, EN 15343, EN 15085-2…) map by regex.
- **Kept as text without a scheme, with an industry:** Greek national schemes. These are AGRO 2 / AGRO 10 integrated
  management, hotel and room classification (M.D. 216/2015), the National Climate Law 4936/2022, and ministerial decisions.
  The same applies to schemes outside the catalogue: GHG verification (EU ETS 2018/2067, ISO 14064 / 14067, CBAM), QS,
  diving and tourism services, BIM, and playground and sports equipment. GHG-verification lines are imported
  although ESYD accredits them under ISO 14065 / 17029, because the register lists them under 45011.
- **Annexes missing on the site** (8 English .doc files return 404): the register's field text is imported as the
  registration's single line.
- **Left out:**
  - table headers and annex preambles: 200 rows
  - title blocks and signatures (annex number, "SCOPE of ACCREDITATION", address, signatory, validity sentence,
    "CEO of ESYD"): 112 rows
  - one row with only a number
  - text after the last table (footer)
- **Bodies.** 22 body rows are copied from `esyd-greece` (same register id). The other 47 are built with the MS
  converter's helpers (`clean_name`, `country_of`, `normalise_phone/email/website`).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 69 | 69 | 794 (468 with a scheme) |
