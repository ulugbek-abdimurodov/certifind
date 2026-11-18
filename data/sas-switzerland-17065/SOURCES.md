# SAS (Switzerland) - ISO/IEC 17065

Source: SAS (Schweizerische Akkreditierungsstelle, Swiss Accreditation Service, part of SECO), register of
product, process and service certification bodies (SCESp), https://www.seco.admin.ch/en/search-accredited-bodies-sas,
and each body's "SCESp directory" (accreditation details and scope annex, PDF) in the language SAS publishes.
Register data: `database/switzerland/17065/sas_17065_data/` (`SCESp/bodies.csv`, `SCESp/documents.csv`, PDFs and text).
Scraped with `database/switzerland/17065/scrape_ch_sas_17065.py` (reuses `database/switzerland/sas_scraper.py` with
`--types SCESp`), converted with `database/switzerland/17065/prepare_certifind_17065.py`. Every skipped scheme,
fallback and uncertain choice is in `database/switzerland/17065/sas_17065_review.md`. Not verified by a person,
so `verified_at` is empty.

Extraction rules:

- One SCESp directory is one accreditation (`SCESp NNNN`, standard ISO/IEC 17065). Its validity is the current
  accreditation period (for example 2024-10-25 to 2029-10-24). SECO's lists of withdrawn and suspended
  accreditations (2026-11-04 / 2026-10-29) name SCESp 0096 and SCESp 0130, which are not in the register scrape
  and are not imported. No body of this dataset is withdrawn or suspended.
- Language: the directory's prevailing version is read ("gilt die deutsche Fassung" / "la version française
  fait foi"); otherwise German, then French, Italian and English. 26 bodies are read in German and 3 in French
  (COSC SCESp 0125, OIC SCESp 0054, TIMELAB SCESp 0119, which publish no German version). The English and other
  language versions are not converted; `product_text_en` is empty (no pairing).
- Product lines: one row per paragraph of the annex's "Approved technical scopes" column (paragraphs split by
  vertical gaps in the PDF). `normative_docs` is the text of the "Standards / Normen" cell that governs the
  paragraph; "Remarks / Bemerkungen" are appended to `product_text` in brackets. Footnote-only fragments such as
  "(*1, *2)" are merged into the previous row; SAS footnotes, the "Abkürzung/Bedeutung" glossary and the
  "Bei Widersprüchen..." notice are dropped. Text is verbatim (hyphenation at line ends joined, whitespace
  collapsed). Rows marked "Norm im Entwurf / Keine Zertifizierung" (draft standards) are dropped.
- `line_no` follows the order of the annex (page, then vertical position), per certificate.
- `scheme` comes from the regex table `SCHEMES` in the converter, matched on the normative cell (and remarks),
  then on the scope text for ISO / IEC / EN identifiers. Mapped: EU Organic Regulation 2018/848 (categories A-G of
  the annex), CPR 305/2011 (remarks "Bauproduktverordnung"; harmonised standards with AVCP system
  or FPC, S-Cert and SÜGB), ECM 2019/779, Rail 2016/797, Pressure Equipment 2014/68, ISO 3834, EN 50126 / 50128 /
  50129, IEC 61508, IEC 62443, ISO 26262, Common Criteria (ISO/IEC 15408), PPE 2016/425, Measuring Instruments
  2014/32, Machinery 2006/42, Machinery Regulation 2023/1230, Lifts 2014/33, ATEX 2014/34, Simple Pressure Vessels
  2014/29, Outdoor Noise 2000/14, NAWI 2014/31, Cableway 2016/424, EN 15085-2, Bio Suisse Standard (V79).
- Not mapped (kept as text with an `industry`): Swiss national ordinances (Bio-Verordnung SR 910.18, NEV SR 734.26,
  Swiss AOP/IGP lists, BauPG), Turkish / Albanian / Demeter / Delinat rules, and single-body EU directives
  (Low Voltage 2014/35/EU at ESTI). EN and SN EN product standards are text only (harmonised product standards
  under the CPR, not certification schemes).
- `industry` (V70 codes) is set only on lines without a scheme, from keyword rules on the text. Fallback
  `other_manufacturing`; a manual review of samples is recorded in the review file.
- `standard_refs`: ISO / IEC / EN / SN EN identifiers and EU regulation numbers found in the line, `;`-separated.
- Bodies: the register's phone, email, website and address (street, postal code, locality). Phone numbers are
  taken from the register or, when the register field is empty, from the directory header (Ecocert, S-Cert, Suva).
  `http://` websites become `https://`.
- Five bodies are the same legal entities as bodies of the management-system dataset `sas-switzerland`; their
  rows are copied from it exactly (SQS, SGS Société Générale de Surveillance SA, ProCert AG, Swiss Safety Center AG,
  KPMG AG), so the two datasets do not overwrite each other.
- Certificate numbers are `SCESp NNNN` and do not collide with the management-system `SCESm NNNN` numbers, so no
  suffix is needed.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-18 | 29 (5 reused from sas-switzerland, 24 new) | 29 | 1691 (185 with scheme, 1506 with industry only) |
