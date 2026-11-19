# MOLDAC (Moldova) - ISO/IEC 17065 product certification

Source: the MOLDAC register category "Organisme de certificare a produselor",
https://acreditare.md/en/register_category/organisme-de-certificare-a-produselor/ (11 bodies: 10 "Activ", 1 "Retras").
Each body has an accreditation certificate PDF and one annex PDF per CAEM/NACE division. Scraped with
`../database/moldova/moldac-moldova-17065/scrape_md_moldac_17065.py`, converted with `prepare_certifind_17065.py` in the
same folder. Notes are in `moldac_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty.
`proof_url` is the certificate PDF. The MOLDAC row comes from the MS import; no new schemes were needed, so there is no
migration.

Extraction rules:

- **Only "Activ" bodies: 10.** OCpr-024 (ANRCETI) was withdrawn on 08.07.2026 and is skipped. One `ISO/IEC 17065`
  accreditation per OCpr number. These don't collide with the MS numbers (OCsm-…), so there is no suffix.
  `issue_date` is the date of the current certificate file, and `expiry_date` is empty because the PDFs don't state
  it clearly.
- **One line per product row of the annex tables,** read with pdfplumber. The tables have the columns NR. | NR. CAPITOL
  NC | POZIŢIA TARIFARĂ NC | DENUMIRE PRODUS / GRUPĂ (or CATEGORIE DE PRODUSE) | DOCUMENT NORMATIV PRODUS |
  SCHEMĂ / SISTEM / MODUL DE CERTIFICARE | DOCUMENT CARE DESCRIE SCHEMA.
  - `product_text` = the product name and `normative_docs` = the product's normative document.
  - `scheme_text` = the legal-basis heading above the rows ("Hotărârea Guvernului nr. 913 …", "DOMENIUL
    NEREGLEMENTAT"…) plus the module or system when given ("B, C2, F, G", "2+", "DOP/IGP").
  - Rows without a product continue the row above.
  - Line order follows the register's annex order, then page and row.
- **Industry** from the annex's NACE division (title or "Denumire Diviziune CAEM/NACE" on page 1). For example:
  10–12 food, 01/03 agriculture, 07/08/23 construction, 13–15 textiles, 19 energy, 20 chemicals, 22 rubber_plastics,
  24/25 metals, 92 gambling equipment as other_manufacturing. Every line has one.
- **No catalogue scheme.** Moldova is not in the EU, and every annex cites Moldovan laws, government decisions (HG)
  and orders, including those transposing EU directives (construction products, gas appliances, lifts, pressure
  equipment, toys, recreational craft) and the national wine DOP/IGP. These stay as text plus industry.
- **Left out:**
  - ISO/IEC 17067 scheme types ("1b, 2, 3"): 128 cells
  - the bodies' internal procedure names (PC-xx "Procedura de certificare…"): 115 cells
  - legal-basis headings as lines of their own: 48 (they are carried into `scheme_text` instead)
  - 2 rows with only a number or NC code
  - boilerplate (approval, signature, page footers)
- **Bodies.** 2 rows are copied from `moldac-moldova`: ÎS Centrul de Metrologie Aplicată și Certificare (OCpr-001)
  and Certmatcon SRL (OCpr-049). The other 8 use the register name without the "OC produse din cadrul" prefix.
  Phones are normalised to `+373 …`.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 10 | 10 | 387 (0 with a scheme) |
