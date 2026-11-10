# SAE (Ecuador)

Source: SAE (Servicio de Acreditación Ecuatoriano) public register of accredited conformity assessment bodies, https://sistema.acreditacion.gob.ec/accreditations/scopes-public, area CERTIFICACIÓN, management system activities (ISO/IEC 17021-1). Data read from the register's JSON endpoints (`/accreditations/get-oec/<activity>` and `/qualityMng/updateInformations/scopes_active`). Scraped with `../database/ecuador/database/ecuador/scrape_ec_sae.py`, converted with `prepare_certifind.py` in the same folder; skipped schemes, merges and pruned bodies are listed in `sae_review.md` there. Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page; `proof_url` is the latest signed accreditation resolution PDF (register page when none is published).

Extraction rules:
- One SAE accreditation number (SAE CSC 09-002, SAE CSA 18-001, SAE CSIA 10-003, SAE CSDM 23-001, SAE CSST 26-001) is one accreditation. `issue_date` is the initial accreditation date (`acc_init_date`, else last resolution date); SAE publishes no expiry date, so `expiry_date` is empty.
- Body contact data (phone, email, web, address, city, country) from the organization record; country translated to English. Bodies are not limited to Ecuador (Colombia, Mexico, India, Peru also present).
- EA codes: QMS/EMS/OH&S scopes list IAF sectors directly. ISO 22000 / FSSC 22000 food chain categories mapped via ISO 22003-1 → EA; ISO 13485 technical areas (IAF MD 8) mapped via the common MD8 table.
- Accreditation standard per scheme as in the other datasets: ISO 22000 / FSSC 22000 → ISO 22003-1 (suffix " (22000)"), ISO 37001 (NTE INEN ISO 37001) → ISO/IEC 17021-9 (suffix " (37001)"), others → ISO/IEC 17021-1.
- ISO 37001 has no sector list in the SAE register; recorded for all EA sectors 1-39.
- One accreditation per body and accreditation standard (`uq_cb_ab_standard`): a body's separate SAE numbers for 9001/14001/45001/13485 are merged into its first number (CERGESTCAL CSC 09-001 → CSA 18-001, ICONTEC CSDM 23-001 → CSC 10-003, CICAYBECE CSDM 25-001 → CSC 14-001, TNV CSST 26-001 → CSC 26-001).
- ICONTEC and KIWA CQR reuse their `onac-colombia` body rows.
- Bodies without an ISO/IEC 17021-1 accreditation are dropped: AENOR CONFÍA (Spain) and LENOR (Argentina), which SAE accredits only for ISO 37001.
- Not included: HACCP (Codex, FOOD KNOWLEDGE FK; not in the standards table), persons (ISO/IEC 17024) and product (ISO/IEC 17065) certification. No body holds ISO 50001 accreditation.
