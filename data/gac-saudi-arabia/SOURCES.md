# GAC (GCC Accreditation Center)

Source: GAC register of accredited bodies, https://gac.org.sa/accredited-bodies/ (filter: Accredited, Management
System Certification). GAC is the accreditation body of the Gulf Cooperation Council; it is recorded with country
Saudi Arabia (gac.org.sa). Each body's `country` comes from its own register card.

Scraped with `database/bahrain/gac_certifind/database/gcc/scrape_gcc_gac.py` (scope PDFs parsed in-browser with
pdf.js, same logic) and converted with `prepare_certifind.py` in the same folder; review log `gac_review.md`.
Not yet verified by a person, so `verified_at` is empty. `source_url` is the register page; `proof_url` is the scope
PDF that was read.

## Extraction rules
- One GAC registration (MSC 0001 … MSC 0029) is one ISO/IEC 17021-1 accreditation. `issue_date` is the
  "Accreditation Certificate Issue Date" in the scope PDF, `expiry_date` is "Valid Until" on the register.
- ISO 22000 goes under its own ISO 22003-1 row (certificate suffix ` (22000)`); ISO 9001/14001/45001/13485 under
  ISO/IEC 17021-1.
- Sectors: IAF codes as listed for 9001/14001/45001; ISO 22000 categories classified to EA via ISO 22003-1
  (C, D → 3; E → 30; F → 29; G → 31; A, B → 1); ISO 13485 has no sector list → EA 1–39.
- MSC 0025 SGS Española de Control: ISO 9001 limited to IAF 35 for the OECD Free Trade Zone scheme (scope note).
- Phones normalised to international format; invalid ones left empty (see review log).

## Left out
- GPCA plastic pellets/flakes/powders scheme (not in the standards table): MSC 0015 DNV Business Assurance Dubai
  and MSC 0016 FAHSS, which hold nothing else.
- MSC 0018 United Quality Assurance Services LLC (Oman): ISO 22000 only, no ISO/IEC 17021-1 accreditation.

## Retrieved

| Date | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-09 | 20 | 24 | 64 |
