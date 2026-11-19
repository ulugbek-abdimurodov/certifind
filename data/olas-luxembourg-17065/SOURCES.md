# OLAS (Luxembourg) - ISO/IEC 17065 product, process and service certification

Source: the ILNAS / OLAS register of accredited bodies,
https://portail-qualite.public.lu/fr/accreditation-notification/organismes-accredites/ (product certification, numbers 5/NNN,
ISO/IEC 17065): 3 bodies, each with an "Annexe technique" PDF in French. Scraped with
`../database/luxembourg/olas-luxembourg-17065/scrape_lu_olas_17065.py`, converted with `prepare_certifind_17065.py` in the
same folder. Not yet verified by a person, so `verified_at` is empty. `proof_url` is the annex PDF. The OLAS row comes
from the MS import; no new schemes.

Extraction rules:

- The annexes place their columns side by side ("Produits ou groupe de matériaux | Référentiels"), so their lines were
  transcribed by reading the PDFs, in `annex_transcription.csv` next to the converter. Text is verbatim; the "Domaine
  général / Domaine technique" headings go into `scheme_text`.
- **Luxcontrol (5/004):**
  - lifts, directive 2014/33/UE (Annexe V, VIII), as `Lifts Directive 2014/33/EU`;
  - pressure equipment, directive 2014/68/UE (modules A2, G), as `Pressure Equipment Directive 2014/68/EU`.
  - The Luxembourg implementing laws are kept in the text; the EU scheme wins.
- **SIGNA Audit (5/005):** organic production under Regulation (EU) 2018/848, one line per category (a, b, d, f), as
  `EU Organic Regulation (EU) 2018/848`.
- **SNCH (5/001):** EC and UNECE vehicle type approval, one line per vehicle category. There is no catalogue scheme
  (one body), so these lines are text with `transport_equipment`.
- One `ISO/IEC 17065` accreditation per body. The 5/NNN numbers don't collide with `olas-luxembourg`. Dates are from the
  register.
- **Left out:** annex boilerplate (title page, approval signatures, OLAS address footer, column headers).
- **Bodies.** All three are new. The register page gives no contact, so phone and e-mail are the annex's contact person.

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-19 | 3 | 3 | 9 (6 with a scheme) |
