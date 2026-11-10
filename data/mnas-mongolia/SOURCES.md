# MNAS (Mongolia)

Source: MNAS public register, https://e-accreditation.gov.mn/login (POST /ref/list, /ref/show), management system certification bodies (MNS ISO/IEC 17021-1). Scraper `database/mongolia/scrape_mn_mnas.py`; certificates are scanned PDFs, so the scope tables were transcribed into `database/mongolia/raw_mnas.json`. Converted with `database/mongolia/prepare_certifind.py`; review notes in `database/mongolia/mnas_review.md`. `verified_at` is empty. `source_url` is the register page; `proof_url` is the certificate PDF.

Extraction rules:
- One registration (MSC 01 … MSC 08) is one ISO/IEC 17021-1 accreditation; dates are the register's accredited / expiry dates.
- Separate rows: ISO/IEC 27001 → ISO/IEC 27006 `(27006)`, ISO 22000 → ISO 22003-1 `(22000)`, ISO 37001 → ISO/IEC 17021-9 `(37001)`.
- ISO 9001 / 14001 / 45001: IAF codes from the certificate. ISO 22000: categories classified to EA with the ESYD table. ISO/IEC 27001 and ISO 37001: no sector list, recorded for EA 1–39.
- Phones converted to +976 format; addresses translated from the Mongolian certificate header.

Left out: MSC 02 SFCS LLC (register status invalid, expired 2026-10-04); the mnas.gov.mn national product-certification list (not 17021-1 accreditations); an ISO 50001 accreditation mentioned only in an MNAS infographic.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_mn_mnas.py | 7 registrations, 7 certificate PDFs |
| 2026-11-09 | prepare_certifind.py | 6 bodies, 16 accreditations, 25 scope rows |
