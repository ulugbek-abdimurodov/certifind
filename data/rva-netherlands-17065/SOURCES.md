# RvA (Netherlands) - ISO/IEC 17065 product, process and service certification

Source: the Dutch Accreditation Council register, https://www.rva.nl/alle-geaccrediteerden/, discipline
"Productcertificatie-instellingen" (normative document EN ISO/IEC 17065:2012): 66 registrations (C-numbers), each with
an "Annex to declaration of accreditation" in Dutch (-scn.pdf) and/or English (-sce.pdf). 21 have both, 22 Dutch only
and 23 English only. Scraped with `../database/netherlands/17065/scrape_nl_rva_17065.py`, converted with
`prepare_certifind_17065.py` in the same folder. Notes are in `rva_17065_review.md` there. Not yet verified by a
person, so `verified_at` is empty. `proof_url` is the annex PDF. The RvA row comes from the MS import;
`V81__rva_17065_schemes.sql` adds two EU regulations.

Extraction rules:

- **One `ISO/IEC 17065` accreditation per C-number (66).** None collides with `rva-netherlands`, so there is no
  suffix. `issue_date` / `expiry_date` are the annex's "valid from / to" dates.
- **The annex scope table is read from its rules.**
  - The table is "Product / Product Group | Certification Scheme | Standard / normative document". Vertical rules
    split the columns, and horizontal rules split the records. One record = one line, with `product_text`,
    `scheme_text` and `normative_docs`.
  - Pages without a column header (C666, many Kiwa VERIN and notified-body pages) use the table ruled to x≈558, with
    default columns product | scheme | normative.
  - Location pages (site lists) are skipped.
  - A record that continues on the next page is joined to the record above, and an empty product cell repeats the
    product above.
  - Struck-through words (withdrawn activities) are left out.
  - Line order follows the annex.
- **Language.** The Dutch annex is the original (`product_text`). When the English annex has the same number of
  records, its product text is paired into `product_text_en`; this worked for 10 bodies and failed for 11, whose record
  counts differ (those keep Dutch only). English-only annexes fill both columns. Kiwa VERIN's Dutch annex has no
  readable table, so its English annex is used.
- **Schemes.**
  - EU directives and regulations: ATEX, rail 2016/797, CPR, MID, F-gas, PED, recreational craft, marine
    equipment, machinery, PPE, lifts, gas appliances, organic, and, new in V81, the Cyber Resilience Act 2024/2847 and
    the AI Act 2024/1689.
  - A notified-body heading ("… is suitable for notification") or a directive line sets the directive for the
    following module / annex lines, until another scheme appears.
  - Private schemes: GLOBALG.A.P., BRCGS, IFS (also written out as "International Featured Standard – …"), PEFC,
    eIDAS, Common Criteria and others.
  - Dutch national schemes stay as text with an industry: BRL / KOMO, CCV, NCS, SKH, Kiwa K product certificates,
    IKB Kip / Ei, Holland Varken Quality, Maatlat Duurzame Veehouderij, Fertigarant, Bouwbesluit / Regeling. So do
    single-body marks (DEKRA Mark, KEMA-KEUR, KAT).
  - Lines that match no industry word take the body's most common industry (257 lines, mostly GLI's jurisdiction
    lists).
- **Left out:**
  - notified-body headings, used as context only: 77
  - notes, footnotes and leaked header rows: 94
  - struck-through words (withdrawn activities): 324
  - location pages
  - 71 page-break continuations, joined to the record above
- **Bodies.** 22 rows are copied from `rva-netherlands` and 1 (DNV Business Assurance B.V) from `belac-belgium-17065`,
  by identical name; the C-numbers differ between the MS and product registers. The other 43 are built like the MS
  converter (city case, `+31 …` phones). Trans Certification's `+60139108724` was split into `+60 13 910 8724`.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 66 | 66 | 2,970 (1,654 with a scheme) |
