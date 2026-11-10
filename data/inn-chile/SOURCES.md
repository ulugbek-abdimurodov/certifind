# INN (Chile)

Source: INN register of accredited management system certification bodies, https://directorio.inn.cl/
(scheme "Organismos de Certificación de Sistemas"), plus each registration's certificate + scope annex PDF
(`https://directorio.inn.cl/Directorio/DisplayPDF/<token>`, linked as `proof_url`).
Register snapshot: `database/chile/database/chile/inn_raw.tsv` (scraper `scrape_cl_inn.py`), PDFs in `pdf/`;
converter: `database/chile/prepare_certifind.py`. Not verified by a person, so `verified_at` is empty.

Extraction rules:
- INN issues one registration per scheme (SC quality, SGA environment, SGR OHS, SGC ISMS, SGE energy).
  9001/14001/45001 are merged under one ISO/IEC 17021-1 row numbered with the body's first registration;
  each scope row's note keeps the original INN number. ISO/IEC 27001 -> `SGC xxx (27006)`,
  ISO 50001 -> `SGE xxx (50003)`.
- Sectors: IAF sector numbers from the annex tables. ISO 50001: ISO 50003 areas classified to EA with the ESYD table.
- Address from the certificate ("ubicado en ..."); phones normalised to +56 (pre-2013 8-digit Santiago numbers
  given the 22 prefix). AENOR CONFIA (Madrid address) reuses the enac-spain body row.
- Only "Vigente" registrations with a future expiry.

Left out:
- NCh 2728 (training providers), NCh 3262 (gender equality), CERTFOR-Chile forestry: Chilean national schemes.
- HACCP: not in the standards table.
- ICONTEC, Instituto Argentino de Normalización y Certificación (IRAM), LSQA S.A.: only the schemes above.

| Retrieved | Bodies | Accreditations | Scope rows |
| --- | --- | --- | --- |
| 2026-11-10 | 10 | 13 | 24 |
