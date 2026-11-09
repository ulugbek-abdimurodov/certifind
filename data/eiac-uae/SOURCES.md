# EIAC (United Arab Emirates)

Source: EIAC directory of accredited organizations, https://eiac.gov.ae/directory/, management system certification bodies (ISO/IEC 17021-1). Scraped with `database/uae/database/uae/scrape_ae_eiac.py` (browser-run; site not reachable from the build workspace), converted with `database/uae/database/uae/prepare_certifind.py`, then made CertiFind-compliant with `database/uae/finalize_certifind.py`; every skipped scheme is listed in `database/uae/eiac_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` is the directory page; `proof_url` is the certificate + scope PDF that was read.

Extraction rules:
- One EIAC registration per scheme (CB-QMS-007, CB-EMS-007, …) is one accreditation; `registration_no` of the body is the shared number (CB-007). `issue_date` / `expiry_date` are the "Validity: … to …" dates on the certificate; status is `expired` when the validity end has passed.
- Country, address, e-mail, website and phone come from the directory details page; missing or wrong countries were corrected (see review log). Foreign CABs (India, UK, Switzerland, South Africa, Somalia) are included.
- Accreditation standard per scheme as in the other datasets: ISO/IEC 27001 → ISO/IEC 27006, ISO 22000 → ISO 22003-1, ISO 22301 → ISO/IEC 17021-6.
- QMS/EMS/OHSMS/ISMS/BCMS annexes list IAF (EA) codes with NACE codes; the EA codes are taken from the IAF table rows. FSMS annexes list ISO 22003-1 categories, converted to EA with the common mapping.
- Registrations of one body under the same accreditation standard (CB-QMS-007, CB-EMS-007, …) are merged into the first one (uq_cb_ab_standard); merged rows keep the earliest issue and latest expiry date.
- Phones normalised to international form without trunk 0. BSCIC Certifications reuses the NABCB body row.
- Pruned: expired registrations (CB-QMS-093, CB-EMS-093, CB-QMS-103) and 13 bodies without an active ISO/IEC 17021-1 accreditation (12 food-only ISO 22000 CBs plus VRC and Conformity Certification Services).
- ISMS/QMS annexes without readable codes are recorded for EA 1-39.
- Not imported: HACCP, product certification (CB-PRD), ISO 41001 facility management (CB-FMMS).

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_ae_eiac.py | 190 registrations, 190 scope PDFs |
| 2026-11-09 | prepare_certifind.py | 56 bodies, 152 accreditations, 152 scope rows |
| 2026-11-09 | finalize_certifind.py | 43 bodies, 75 accreditations, 138 scope rows |
