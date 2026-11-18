# COFRAC - ISO/IEC 17065

Source: https://tools.cofrac.fr/en/easysearch/

COFRAC easysearch, keyword "17065" (accreditations 5-xxxx), and each accreditation's technical annex `/annexes/sect5/<number>.pdf`. COFRAC gives no accreditation dates in the search result, so `issue_date` is the run date. Scraper `database/france/17065/scrape_fr_cofrac_17065.py`; converter `prepare_certifind_17065.py`.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`cofrac-france`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (116 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 1381
- boilerplate / header line: 14
- body with no importable scope line: 11
- not accredited (Terminated by the body): 11
- not accredited (Withdrawn): 4
- not accredited (Terminated as a result of a transfer of accreditation): 3

Reused body rows:

- 5-0012 LABORATOIRE NATIONAL DE METROLOGIE ET D'ESSAIS: reused (same country and name)
- 5-0018 SGS INTERNATIONAL CERTIFICATION SERVICES: reused (same country and name)
- 5-0030 AFNOR CERTIFICATION: reused (same country and name)
- 5-0051 BUREAU VERITAS CERTIFICATION FRANCE: reused (same country and name)
- 5-0069 LRQA France SAS: reused (same country and name)
- 5-0071 AFNOR CERTIFICATION: reused (same country and name)
- 5-0502 CONTROL UNION INSPECTIONS FRANCE: reused (same country and name)
- 5-0512 GLOBAL Certification (R): reused (same country and name)
- 5-0537 DEKRA CERTIFICATION: reused (same country and name)
- 5-0547 CNPP CERT: reused (same country and name)
- 5-0553 BUREAU VERITAS CERTIFICATION FRANCE: reused (same country and name)
- 5-0555 SGS INTERNATIONAL CERTIFICATION SERVICES: reused (same country and name)
- 5-0556 LABORATOIRE NATIONAL DE METROLOGIE ET D'ESSAIS: reused (same country and name)
- 5-0579 AB CERTIFICATION: reused (same country and name)
- 5-0587 APAVE CERTIFICATION: reused (same country and name)
- 5-0589 QUALIANOR CERTIFICATION: reused (same country and name)
- 5-0591 SOCOTEC CERTIFICATION FRANCE: reused (same country and name)
- 5-0592 DEKRA CERTIFICATION: reused (same country and name)
- 5-0617 QUALITIA CERTIFICATION: reused (same country and name)
- 5-0628 ATALIA Certification: reused (same country and name)
- 5-0638 CAPCERT: reused (same country and name)
- 5-0647 ACTIVCERT: reused (same country and name)
- 5-0670 EVOLVE: reused (same country and name)
- 5-0685 POLYCERT: reused (same country and name)
- 5-0692 ACURIA CERTIFICATION: reused (same country and name)
- 5-0696 BYCYB: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-18 | 107 | 107 | 1657 | 708 | 949 |
