# SANAS (South Africa)

Source: SANAS register of accredited CABs, https://www.sanas.co.za/Pages/index.aspx (Accredited Organisations → Certification Bodies). Scraped in the browser with `database/south africa/database/south-africa/scrape_za_sanas.py` (SharePoint REST + pdf.js) into `sanas_raw.txt`, converted with `database/south africa/prepare_certifind.py`; skipped schemes and merges are listed in `database/south africa/sanas_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page; `proof_url` is the scope PDF of the first merged facility.

Extraction rules:
- SANAS gives one facility number per scheme (C59a, C59b, …). Facilities of one body are merged into one accreditation per accreditation standard (constraint `uq_cb_ab_standard`), numbered with the body's lowest facility number plus the usual suffix; `issue_date` is the earliest initial accreditation date, `expiry_date` the latest expiry. `scope_note` names the source facility.
- Accreditation standard per scheme: ISO/IEC 27001 → ISO/IEC 27006, ISO 50001 → ISO 50003, ISO 22000 / FSSC 22000 → ISO 22003-1; ISO 9001, 14001, 45001, 13485, 3834 under ISO/IEC 17021-1.
- Sectors: IAF codes for 9001/14001/45001; ISO 22003-1 categories and IAF MD 8 technical areas classified to EA with the ESYD tables; schedules without a sector list (ISO 3834, ISO/IEC 27001, ISO 50001, some ISO 22000 / 13485) recorded for all EA 1-39 with a note.
- Address, phone and e-mail from the "Legal Entity (Published)" list; phones converted to +27 / +256. Websites are not published.
- Bodies reused from other datasets: SABS Commercial SOC Ltd. (rva-netherlands), Sheq National Cert International (PTY) LTD (eiac-uae). Register name typos merged into one body each.
- Not imported: HACCP (SANS 10330) and SANS 1395-1 RTMS (national schemes), RBI/RIMAP, ISO 55001 (C100d), ISO/IEC 17065 / 17024 / 14065 accreditations, withdrawn facilities, and General Food Safety Company (Pty) Ltd (ISO 22000 only, no ISO/IEC 17021-1 scheme).

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-10 | scrape_za_sanas.py | 150 registrations, 110 scope PDFs |
| 2026-11-10 | prepare_certifind.py | 31 bodies, 44 accreditations, 96 scope rows |
