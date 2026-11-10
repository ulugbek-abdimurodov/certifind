# SAAC (Saudi Arabia)

Source: SAAC register of accredited CABs, service type "Management Systems Certificates"
(https://saac.gov.sa/en/accredited-cabs/?searchType=AdvancedSearch&serviceSearch=Management+Systems+Certificates).
Scraped with `database/saudi-arabia/database/saudi-arabia/scrape_sa_saac.py` (output `saac_raw.txt`), converted with
`database/saudi-arabia/prepare_certifind.py`; review notes in `database/saudi-arabia/saac_review.md`.
Not yet verified by a person, so `verified_at` is empty. `proof_url` is the SAAC registration page (SAAC publishes
HTML scope tables, no PDFs).

Extraction rules:
- SAAC numbers each registration per scheme (N-QMS-00001, N-FSMS-00035...). Per body, the active registrations are
  merged: the first ISO/IEC 17021-1 scheme registration (QMS, EMS, OHS, MDMS) gives the ISO/IEC 17021-1 row and its
  number/dates; ISO 22000 → ISO 22003-1 `(22000)`, ISO 50001 → ISO 50003 `(50003)`, ISO/IEC 27001 → ISO/IEC 27006
  `(27006)`, ISO 22301 → ISO/IEC 17021-6 `(22301)` rows with their own numbers and dates. Bodies with only such
  schemes keep a bare ISO/IEC 17021-1 row (numbered after their first registration).
- Sectors: ISO 9001/14001/45001 from the register's IAF code column; ISO 22000 food chain categories and ISO 13485
  IAF MD 8 main technical areas classified to EA with the ESYD tables; ISO 50001, ISO/IEC 27001 and ISO 22301 have
  no sector list → EA 1–39.
- Register spellings of one company merged (ACC ×4, TUV Limited ×3, SGS, QSI, Intertek Arabia, Optimal, SMG,
  TUV Austria, FAHSS, Pioneers, Meyar Arabic / miyar alarabiyya). The two University of Tabuk departments and
  Intertek Arabia Administrative / Intertek Saudi Arabia Limited are kept separate.
- All bodies are in Saudi Arabia (address = city only). Phones normalised to +966 (ISO Cert International: +44).
- Already in other datasets, their body row reused: Next Generations Company Limited and Pioneers of Quality Systems
  and Certifications KSA (egac-egypt), Takeed Al-Jawda Administrative Company (gac-saudi-arabia).

Not imported: no schemes skipped; 5 cancelled (QTC, Quality Techno Certification, which drops out entirely) and
8 expired registrations.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_sa_saac.py | 51 register body spellings, 124 registrations |
| 2026-11-09 | prepare_certifind.py | 34 bodies, 78 accreditations, 112 scope rows |
