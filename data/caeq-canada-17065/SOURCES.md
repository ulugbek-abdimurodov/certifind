# CAEQ (Canada) - ISO/IEC 17065

Source: CAEQ (Conseil des appellations réservées et des termes valorisants, Québec) register of accredited organizations, https://caeq.ca/accredited-organizations/, product certification bodies (ISO/IEC 17065). Scraped with `../database/canada/caeq-canada-17065/scrape_ca_caeq_17065.py` (`caeq_17065/caeq_17065_raw.json`, `scope_lines.csv`, and the saved page `caeq_register.html`). Converted with `prepare_certifind_17065.py` in the same folder; dropped lines, certificate-number fixes and new schemes are listed in `caeq_17065_review.md` there. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page; `proof_url` is the body's CAEQ attestation PDF ("Show certificate").

Extraction rules:
- One register card is one accreditation, `accreditation_standard` ISO/IEC 17065, `status` ACTIVE. `issue_date` is "Accreditation date". The register shows no expiry date.
- `certificate_number` is the "CAEQ certificate no.". Two numbers are shared by two cards each (AC-14-02: CCOF US / CCOF Mexico; AC-07-01: QAI US / NSF de México), so the country is appended, e.g. `AC-14-02 (Mexico)`. OneCert International and PACS have no CAEQ number on the register; their CFIA accreditation number (COR…) is used. CAEQ has no 17021-1 dataset, so there is no `(17065)` suffix.
- Bodies in all countries are included (Canada, United States, Mexico, India, Brazil, Argentina, Costa Rica). French country names from the register (Argentine, Mexique, Inde) are normalized to English. Phones are rewritten in international form, and only the first number is kept.
- `scopes.csv` has only its header row, because 17065 has no EA codes.

Annex types (one `product_scopes` line per entry; the register has no annex tables):
- **Appellation(s)**: "Organic" → `Canada Organic Regime (COR)`. Québec reserved designations (Acerum du Québec, Agneau de Charlevoix, Quebec Ice Cider, Quebec Icewine, Quebec Wine, Neuville Sweet Corn, Canadienne Cow Cheese, Farmstead Cheese) → `Québec Reserved Designations (CARTV)`.
- **Product categories**: COR categories (crop, livestock, processed, maple, grower group, …) → `Canada Organic Regime (COR)`. EU 2018/848 Art. 35(7) categories (a)-(g), for bodies with an EU-equivalence scope → `EU Organic Regulation (EU) 2018/848`.
- **Geographic scope**: these entries are countries, not products, so they are left out of `product_scopes` and listed per accreditation in the review.

New scheme codes: `Canada Organic Regime (COR)` and `Québec Reserved Designations (CARTV)`. Both are added in `V82__caeq_17065_reference_data.sql`, which also inserts the CAEQ AB row.

| Retrieved | Bodies | Accreditations | Product lines | Dropped lines |
| --- | --- | --- | --- | --- |
| 2026-11-19 | 20 | 20 | 175 | 114 |
