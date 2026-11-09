# SLAB (Sri Lanka)

Source: SLAB register of accredited operators, https://www.slab.lk/directory (scheme "Certification
bodies – System", status Active) and each registration's "Schedule of Accreditation" PDF. Scraped with
`database/sri-lanka/database/sri_lanka/scrape_lk_slab.py`, converted with
`database/sri-lanka/prepare_certifind.py`; notes in `database/sri-lanka/slab_review.md`. Not yet
verified by a person, so `verified_at` is empty. `source_url` is the registry profile; `proof_url` is
the schedule PDF that was read.

Extraction rules:

- Programmes: QMS → ISO 9001, EMS → ISO 14001, OHS → ISO 45001, FMS → ISO 22000, ENS → ISO 50001,
  IMS → ISO/IEC 27001 (confirmed by each schedule's "Scope of Accreditation" line).
- Each body's QMS/EMS/OHS registrations are one ISO/IEC 17021-1 accreditation under its first
  registration number (QMS where present), with that registration's dates. ISO 22000 → ISO 22003-1
  `(22000)`, ISO 50001 → ISO 50003 `(50003)`, ISO/IEC 27001 → ISO/IEC 27006 `(27006)`. Food-only
  bodies (SGS Lanka, Knowledge Mag) get an ISO/IEC 17021-1 row with their FMS number.
- Sectors: IAF codes for 9001/14001/45001, transcribed from the schedules (IAF cells span several
  NACE rows, so they were read by hand). ISO 22000: ISO 22003-1 categories, ISO 50001: ISO 50003
  areas, both mapped to EA with the ESYD tables. ISO/IEC 27001 has no sector list → EA 1–39.
- Addresses from the schedules; SLAB publishes no phone or e-mail. Country: Sri Lanka for all.

Left out:

- HACCP against SLS 1266 (Sri Lankan national standard) on the FMS schedules.
- Suspended, withdrawn or expired registrations.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_lk_slab.py (browser capture) | 27 active registrations, 8 bodies |
| 2026-11-09 | curl + pdfplumber | 27 schedule PDFs |
| 2026-11-09 | prepare_certifind.py | 8 bodies, 19 accreditations, 27 scope rows |
