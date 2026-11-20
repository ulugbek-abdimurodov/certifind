# NiNAS - ISO/IEC 17065

Source: https://ninas.ng/accreditation/accredited-product-bodies/ (register with 1 body, status Active).

Scraper `database/nigeria/scrape_ng_ninas_17065.py`; converter `database/nigeria/prepare_certifind_17065.py`
(annex of schedule PR0001 transcribed by hand, only 3 lines). Not yet verified by a person.

Rules:

- One accreditation row, `accreditation_standard` = ISO/IEC 17065; `scopes.csv` is header only.
- Certificate PR0001 does not collide with the management-system numbers (MSC000x), so no suffix.
- `product_scopes.csv`: ECOSTAND 100 / GAMS 26:2020 / GAMS 23:2022 for dried mango, text verbatim, industry `food`,
  no `scheme` (ECOWAS/Gambian national schemes are not in the catalogue). IAF 3, ISO/IEC 17067 type 5 not recorded.
- The body is in The Gambia (accredited abroad by NiNAS); country set from its own address.
- Phone `+220464210` on the register has only 6 digits after the code: left empty (see review).

Left out: nothing.

| Retrieved | Bodies | Accreditations | Product lines | with scheme | without scheme |
| --- | --- | --- | --- | --- | --- |
| 2026-11-20 | 1 | 1 | 3 | 0 | 3 |
