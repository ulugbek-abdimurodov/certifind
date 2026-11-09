# JSM (Malaysia)

Source: Department of Standards Malaysia (JSM), Scheme for the Accreditation of Certification
Bodies (ACB) register, https://cab.jsm.gov.my/cab-directories/resultAcb: one row per body and
programme (status ACCREDITED), and each body's accreditation schedule PDF
(`https://cab.jsm.gov.my/documents/11396/300427/ACB00xx`). Scraped with
`database/malaysia/jsm_certifind/database/malaysia/scrape_my_jsm.py`, converted with
`database/malaysia/prepare_certifind.py`; every skipped programme is listed in
`database/malaysia/jsm_review.md`. Not yet verified by a person, so `verified_at` is empty.
`source_url` is the register search page; `proof_url` is the schedule PDF that was read.

Extraction rules:

- One ACB registration (ACB001, ACB002, ...) is one accreditation under ISO/IEC 17021-1.
  `issue_date` / `expiry_date` are the schedule's "Issue date" / "Valid until" (current issue).
- Each schedule page names its programme and certification criteria. The criteria standard decides
  the programme (AJA EQS ACB008 labels its ISO 14001 page "(QMS)"); continuation pages without a
  heading belong to the previous programme.
- Accreditation standard per scheme as in the other datasets: ISO/IEC 27001 → ISO/IEC 27006,
  ISO 50001 → ISO 50003, ISO 22000 → ISO 22003-1, ISO 22301 → ISO/IEC 17021-6, ISO 37001 →
  ISO/IEC 17021-9, ISO 39001 → ISO/IEC 17021-7 (suffixed rows such as `ACB001 (27006)`).
  ISO 9001 / 14001 / 45001 / 13485 are under the plain registration row.
- Sectors: ISO 9001 / 14001 / 45001 — the IAF codes listed. ISO 22301, 37001, 39001 — the IAF codes
  listed when the schedule gives them. ISO/IEC 27001 has no sector list and is recorded for all EA
  sectors. ISO 22000: ISO 22003-1 categories; ISO 50001: ISO 50003 technical areas; ISO 13485:
  IAF MD 8 main technical areas, all classified to EA with the ESYD tables. Two editions of one
  standard (ISO 14001:2015 and :2026) are one standard with the codes combined.
- Codes listed under "SUBJECT TO WITNESS" are not yet accredited and are left out (BRS ACB069,
  KEYN ACB065, MY CO2 ACB039, MGV ACB068, Leader ACB072). Struck-through text and the rotated
  "scan this QR code" watermark are dropped.
- Two registrations of one company (SGS ACB004 + ACB035, CyberSecurity Malaysia ACB021 + ACB075)
  would be one body; the second registrations hold only product / persons programmes, so nothing
  is merged.
- SIRIM QAS International (ACB001) is already in `ukas-united-kingdom`; that dataset's body row is used.
- Phones are made international (`603-5544 6430` → `+60 3 5544 6430`). `address` is the register
  address up to the state (the register appends the website and contact person).
- Not imported: MSPO and MSPO supply chain, HACCP (MS 1480), GMP (MS 1514), forest management
  (MC&I / MTCS), PEFC chain of custody (national or not in CertiFind); ISO 21101 ATSMS and FAMI-QS
  (not in the standards table); product certification (ISO/IEC 17065) and certification of persons
  (ISO/IEC 17024). 34 registrations hold only such programmes and are left out. UGG Certification
  ACB059 was dropped by `prune_inactive` (schedule expired 2026-10-05). Control Union ACB031 is
  listed for EMS in the register but its schedule has no ISO 14001 page.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-09 | scrape_my_jsm.py | 71 registrations, 227 programme rows, 77 schedule PDFs |
| 2026-11-09 | prepare_certifind.py + prune_inactive.py | 36 bodies, 68 accreditations, 113 scope rows |
