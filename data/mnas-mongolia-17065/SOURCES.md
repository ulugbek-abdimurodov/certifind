# MNAS - ISO/IEC 17065

Source: https://e-accreditation.gov.mn/

Register https://e-accreditation.gov.mn/ (standard 7, certificates PC xx). Group-level lines: 19 scanned annexes transcribed by eye (GROUPS in the converter), PC 02 read from its text layer. PC 03: main annex plus 2 of 22 provincial branch annexes read.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`mnas-mongolia`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (0 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- not accredited (хүчингүй): 3

Reused body rows:

- PC 03 Agency for Standardization and Metrology (MASM) - Product and System Certification Department: reused (same country and name)
- PC 12 Mon Mining Certification LLC: reused (same country and name)
- PC 18 Moncertf LLC: reused (same country and name)
- PC 23 Q Certf LLC: reused (same country and name)
- PC 24 ABS Certification LLC: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 20 | 20 | 157 | 4 | 153 |
