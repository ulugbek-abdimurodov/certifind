# TAF (Taiwan)

Source: TAF register of accredited bodies, https://www.taftw.org.tw/en/find-facility/scheme/msv/
(management system certification bodies, ISO/IEC 17021-1), and each body's scope page
`https://accreditation.taftw.org.tw/taf/public/basic/viewApplyItems.action?unitNo=<ID>&language=EN`.
Scraped with `database/taiwan/scrape_tw_taf.py` (output `database/taiwan/raw/msv_*.txt`), converted
with `database/taiwan/prepare_certifind.py`; every skipped scheme is listed in
`database/taiwan/taf_review.md`. Not yet verified by a person, so `verified_at` is empty.
`source_url` is the register page; `proof_url` is the scope page that was read.

Extraction rules:

- One TAF registration (MS001, MS003, ...) is one accreditation under ISO/IEC 17021-1.
  `issue_date` is the original accreditation date, `expiry_date` the current certificate's expiry.
- TAF scheme codes: 01 ISO 9001, 02 ISO 14001, 0301 ISO 45001, 0401 ISO 22000, 0501 ISO/IEC 27001,
  06xx ISO 50001 (ISO 50003 technical areas), 07 ISO 46001.
- Accreditation standard per scheme: ISO/IEC 27001 → ISO/IEC 27006, ISO 50001 → ISO 50003,
  ISO 22000 → ISO 22003-1 (suffixed rows such as `MS001 (27006)`); the rest under the plain row.
- Sectors: ISO 9001 / 14001 / 45001 use the IAF codes listed; IAF codes marked suspended are
  dropped and noted. ISO 22000 categories and ISO 50003 technical areas are classified to EA with
  the ESYD tables. ISO/IEC 27001 and ISO 46001 have no sector list and are recorded for EA 1–39.
- Phones converted to international format (+886); extensions and second numbers dropped.
- ARES International Certification (MS017) is already in `ukas-united-kingdom`; that body row is reused.

Not imported:

- Taiwan national schemes: TOSHMS (code 0302) and the Cyber Security Management Act scheme (0502).
- Bodies with no ISO/IEC 17021-1 row after filtering (pruned): TCIC (MS013), AITaiwan (MS034),
  GQA (MS035) — ISO/IEC 27001 only; FIRDI (MS015), China Grain Products R&D Institute (MS018),
  National Animal Industry Foundation (MS026), Taiwan Premium Agricultural Products Development
  Institute (MS027) — ISO 22000 only.

| Retrieved | Bodies in register | Bodies imported |
| --- | --- | --- |
| 2026-11-09 | 23 | 16 |
