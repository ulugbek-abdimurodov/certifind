# KAB (South Korea)

Source: KAB register of accredited management system certification bodies,
https://eng.kab.or.kr/eng/kcn/kcn/list.do (detail pages `view.do?orgIdx=<id>&menuNo=500044`).
Scraped with `database/korea/scrape_kr_kab.py` into `kab_raw.txt`, converted with
`database/korea/prepare_certifind.py`; review log `database/korea/kab_review.md`.
Not yet verified by a person, so `verified_at` is empty.

Extraction rules:
- KAB issues one number per scheme (KAB-QC-01, KAB-EC-01, ...). Because of `uq_cb_ab_standard`, all
  schemes under the same accreditation standard are merged into the body's first number (usually the
  ISO 9001 one); the original KAB number is kept in `scope_note`. `issue_date` is the earliest date;
  KAB publishes no expiry, so `expiry_date` is empty.
- Separate rows: ISO/IEC 27001/27701 → ISO/IEC 27006 `(27006)`, ISO 50001 → ISO 50003 `(50003)`,
  ISO 22000/FSSC 22000 → ISO 22003-1 `(22000)`, ISO 22301 → ISO/IEC 17021-6 `(22301)`,
  ISO 37001 → ISO/IEC 17021-9 `(37001)`, ISO/IEC 42001 → ISO/IEC 42006 `(42001)`,
  KS Q 9100 (Korean adoption of AS 9100) → AS 9100 under AS 9104-1 `(9104)`. Others under ISO/IEC 17021-1.
- Sectors: IAF codes as listed for ISO 9001/14001/45001 and KS Q 9100; ISO 22000/FSSC categories and
  ISO 13485 areas (KAB letters A–G in IAF MD 8 order) classified to EA with the ESYD tables; ISO 22301
  uses the EA numbers KAB lists per sector group (a group with no numbers → all EA). ISO/IEC 27001,
  27701, 42001, ISO 50001, 37001, 37301, 19443, 21001: no sector list → EA 1–39 with note.
- Phones converted to international (+82, leading 0 dropped). Country "South Korea" for all bodies.

Left out: TL 9000 (3 accreditations; not in the standards table).

| Retrieved | Bodies | Accreditations | Scopes |
| --- | --- | --- | --- |
| 2026-11-09 | 21 | 69 | 125 |
