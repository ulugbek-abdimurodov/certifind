# SANAS - ISO/IEC 17065

Source: https://www.sanas.co.za/Pages/index.aspx

SANAS register (SharePoint list 'Legal Entity (Published)', Field of Accreditation = Certification Body, discipline ISO/IEC 17065). Lines from the scope of accreditation (Annexure A) in the latest published certificate PDF: description in product_text, cited standard in normative_docs, scheme / type / IAF sector in scheme_text.

Converted with the shared `database/certifind_17065_common.py` (rules of `/add-country-17065`). Not yet verified by a
person, so `verified_at` is empty.

Rules:

- One accreditation row per body, `accreditation_standard` = ISO/IEC 17065. A certificate number that the AB's
  management system dataset (`sanas-south-africa`) already uses gets the suffix ` (17065)`.
- `scopes.csv` is header only (no EA codes for 17065).
- `product_scopes.csv`: one row per scope line, in register/annex order, text verbatim (whitespace collapsed).
  `scheme` only when the text cites a scheme in the `schemes` catalogue (EU directive/regulation number or a
  private scheme name). Lines without a scheme get an `industry` from keywords; when no keyword matches it is
  `other_manufacturing` (38 lines). National schemes stay text only.
- Body rows already present in another dataset are copied unchanged; others are built from the register.
- Only bodies the register lists as accredited are imported.

Left out:

- duplicate line within the accreditation: 2
- not accredited (Withdrawn): 1

Reused body rows:

- C07a SABS Commercial SOC Ltd.: reused (same country and name)
- C75 CMA Certification Services (Pty) Ltd: reused (same country and name)
- C78 African Certification and Testing (Pty) Ltd: reused (same country and name)
- C89a BSI Group South Africa (Pty) Ltd: reused (same country and name)

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 19 | 19 | 661 | 8 | 653 |
