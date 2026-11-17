# JASANZ (Australia / New Zealand) - ISO/IEC 17065

Source: JASANZ register, https://register.jasanz.org/accredited-bodies (public JSON API
`jasanzcupr-api.azurewebsites.net/api/V1/RegisterCertificate/`: GetFilteredCABRegister, GetCABsInformation,
CabSchemeScopeDetails), CABs with the "Product Certification" program (ISO/IEC 17065:2012). Scraped with
`database/australia/jasanz-australia-17065/scrape_au_jasanz_17065.py` (run in-browser on 2026-11-17: the API host
is blocked from the workspace), converted with `prepare_certifind_17065.py` in the same folder; review in
`jasanz_17065_review.md`. Not yet verified by a person, so `verified_at` is empty. `source_url` and `proof_url`
are the register page (scope data comes from the API, no PDFs).

Rules:

- The JASANZ product accreditation number (Z...) is the certificate number; when a CAB holds several Z numbers
  the first is used (listed in the review).
- Body rows: 25 of 64 reuse an existing row exactly (`jasanz-australia` by accreditation number, other datasets
  by name + country). Others take address and contacts from the head-office location: websites get
  `https://`, national phones get +61 / +64, toll-free numbers (1300 / 1800 / 0800) are left empty.
- `issue_date` = "Last Accreditation Issued", `expiry_date` = "Accreditation Expiry Date" (CAB level).
- Each certification standard under a "Product Certification" scheme is one line: `product_text` = standard
  description, `normative_docs` = standard number + scheme documents (without ISO/IEC 17065 and IAF MD4),
  `scheme_text` = JASANZ scheme name.
- `scheme`: only catalogue schemes (GLOBALG.A.P., BRCGS, IFS, SQF, PEFC, LEAF, ISO 3834); Responsible Wood
  (the Australian PEFC member scheme) -> PEFC Chain of Custody. Australian / NZ schemes (EESS electrical
  safety, WaterMark, CodeMark, gas appliance, ANZEx, organic, NDIS / human services, Freshcare...) and
  certifier-owned marks (CMI ProdCert, SAI Global StandardsMark, BSI Benchmark, ApprovalMark, Global-Mark...)
  have no scheme: they stay searchable through `scheme_text` and get a sector from the scheme name or the
  product text. No migration needed.
- Not imported: exact duplicate lines within a body and scheme (104).

| Retrieved | Bodies | Accreditations | Product lines |
| --- | --- | --- | --- |
| 2026-11-17 | 64 | 64 | 11,070 (155 with a scheme, 9,708 more with a sector) |
