# KENAS (Kenya)

Source: KENAS register of accredited CABs, https://kenas.go.ke/status, management system certification bodies (ISO/IEC 17021-1), with each body's schedule of accreditation PDF. Register scraped with `database/kenya/database/kenya/scrape_ke_kenas.py`. Converted with `database/kenya/prepare_certifind.py`. Skipped schemes are listed in `database/kenya/kenas_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page, and `proof_url` is the schedule PDF.

Extraction rules:
- The schedules are scanned images with no text layer, so their scopes were transcribed by hand into `SCOPES` in the converter.
- One KENAS registration is one ISO/IEC 17021-1 accreditation. Some standards get a separate suffixed row: ISO/IEC 27001/27701 → ISO/IEC 27006 `(27006)`, ISO 22000 → ISO 22003-1 `(22000)`, ISO 22301 → ISO/IEC 17021-6 `(22301)`. `issue_date` is empty because the register does not publish it. `expiry_date` comes from the register card.
- Sectors use the IAF codes printed in the schedules. ISO 22000 food category C → EA 3. ISO 13485 non-active devices → EA 13;14;17, and sterilization → EA 35 (ESYD tables).
- Every body is in Kenya. Global Standards Certification lists a US and a Kenyan phone number; only the Kenyan number is kept.

Not imported:
- SANS 10330 HACCP (KEBS): a South African national scheme that is not in the standards table.
- SafeCare health facility standards (PharmAccess Foundation, KENAS/Ms.CB/021): not in the standards table, so the body is dropped.
- 8 product (ISO/IEC 17065) and 3 personnel (ISO/IEC 17024) certification bodies.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_ke_kenas.py | 7 management-system registrations |
| 2026-11-10 | manual download + transcription | 7 schedule PDFs |
| 2026-11-10 | prepare_certifind.py | 6 bodies, 11 accreditations, 18 scope rows |
