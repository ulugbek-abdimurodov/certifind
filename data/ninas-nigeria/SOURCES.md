# NiNAS (Nigeria)

Source: NiNAS register of accredited management system certification bodies, https://ninas.ng/accreditation/accredited-management-system-bodies/ (ISO/IEC 17021-1). Scraped with `database/nigeria/scrape_ng_ninas.py`, converted with `database/nigeria/prepare_certifind.py`; notes in `database/nigeria/ninas_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page; `proof_url` is the accreditation certificate and schedule PDF.

Extraction rules:
- Contacts from the register; certificate numbers ("No. MSC000x"), issue and expiry dates and scopes from each certificate/schedule PDF.
- IAF codes equal EA codes. ISO 22000 categories mapped to EA via ISO 22003-1 (C, D → 3; E → 30; I → 7;14).
- Country is the body's home country (WSR Certification is in India).
- Phones normalised to international format (Nigerian local 0xxx numbers prefixed +234).
- Standard suffixing: ISO/IEC 27001 → (27006), ISO 22000 → (22000).

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-20 | scrape_ng_ninas.py | 5 register rows, 5 schedule PDFs |
| 2026-11-20 | prepare_certifind.py | 5 bodies, 9 accreditations, 17 scope rows |
