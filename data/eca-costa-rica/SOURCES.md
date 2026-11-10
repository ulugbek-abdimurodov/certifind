# ECA (Costa Rica)

Source: ECA register of management system certification bodies (ISO/IEC 17021-1),
https://eca.or.cr/organismos-de-certificacion-de-sistemas/, and each body's scope annexes
(international-recognition and national). Raw data in `database/costa-rica/database/costa_rica/scrape_cr_eca.py`
(transcribed via browser; direct access to eca.or.cr was blocked), converted with
`database/costa-rica/prepare_certifind.py`; review log in `database/costa-rica/eca_review.md`.

- `issue_date` = "Acreditado a partir del"; accreditation is indefinite, so `expiry_date` is empty.
- ISO 9001, 14001, 45001: IAF codes from the international-recognition annex.
- ISO 50001, ISO/IEC 27001, ISO 28000, ISO 37001: no sector list, recorded for EA 1-39.
- Suffixed rows: ISO 50001 → `(50003)`, ISO/IEC 27001 → `(27006)`, ISO 37001 → `(37001)`.
- Not imported: INTE G38-3:2021 (national scheme); ISO 22000 / FSSC 22000 (reduced from scope).

| Retrieved | By | Notes |
| --- | --- | --- |
| 2026-11-10 | scrape_cr_eca.py | 1 body (OCSG-001 INTECO), 2 scope PDFs |
| 2026-11-10 | prepare_certifind.py | 1 body, 4 accreditations, 7 scope rows |
