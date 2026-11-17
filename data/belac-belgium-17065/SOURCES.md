# BELAC (Belgium) - ISO/IEC 17065

Source: BELAC register of product certification bodies (PROD), https://weblist.economie.fgov.be/en/belac/prodCert
(API `https://weblist.economie.fgov.be/api`), and each body's certificate + annex PDF
(`https://ng3.economie.fgov.be/NI/belac/prodcert/scope_pdf/<number>.pdf`). Scraped on 2026-11-17 with
`database/belgium/17065/belac_prod_scraper.py` (33 bodies, 33 PDFs), converted with
`database/belgium/17065/prepare_certifind_17065.py`; review in `database/belgium/17065/belac_17065_review.md`.
Not yet verified by a person, so `verified_at` is empty.

Rules:

- One accreditation per body, certificate number = BELAC number (`003-PROD`); `issue_date` / `expiry_date` = annex
  validity period; `proof_url` = the PDF.
- Body rows: 7 bodies with the same enterprise number as a BELAC 17021 body copy the `belac-belgium` row; DNV
  (rva-netherlands) and NSF Europe (dakks-germany-17065) reuse those rows. Phones made international (+32).
- Lines from the annex tables (French / Dutch, as printed): one line per table row; the section heading above
  it ("1.1 Marquage CE - Règlement (UE) N° 305/2011", "Production biologique", "BENOR-merk"...) is
  `scheme_text`; product cells -> `product_text`, standard / decision / regulation cells -> `normative_docs`.
  Rows continuing a product (system code + standard) inherit the product. AVCP system codes and internal
  procedure references are left out.
- `scheme`: EU regulations (CPR incl. AVCP decisions `97/740/EC` ..., organic, GI, PED, PPE, ATEX, toys, rail),
  private schemes (IFS, BRCGS, GLOBALG.A.P., MSC, PEFC ...) and, new in `V73__belac_17065_schemes.sql`, the
  Recreational Craft and Marine Equipment directives. Belgian national schemes (Vegaplan, Belplume, Codiplan,
  FEBEV, BePork, FASFC autocontrol guides, Feed Chain Alliance, BENOR, ATG) and schemes at one body only (TPED,
  Low Voltage, Batteries, Global Red Meat Standard) have no scheme but a sector.

Left out: 209 annex header, column header and footnote rows; 41 duplicate lines (same product repeated per
region).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 33 | 33 | 1,118 (423 with a scheme) |
