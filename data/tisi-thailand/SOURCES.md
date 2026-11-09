# TISI (Thailand)

Source: TISI register of accredited certification bodies, https://center.tisi.go.th/report/certificate?sort=CB
(management system certification bodies, ISO/IEC 17021-1 / TIS 17021-1-2559). Scraped with
`database/thailand/v3/scrape_th_tisi.py` (collected via the browser, as tisi.go.th was unreachable from the
workspace), converted with `database/thailand/prepare_certifind.py`. Every skipped or merged registration is
logged in `database/thailand/tisi_review.md`. Not verified by a person, so `verified_at` is empty.
`source_url` and `proof_url` are the register page.

Extraction rules:
- TISI numbers QMS → ISO 9001, EMS → ISO 14001, OHS/OHSMS → ISO 45001, EnMS → ISO 50001.
- ISO 50001 goes under its own ISO 50003 row (`EnMS 00x (50003)`); everything else under one ISO/IEC 17021-1
  row per body (`uq_cb_ab_standard`). That row keeps the body's first registration number and dates, and later
  registrations are merged into it.
- `issue_date` / `expiry_date` are the scope validity dates on the English detail page (where the register gives none,
  `issue_date` is 1 January of the TISI certificate-number year, e.g. 22-CB0009 → 2022-01-01, and `expiry_date` is empty).
- Scope annexes are scanned PDFs with no sector list, so every scope is recorded for EA 1-39 with a note.
- Phones converted to +66 international format. All bodies are in Thailand.

Left out:
- SFMS 001 (MASCI): not in the standards table.
- GHG, TLS 8001 Thai Labour Standard (national scheme), product, personnel and tourism schemes; all IB and LAB rows.
- TUV NORD 22-CB0024 / 22-CB0025: superseded by 26-CB0008 / 26-CB0009.
- MASCI OHSMS 001 (23-CB0013): scope expired 2023-08-18 (MASCI keeps ISO 45001 through OHS 001).

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_th_tisi.py | 23 MS registrations |
| 2026-11-09 | prepare_certifind.py | 8 bodies, 10 accreditations, 19 scope rows |
