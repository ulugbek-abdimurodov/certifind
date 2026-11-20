# NCA - ISO/IEC 17065

Source: http://77.245.104.163/index.php?do=web_search

NCA register of accredited bodies (activity filter 1 = OPS P / OPS PiU, ISO/IEC 17065), retrieved from the Word annexes of each accreditation. 70 register rows = 54 accreditation numbers (NaCEkS has 16 branch rows, the Caspian Certification Centre 2). Technical regulations of the Customs Union / EAEU are regional schemes and stay text (scheme_text lists the regulations cited in each line). TNVED codes and the conformity assessment scheme number are not imported (no column). Not imported: 83 PDF annexes (text layer with a broken font encoding) and about 97 Word annexes without a readable table (see nca_17065_review.md); two scanned annexes were read from the page images (annex_transcription.csv).

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`nca-kazakhstan`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (1298 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 392

Reused body rows:

- KZ.O.02.0139 Sapa Intersystem LLP: reused (same country and name)
- KZ.O.02.0651 TEKS LLP: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 54 | 54 | 17778 | 0 | 17778 |
