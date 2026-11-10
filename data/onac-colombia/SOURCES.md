# ONAC (Colombia)

Source: ONAC Directorio Oficial de Acreditados (DOA), https://onac.org.co/directorio-de-acreditados/,
scheme "Certificación de Sistemas de Gestión (CSG)", plus each registration's scope certificate PDF
(`https://onac.org.co/certificados/<code>.pdf`, linked as `proof_url`).
Snapshot: `database/colombia/onac_raw.tsv` (scraper `database/colombia/database/colombia/scrape_co_onac.py`);
converter: `database/colombia/prepare_certifind.py`; review log: `database/colombia/onac_review.md`.
Not verified by a person, so `verified_at` is empty.

Extraction rules:
- One ONAC registration (e.g. 09-CSG-001) is the ISO/IEC 17021-1 row. Suffixed rows per the standard table:
  27001 → `(27006)`, 50001 → `(50003)`, 22000/FSSC → `(22000)`, 37001 → `(37001)`, 39001 → `(39001)`,
  55001 → `(55001)`. ISO 18788, 28000 and 28001 stay under the 17021-1 row.
- `issue_date` = "Fecha de publicación del otorgamiento", `expiry_date` = "Fecha de vencimiento".
- Sectors: IAF codes for 9001/14001/45001 ("todos" → 1-39); ISO 22003-1 categories → EA via the ESYD table;
  schemes with no sector list (27001, 50001, 37001, 39001, 55001, 18788, 28000, 28001) → EA 1-39 with a note.
- Country from each body's address (Colombia, India, Venezuela). Phones normalised to +57 with the 2021
  national numbering (Bogotá 601, Cali 602); old "(571)" / "(031)" Bogotá formats converted; extensions dropped.
- CMD Certification holds only ISO 37001, so its 17021-1 row has no scopes.

Left out:
- NTC 5555 (training institutions) and NTC 6001 (micro/small enterprises): Colombian national schemes.

Uncertain:
- International Certification Authority (India) lists a US phone number (+1 405 402 2373); kept as given.
- Footnote limitations in scope PDFs (e.g. sector 07 limited to pulp and paper) are not modelled.

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-10 | 22 | 43 | 85 |
