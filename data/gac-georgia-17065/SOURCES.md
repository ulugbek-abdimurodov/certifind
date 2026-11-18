# GAC (Georgia) - ISO/IEC 17065 product, process and service certification

Source: register of the Unified National Body of Accreditation - Accreditation Center (GAC), API
`https://gac.gov.ge/api/accredited-bodies?lang=en&bodyStatuses=ACTIVE`, filtered on evaluation standard ISO/IEC 17065
(certificates `GAC-PRC-*`). Captured with `../database/georgia/scrape_ge_gac_17065.py` (saved as `gac_17065_raw.json`),
converted with `prepare_certifind_17065.py` in the same folder; notes in `gac_17065_review.md` there.
AB code `GAC-GE`, added in `V76__gac_georgia_17065_reference_data.sql` (`GAC` is the GCC Accreditation Center).

Extraction rules:

- One `ISO/IEC 17065` accreditation per register entry; issue date = first grant; expiry not published (empty).
- `product_scopes.csv`: one row per numbered item of the register scope. When the Georgian and English lists have
  the same number of items, `product_text` is Georgian and `product_text_en` English; otherwise (GAC-PRC-0011,
  0021, 0022) `product_text` is the English item only, because the Georgian text still lists withdrawn items.
- No `scheme` codes: no standards or international schemes are named; Georgian technical regulations are national.
  Every line carries an `industry` (food, construction, metals, energy, other_manufacturing for tobacco).
- Nothing left out. No body exists in another dataset. `scopes.csv` is header only.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 5 | 5 | 23 (0 with a scheme) |
