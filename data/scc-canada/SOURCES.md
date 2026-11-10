# SCC (Canada)

Source: SCC (Standards Council of Canada) register of accredited organizations, https://scc-ccn.ca/search/accredited-organizations?f[0]=program:496, Management Systems Accreditation Program (MSAP, ISO/IEC 17021-1). Profiles scraped with `../database/canada/scrape_ca_scc.py` (`scc_raw.tsv`); each profile's Scope of Accreditation PDF downloaded to `scc_pdfs/` and read as text (`scc_txt/`). Converted with `../database/canada/prepare_certifind.py`; skipped schemes, dropped bodies and phone fixes are listed in `scc_review.md` there. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register profile; `proof_url` is the Scope of Accreditation PDF.

Extraction rules:
- One SCC file number (8002–8091) is one accreditation. `issue_date` is "Initial Accreditation Date", `expiry_date` is "Expires on".
- Standards and sectors come from the scope PDF, not from the register's "specialty areas", which miss some programs (BNQ: ISO 45001, ISO 50001, ISO 22301; Intercert: ISO 45001, ISO 50001, ISO 37001, ISO/IEC 27001). Each PDF section starts at "Base program: … (CODE)" and names its certification standard. LMS Certifications' EMS section has no standard line; taken as ISO 14001 from the base program.
- Accreditation standard per scheme as in the other datasets: ISO/IEC 27001 → ISO/IEC 27006 (suffix " (27006)"), ISO 50001 → ISO 50003 (" (50003)"), ISO/IEC 20000-1 → ISO/IEC 20000-6 (" (20000)"), ISO/IEC 42001 → ISO/IEC 42006 (" (42001)"), ISO 22301 → ISO/IEC 17021-6 (" (22301)"), ISO 37001 → ISO/IEC 17021-9 (" (37001)"), AS9100 → AS 9104-1 (" (9104)"); ISO 9001, 14001, 45001, 13485 → ISO/IEC 17021-1.
- EA codes: ISO 9001 / 14001 / 45001 list IAF codes directly. ISO 13485 main technical areas (IAF MD 8) are classified to EA with the common table. All other standards, including ISO 50001 (SCC lists no technical areas), have no sector list and are recorded for all EA sectors 1-39 with a note.
- Scopes marked "**" (granted with conditions / pending verification by SCC) are included as active.
- Country, address, website, phone and email from the profile "Contact Data"; bodies in all countries are included (Canada, United States, China, Germany, India, Ireland, Taiwan, United Arab Emirates). Phones rewritten to international form; extensions dropped. QFS Management Systems' number is published as "+1 919716006477" and was corrected to +91 97160 06477.
- Bodies already in another dataset reuse that body row: DQS Medizinprodukte GmbH (`dakks-germany`), KVQA Certification Services PVT. LTD. (`eiac-uae`), Metal Industries Research & Development Centre (`taf-taiwan`), NSAI (`inab-ireland`).
- Bodies without an ISO/IEC 17021-1 scope are dropped: 1415045 Ontario Inc. Cyber Security Canada (8060), Complade Canada Inc. (8078), Gaming Laboratories International, LLC (8062), MHM Advisory Ltd. (8074) - ISO/IEC 27001 / 27701 / 42001 only - and Preferred By Nature OÜ (8058), forestry only.
- Not included: CyberSecure Canada (CAN/CIOSC 104 / CAN/DGSI 104), Sustainable Forest Management schemes (SFI 2022, PEFC Canada PEFC CAN ST 1001, ATFS) - national schemes; AS9120 - not in the standards table.

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-10 | 17 | 34 | 57 |
