# SADCAS - ISO/IEC 17065

Source: https://www.sadcas.org/accredited-organisations/product-certification-bodies (3 bodies, status Approved).

Scraper `database/africa/database/sadc/scrape_sadc_sadcas_17065.py`; converter `database/africa/database/sadc/prepare_certifind_17065.py`. The annex tables have merged cells, so the lines were paired by hand from the rendered PDF pages (the scraper's scope_lines.csv was incomplete and is not used). Not verified by a person.

Rules:

- One accreditation row per body, ISO/IEC 17065; `scopes.csv` header only. PROD-CERT 00x numbers do not collide with the management-system numbers.
- Body rows reused unchanged from `sadcas-botswana` (Zambia Bureau of Standards - Certification Services, Standards Association of Zimbabwe - Certification Services, Tanzania Bureau of Standards - Management System Certification Services). The register title for the product accreditations differs slightly; same organisations.
- One line per standard/product row; the IAF code description and the specific scheme rule go to `scheme_text`. No catalogue scheme applies (ZS, ZWS, TZS national standards and scheme rules stay text; industry set from the IAF code). ISO/IEC 17067 type 5 not recorded.
- Issue date = date of issue of the current schedule; expiry as on the certificate.

Left out: nothing.

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 3 | 3 | 44 | 0 | 44 |
