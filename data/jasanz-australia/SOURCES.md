# JASANZ (Australia / New Zealand)

Source: JASANZ register of accredited bodies, https://register.jasanz.org/accredited-bodies (public JSON API
`jasanzcupr-api.azurewebsites.net/api/V1/RegisterCertificate/`), management system certification bodies.
Scraped with `database/australia/database/australia/scrape_au_jasanz.py` (output `raw/jasanz_cabs.json`), converted
with `prepare_certifind.py` in the same folder; every skipped scheme or body is listed in `jasanz_review.md` there.
Not yet verified by a person, so `verified_at` is empty. `source_url` and `proof_url` are the register page.

## Extraction rules

- The JASANZ accreditation number (e.g. `M1900799IM`) is the base certificate number. `issue_date` is "Last
  Accreditation Issued", `expiry_date` is "Accreditation Expiry Date".
- Country, address and contacts come from each body's head-office location, so the dataset covers bodies in
  Australia, New Zealand, India, South Korea, China, Japan, Vietnam, Singapore, Malaysia, Mongolia, the United States,
  South Africa and the United Arab Emirates.
- Accreditation rows: ISO/IEC 27001 → ISO/IEC 27006 `(27006)`, ISO 50001 → ISO 50003 `(50003)`, ISO 22000 / FSSC 22000
  → ISO 22003-1 `(22000)`, ISO/IEC 20000-1 → ISO/IEC 20000-6 `(20000)`, ISO/IEC 42001 → ISO/IEC 42006 `(42001)`,
  ISO 55001 → ISO/IEC 17021-5 `(55001)`; everything else is under the ISO/IEC 17021-1 row, which every body has.
- JASANZ's "Artificial Intelligence Management System Scheme (AIMS Scheme)" is recorded as ISO/IEC 42001, and the
  "Asset Management Systems Scheme of Australasia" as ISO 55001.
- EA codes: register technical sectors (IAF codes) for ISO 9001/14001/45001; ISO 22000/FSSC food chain categories
  classified to EA; ISO 13485 technical areas classified to EA. ISO/IEC 27001, 20000-1, ISO 50001, ISO/IEC 42001 and
  ISO 55001 have no sector list in the register and are recorded for all EA sectors (1-39).
- "ISO/IEC 27001:2022 (DEWR)" is merged into the body's ISO/IEC 27001 entry.
- Bodies already in another dataset reuse that row: seven from `nabcb-india` (International Certification Services, Integrated Quality Certification, KBS, MS Certification Services, BSCIC, QUEST, Vexil) and Beijing Daluhangxing from
  `ukas-united-kingdom`.
- Phones are international. Australian 1300/1800 numbers cannot be dialled from abroad and were left empty.

## Left out

- National schemes: NDIS Approved Quality Auditors, Human Services Quality Framework, disability/employment programs,
  WANADA, Australian Community Industry, CodeMark, WaterMark, ANZEx, Australian Wood Packaging, Recognised Agency
  (NZ MPI), NZ Adventure Activities, NZ Farm Assurance, NZ Export Halal, organics schemes, Toitu carbon schemes,
  Free Trade Agreement Certificate of Origin, PrimeSafe, Civil Contractors Federation, Public Safety MS Scheme and others.
- Product, gas and electrical safety, and personnel certification schemes.
- Private food and farm schemes not in the `standards` table: SQF, GLOBALG.A.P., BRCGS, IFS, Freshcare, LEAF, FAMI-QS,
  HACCP International; also PEFC / Responsible Wood chain of custody, Forest Management, E-waste and SERI R2.
- 56 bodies hold only such schemes and are not in the dataset.

## Retrieved

| Register | Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- | --- |
| JASANZ | 2026-11-09 | 80 | 172 | 317 |
