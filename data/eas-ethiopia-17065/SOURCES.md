# EAS (Ethiopia) - ISO/IEC 17065 product certification

- Register: https://eas-eth.org/certification-bodies/ (rows whose Disciplines mention 17065, certificate no. CPr####)
- Scraper: `database/ethiopia/eas-ethiopia-17065/scrape_et_eas_17065.py`; converter: `prepare_certifind_17065.py`
- Annex PDFs are scans without a text layer: pages were rendered and transcribed by hand into `annex_transcription.csv`
  (verbatim, bullets joined with "; "). Issue/expiry dates are from the accreditation certificates.
- All annex lines are Ethiopian national schemes (CES / ES standards): imported as text with `industry`, no `scheme`.
- Certificate numbers CPr0001 / CPr0002 (no collision with the MS dataset `eas-ethiopia`).
- ECAE body row reused exactly from `data/eas-ethiopia/bodies.csv`.
- Left out: nothing (annex titles and signatures only).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-20 | 2 | 2 | 17 |
