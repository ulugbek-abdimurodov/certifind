# ALGERAC (Algeria) - ISO/IEC 17065 product certification

Source: ALGERAC (Organisme Algérien d'Accréditation) "Certificat et Annexe Technique" PDF for product
certification bodies, file group 3-2: `Certificat_NORMISO_3_2_001_Rev00_22_06_2025_sw_Annexe_Technique_Rev00_22_06_2025_sw.pdf`,
saved in `database/algeria/17065`. Page 1 is a scanned certificate (read by eye); the annex pages are text.
The PDF's download URL was not recorded, so `proof_url` is the ALGERAC home page.

Transcribed by hand (one body, two annex lines). Not yet verified by a person, so `verified_at` is empty.

Rules:

- `issue_date` / `expiry_date`: "Date de prise d'effet" 22/06/2025 and "Date de fin de validité" 21/06/2028.
- Address from the certificate. Phone "0661 54 22 52" written as +213 661 54 22 52; fax and contact name left out.
- One product_scopes line per annex table row (Rond à béton, Laminés marchands), product prefixed with the
  family "Sidérurgiques". Schemes column -> `scheme_text`, technical specifications -> `normative_docs`.
- Laminés marchands cites EU 305/2011 -> scheme `Construction Products Regulation (EU) 305/2011`.
- Rond à béton cites ISO 10144 and an Algerian interministerial order (national) -> no scheme, industry `metals`.
- ISO/IEC 17067 scheme type (5) left out (no column).
- Separate dataset from `algerac-algeria` (management systems); certificate numbers do not collide (3-2 vs 3-1).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 1 | 1 | 2 |
