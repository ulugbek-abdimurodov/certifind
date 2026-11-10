# EMA (Mexico)

Source: EMA (Entidad Mexicana de Acreditación) register of accredited certification bodies, https://catalogo.consultaema.mx:75/busqueda-organismos-certificacion ("Mostrar todos"), management system certification bodies (ISO/IEC 17021-1). Scraped with `../database/mexico/database/mexico/scrape_mx_ema.py` (export `raw/ema_register.txt`), converted with `../database/mexico/prepare_certifind.py`; notes, skipped scheme codes and pruned rows are in `../database/mexico/ema_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` and `proof_url` are the register page (EMA publishes no scope PDFs there).

Extraction rules:
- EMA scheme codes → standards: SGC → ISO 9001, SGA → ISO 14001, SASST/SGSST → ISO 45001, SGSI → ISO/IEC 27001, SGTI → ISO/IEC 20000-1, SGCN → ISO 22301, SGIA → ISO 22000, SGDM → ISO 13485, SGE → ISO 50001, SGAS → ISO 37001, SGCM → ISO 37301, SGOE → ISO 21001, SGS → ISO 28000, SGSP → ISO 18788, SGSV → ISO 39001, MSAI → ISO/IEC 42001.
- EMA issues a separate registration number per scheme or extension (e.g. 131/21 and SGC-131/26). All registrations of one body are merged into its earliest-issued one (constraint `uq_cb_ab_standard`); the scope note lists the original EMA numbers. `issue_date` is the earliest start date; `expiry_date` comes from the client record where one exists (otherwise empty).
- Accreditation standard per scheme as in the other datasets: ISO/IEC 27001 → ISO/IEC 27006 (" (27006)"), ISO 50001 → ISO 50003 (" (50003)"), ISO 22000 → ISO 22003-1 (" (22000)"), ISO/IEC 20000-1 → ISO/IEC 20000-6 (" (20000)"), ISO/IEC 42001 → ISO/IEC 42006 (" (42001)"), ISO 22301 → ISO/IEC 17021-6 (" (22301)"), ISO 37001 → ISO/IEC 17021-9 (" (37001)"), ISO 39001 → ISO/IEC 17021-7 (" (39001)"); everything else under ISO/IEC 17021-1.
- EA codes: the register lists no IAF/EA sectors, so every scope is recorded for EA 1-39 with a note.
- Address, email and website come from the client record, which the register shows for only 14 bodies; others have no contact data. No phone numbers are published. Country is Mexico unless the address or name says otherwise: United States (ABS Quality Evaluations, BSI Group America, American Registrar of Management Systems, Perry Johnson Registrars), Bolivia (IBNORCA), Dominican Republic (INDOCAL).
- Bodies already in another dataset reuse that body row: EQA GROUP S.A. DE C.V. (`sae-ecuador`), Perry Johnson Registrars, Inc. (`jab-japan`).
- Dropped: FWC CERTIFICACION EN LA INDUSTRIA DE ALIMENTOS (ISO 22000 only, no ISO/IEC 17021-1 scope) and CERTIFICADORA POR UNA INDUSTRIA GRÁFICA SUSTENTABLE S.C. (only scheme SGBG, unidentified).
- Not included: scheme codes the register does not name and that cannot be matched to the standards table (SGAC, SGBG, SGCD, SGES, SGOS, SGPG, SGPI, SGRH, SMSC); product (17065), persons (17024) and validation/verification (17029) programmes.

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-10 | 100 | 250 | 450 |
