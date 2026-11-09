# O'ZAK (Uzbekistan)

Source: register of the Uzbekistan Accreditation Centre (O'zbekiston akkreditatsiya markazi,
O'ZAK), https://akkred.uz/uz/reestr?type_std=20, list of management-system certification bodies
accredited to O'z DSt ISO/IEC 17021-1, with each body's register fields (Uzbek) and the PDFs
linked from its entry: the accreditation certificate (a scan, no scope) and the scope annex
("Akkreditatsiyadan o'tkazish sohasi", text PDF, tables in Russian). Generated with
`database/uzbekistan/accred_uz_management_bodies.py` and `database/uzbekistan/prepare_certifind.py`;
the parser's open points are in `database/uzbekistan/ozak_review.md`. Not yet verified by a
person, so `verified_at` is empty. The register has no stable page per body, so `source_url` is
the register page and `proof_url` the body's annex PDF.

Extraction rules:

- One register entry is one O'ZAK registration (`O'ZAK.MT.0001` …). AB code `OZAK` (the
  apostrophe is dropped from the code). Standards with their own scheme get their own
  accreditation row: ISO 22000 → ISO 22003-1 (`… (22000)`), ISO 50001 → ISO 50003
  (`… (50003)`), ISO/IEC 27001 → ISO/IEC 27006 (`… (27006)`), ISO 37001 → ISO/IEC 17021-9
  (`… (37001)`). Every body keeps its ISO/IEC 17021-1 row.
- Each annex page names one certification standard in its header ("Sertifikatlash standarti:
  O'z DSt ISO 9001:2015"); national editions (O'z DSt, O'z MSt) are recorded as the ISO standard.
- ISO 9001 / 14001 / 45001 tables list IAF codes, taken as EA codes. Codes printed as `MT.28`
  (O'ZAK.MT.0041) or `31**` (O'ZAK.MT.0022, footnote marker without a footnote) are read as the
  number. Rows with coverage "Неполный" (partial) list excluded activities; the scope note names
  these sectors as partial ("Partial scope (some activities excluded) for EA …"); the excluded
  activities are listed in the review file.
- ISO 22000 tables list ISO 22003-1 food chain categories, ISO 50001 tables ISO 50003 technical
  areas by Russian name, ISO 13485 tables IAF MD 9 technical area codes (A1 … G5, the letter is
  the main area). All three are classified to EA with the ESYD tables; the scope note names them.
  "Энергосбережение" (energy saving, O'ZAK.MT.0010) is read as energy supply (H).
- ISO/IEC 27001 and ISO 37001 have no sector list in the annex and are recorded for all EA
  sectors (1-39).
- No national schemes or directive modules appear in the annexes; nothing was skipped for that
  reason.
- Left out: active entries with no scope annex in the register, so the accredited standards
  are unknown: O'ZAK.MT.0025 Empire Cert (no PDF), O'ZAK.MT.0037 Eltech-Malaka, O'ZAK.MT.0043
  Astrum Cert, O'ZAK.MT.0044 Eco-Life 2020 (certificate scan only).
- Status: `Amaldagi` (in force) → ACTIVE; `To'xtagan` (suspended) → SUSPENDED; `Tugagan`,
  `Muddati tugagan` (ended, expired) → WITHDRAWN. Only bodies that currently hold a valid
  accreditation are kept: the others are removed by `database/prune_inactive.py`, which the
  prepare script runs after writing the CSVs.
- Names: the quoted company name with its legal form in English (`mas'uliyati cheklangan
  jamiyat` → LLC). Four names are translated by hand: O'ZAK.MT.0023 Uzbekistan Standards
  Institute (state institution), O'ZAK.MT.0031 ACERT Bureau LLC ("Асерт Бюро", St Petersburg),
  O'ZAK.MT.0035 Bishkek Center for Testing, Certification and Metrology (Kyrgyzstan),
  O'ZAK.MT.0039 Center for Safety of Pharmaceutical Products (state institution).
- Country from the address (Uzbekistan, except Russia for 0031 and Kyrgyzstan for 0035).
  Address as printed (Uzbek). `registration_no` is the STIR (taxpayer number). Phone: the first
  number, international form (`(0371) …` → `+998 71 …`). E-mail and website: the first given.
- `issue_date` is the first accreditation date (else the accreditation date), `expiry_date` the
  current certificate's valid-to date.

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-06 | accred_uz_management_bodies.py | 41 register entries: 25 in force, 3 suspended, 13 ended or expired |
| 2026-11-09 | prepare_certifind.py | 4 in-force entries without a scope annex left out; 16 not-in-force bodies removed by prune_inactive.py; 21 bodies kept |
