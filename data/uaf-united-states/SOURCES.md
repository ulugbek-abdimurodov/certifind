# UAF (United States)

Source: UAF (United Accreditation Foundation) directory of accredited management system CABs (ISO/IEC 17021-1, programme "Management Systems"), https://www.uafaccreditation.org/, with each CAB's "Certificate and Schedule" PDF. Scraped with `../database/usa/uaf_certifind/database/united-states/scrape_us_uaf.py` (`raw/uaf.json`), converted with `../database/usa/uaf_certifind/prepare_certifind.py`; notes, skipped schemes and pruned rows are in `uaf_review.md` there. Not yet verified by a person, so `verified_at` is empty. `source_url` is the directory; `proof_url` is the certificate and schedule PDF.

Extraction rules:
- UAF gives each scheme its own accreditation number. Numbers that share an accreditation standard are merged into the first one (constraint `uq_cb_ab_standard`); suffixed rows use the first scheme number of that group plus the suffix. `issue_date` / `expiry_date` are the earliest "from" and latest "to" dates of the merged numbers.
- Accreditation standard per scheme as in the other datasets: ISO/IEC 27001/27701 → ISO/IEC 27006 (" (27006)"), ISO 50001 → ISO 50003 (" (50003)"), ISO 22000 → ISO 22003-1 (" (22000)"), ISO/IEC 20000-1 → ISO/IEC 20000-6 (" (20000)"), ISO 22301 → ISO/IEC 17021-6 (" (22301)"); ISO 9001, 14001, 45001, 13485 under ISO/IEC 17021-1.
- EA codes: ISO 9001 / 14001 / 45001 use the IAF codes in the schedule (three bodies' sector list could not be parsed for one standard and are recorded for EA 1-39). ISO 22000 food chain categories (ISO 22003-1) and ISO 13485 IAF MD 8 main technical areas are classified to EA with the ESYD tables. Other schemes have no sector list and are recorded for EA 1-39 with a note.
- ISO 21001, ISO 41001 and ISO 37301 appear on some certificates without their own number or dates; they are added as scopes (EA 1-39) under the body's ISO/IEC 17021-1 row.
- Country, address, website, email and phone from the directory profile. Phones rewritten to international form (national numbers given the body's country code, "+0..." trunk prefixes fixed); ZEPPY Certification's "+44790118441" is too short and is left empty.
- Bodies dropped (expired, or no ISO/IEC 17021-1 scope): A CUBE TIC LIMITED TRADING AS ACT & A CUBE (United Kingdom); Accorp Partners Cert Inc (United States); Active Business International FZE (United Arab Emirates); Certi-Trust Africa & Middle East (Morocco); GCAI Certification Services LLP (India); Zhongbiaotong International Certification (Shenzhen) Co., Ltd. (China). International Conformity Assessment services Inc has no parsable accreditation table and is dropped.
- Not included: ISO 37001, ISO/IEC 42001, ISO 55001, ISO 20121 - printed on certificates without accreditation number or dates, so their own accreditation rows (ISO/IEC 17021-9, 42006, 17021-5, 17021-4) cannot be built; "Safety Management Systems" (standard not named); product certification and GHG verification (not ISO/IEC 17021-1).

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-10 | 56 | 155 | 281 |
