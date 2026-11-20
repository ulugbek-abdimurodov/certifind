# KENAS - ISO/IEC 17065

Source: https://kenas.go.ke/status (register cards with category 'Certification Bodies, Product Certification', plus KENAS/CB/035 categorised 'Process Certification').

Scraper `database/kenya/kenas-kenya-17065/scrape_ke_kenas_17065.py` (register snapshot of 2026-11-20); converter `prepare_certifind_17065.py`. All 9 schedules are scanned images with no text layer and no OCR was available, so scope lines were transcribed by eye. Not verified by a person (`verified_at` empty).

Rules:

- One accreditation row per body, ISO/IEC 17065; `scopes.csv` header only. Certificate numbers are the KENAS ids (no collision with the MS dataset).
- Register entries CB/023 and CB/034 are the same body (KEBS Product Certification Body): CB/034 (ACAP Scheme D, agricultural crops) is merged as the last line of CB/023 (uq_cb_ab_standard allows one 17065 row per body).
- **KEBS (CB/023) is recorded per IAF code, not per standard**: 12 lines (IAF 1, 3, 4, 7, 10, 12, 14, 16, 17, 18, 19, 23) with the SM/DM scheme rule; the ~900 individual KS/KS EAS/IEC standards (pages 2-18) are NOT transcribed, except the two for IAF 1. Locations (regions) not recorded.
- ACAP (African Conformity Assessment Programme) schemes B and D, KS 1758, SM/DM mark, BBN scheme and the Inspectorate in-house process schemes are text only (no catalogue code; ACAP is not in `schemes`). Only GLOBALG.A.P. IFA (Key-Cert) has a scheme.
- ISO/IEC 17067 scheme type (5) not recorded.
- Bureau Veritas Certification Kenya Limited: body row reused from `kenas-kenya` (register name 'Bureau Veritas Kenya Limited'); the other 7 bodies are new.

Left out: nothing (all 9 register entries imported, as 8 bodies).

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 8 | 8 | 26 | 1 | 25 |
