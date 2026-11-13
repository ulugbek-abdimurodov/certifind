# ACCREDIA (Italy) - ISO/IEC 17065 product, process and service certification

Source: ACCREDIA (Ente Italiano di Accreditamento) database of accredited bodies,
https://services.accredia.it/ppsearch/accredia_orgmask.jsp, search by standard 2 = "UNI CEI EN ISO/IEC 17065:2012 -
Prodotti/Servizi/Processi", then each body's detail page and its PRD annex PDFs (`<no>PRDrev<NNN>_ALL_<annex>`).
Scraped with `../database/italy/accredia-italy-17065/scrape_it_accredia_17065.py` (`accredia_17065_raw.json`,
`scope_lines.csv`, 241 accreditations, 17,569 annex lines), converted with `prepare_certifind_17065.py` in the same
folder; notes are in `accredia_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty.
`source_url` and `proof_url` are the register detail page. The accreditation body row comes from
`V2__reference_data.sql`; schemes are added in `V67__accredia_17065_schemes.sql`, `V68__uni_cei_11352_scheme.sql` and
`V69__eu_regulation_schemes.sql`.

Scope of the dataset: **every** ACCREDIA 17065 body and annex line is imported (decision of 2026-11-13), including
notified-body / CE marking work, Construction Products Regulation AVCP, DOP/IGP/STG control, organic control, F-gas
certification and Italian national schemes. `prepare_certifind_17065.py --exclude` reproduces the earlier, narrower
rules (those categories left out).

Extraction rules:
- One `ISO/IEC 17065` accreditation per body. ACCREDIA uses the same number for a body's MS and PRD accreditation,
  so numbers already used in `accredia-italy` get the suffix ` (17065)` (e.g. `00001 (17065)`). Issue date from the
  register; the register gives no expiry date.
- `product_scopes.csv`: one row per annex line, verbatim (Italian), `line_no` in annex order (annex type, file,
  row). Headings such as "- BRC Global Standard Food Safety versione 9:" are not imported as lines: their text goes
  into `scheme_text` of the lines under them, and their scheme is carried down. A directive / regulation heading
  ("Direttiva 2014/33/UE Ascensori...", "Regolamento (UE) 2011/305 - Prodotti da costruzione") applies to every
  following line (modules, product families) until the next scheme heading. In the CPR tables each product family
  is one line; its harmonised EN standards are collected in `normative_docs` / `standard_refs`, the AVCP system is
  not imported. The ISO/IEC 17067 scheme type is dropped.
- Annexes are Italian then English. The English half is paired line by line into `product_text_en` when both halves
  give the same number of lines (otherwise English left empty; listed in the review).
- `scheme` by regex on the line and its heading: EU directives / regulations (Machinery, Lifts, PED, ATEX, EMC, RED,
  PPE, gas appliances, toys, measuring instruments, CPR, rail, DOP/IGP/STG, organic, F-gas...), private schemes
  (BRCGS, IFS, GLOBALG.A.P., PEFC, Friend of the Sea, LEAF Marque, Europrivacy), eIDAS / ETSI EN 319 4xx, ISO 22005,
  ISO 3834, EN 15085-2 and UNI CEI 11352 (ESCO). Italian national schemes (UNI/PdR, SPID, animal welfare national
  quality system, SQNPI, national biofuel sustainability system, REMADE, security institutes, beaches, lift checks
  under DPR 162/99 and DPR 8/2015...) are imported without a `scheme`. `industry` only on lines without a scheme,
  from keywords in the line, its heading or the annex sector heading. `standard_refs` lists ISO / IEC / EN / ETSI
  identifiers found in the line (UNI-only numbers are not listed).
- Bodies already in other datasets reuse that row exactly (63, mostly from `accredia-italy` by registration number;
  by name: IGQ, RINA Services SPA, IAS Register AG from `accredia-italy`, CERTI AL sh.p.k from `dpa-albania`,
  Vietnam Certification Centre - QUACERT from `jasanz-australia`). A name match with a different ACCREDIA
  registration number is not reused (CERTIFICA S.r.l. 01502 and CERTIFICA.SRL S.r.l. 02061 are different
  companies). Other bodies: main site = first register site with a phone or email; country from the end of the
  address (region names before it moved into the address); phones made international (Côte d'Ivoire number kept in
  the pre-2021 8-digit form given by the register).
- Not catalogued (one body each, kept as text without `scheme`): COSMOS, GSTC, Interprivacy, proprietary schemes.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-13 | 241 | 241 | 5,857 (4,501 with a scheme) |
