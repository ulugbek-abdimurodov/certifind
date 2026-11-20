# OZAK - ISO/IEC 17065

Source: https://akkred.uz/uz/reestr

Register API https://api-e.akkred.uz/apps/registries/main/?type_std=17 (Mahsulot sertifikatlash organi, O'z DSt ISO/IEC 17065). Lines from the most recent scope PDF per body (product name and normative documents columns, Russian verbatim); industry from the HS chapter of the TN VED codes. Only register status 'active' is imported.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`ozak-uzbekistan`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (188 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 206
- not accredited (inactive): 23
- not accredited (expired): 9
- not accredited (paused): 8

Reused body rows:

- O'ZAK.MS.0014 Center for Safety of Pharmaceutical Products (state institution): reused (same country and name)
- O'ZAK.MS.0051 Center for Safety of Pharmaceutical Products (state institution): reused (same country and name)
- O'ZAK.MS.0060 Center for Safety of Pharmaceutical Products (state institution): reused (same country and name)
- O'ZAK.MS.0081 Center for Safety of Pharmaceutical Products (state institution): reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 77 | 77 | 7854 | 2 | 7852 |
