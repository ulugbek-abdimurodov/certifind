# ENAC (Spain) - ISO/IEC 17065 product, process and service certification

Source: ENAC's accredited-bodies search, https://www.enac.es/web/english/accredited-bodies/products-and-services-searchs,
list `idLista=6` (Product Certification, accreditation numbers NN/C-PRNNN): 208 accreditations of 163 bodies, each with a
Technical Annex PDF. Scraped with `../database/spain/enac-spain-17065/scrape_es_enac_17065.py`, converted with
`prepare_certifind_17065.py` in the same folder. Notes are in `enac_17065_review.md` there. Not yet verified by a
person, so `verified_at` is empty. `proof_url` is the body's first Technical Annex. The ENAC row comes from the MS
import; `V80__enac_17065_schemes.sql` adds the ENplus scheme.

Extraction rules:

- **One `ISO/IEC 17065` accreditation per body (163).** A body's accreditations are grouped by ENAC body number, with
  leading zeros ignored ("01" = "1"), and 19 bodies with several C-PR accreditations are merged. The certificate number
  is the first accreditation's (for example `01/C-PR038` for AENOR's 15). None collides with `enac-spain` (C-SC
  numbers), so there is no suffix. `issue_date` is the earliest entry into force. `expiry_date` is empty, since ENAC
  accreditations are valid until notice.
- **Annexes are read with pdfplumber in page reading order.**
  - Text outside tables that is a section title (PARTE I: ORGANISMO NOTIFICADO / REGLAMENTO (UE) 305/2011, PARTE II
    reglamentos nacionales, PARTE III producto, BLOQUE I, CERTIFICACIÓN DE CONFORMIDAD CON EL ESQUEMA …) sets the
    context.
  - In each table of 2+ columns, header cells give the column roles by their x-range: products / object / category
    / product group → `product_text`; scheme / evaluation process / AVCP system / module / decision →
    `scheme_text`; documents / specifications / standards → `normative_docs`. Each data cell takes the role of the
    header above it.
  - One row = one line. An empty, vertically merged product cell repeats the product above.
  - Full-width group rows ("4) Cementos / adiciones…") and the section context are carried into `scheme_text`.
  - A product-only fragment starting in lower case is joined to the line above.
  - Line order is the register's accreditation order, then page and row.
- **Schemes.**
  - EU regulations and directives (CPR 305/2011 only when the number is cited, rail 2016/797, RED, EMC, machinery,
    PED, PPE, gas appliances, lifts, marine) apply, as do EU organic ("producción ecológica", 2018/848) and EU
    geographical indications (DOP / IGP / ETG, denominaciones de origen).
  - Private schemes: GLOBALG.A.P. IFA and chain of custody, IFS, BRCGS, LEAF Marque, PEFC, eIDAS, ENplus, EN 15343,
    Common Criteria and others.
  - A directive cited in a section's rows carries down to the rest of that section, so the rail annexes'
    "Directiva 2016/797" reference table applies to the subsystems below.
  - A line citing its own Spanish decree or national scheme (Real Decreto, Esquema Nacional de Seguridad, Orden,
    Producción Integrada, regional marks) gets no scheme, and neither do the PARTE II / PARTE III national and
    voluntary product blocks. These stay as text with an industry from Spanish keywords.
  - Every line has a scheme or an industry.
- **Left out:**
  - one-cell tables, which are header fragments nested in the real tables: 1,009
  - table headers and leftovers: 38 + 29 "(**)" rows
  - site / location tables: 23
  - page boilerplate (annex header, validation code, footnotes)
  - 274 fragments joined to the line above, and 247 section titles + 202 group rows carried as context rather than
    imported as lines
- **Known weakness:** some rail annexes (DNV 131, SGS 181, CETREN 09) use rotated cells that pdfplumber splits into
  word fragments. Their lines keep the rail scheme but have poor text.
- **Bodies.** 18 rows are copied from `enac-spain` by identical name. ENAC numbers differ between the MS and product
  registers, so number matching is not used. The other 145 are built from the register (phones `+34 xxx xxx xxx`).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 163 | 163 | 3,671 (2,450 with a scheme) |
