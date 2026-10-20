-- End-of-day verification queries for the Day-1 database.
-- Scenario: user searches for "Asilo nido" + ISO 9001 → EA 37
--
-- Run with:
--   Get-Content test-eod-queries.sql | docker exec -i certifind-postgres psql -U postgres -d certifind_db

\set ON_ERROR_STOP on
\timing on


-- 1. Check that the ATECO code for Asilo nido resolves to EA 37

\echo ''
\echo '1. ATECO 88.91.00 → EA resolution'
SELECT ateco_code, description, ea_code, ea_description
FROM ateco_ea_mapping
WHERE ateco_code = '88.91.00';


-- 2. Core matchmaking query
--    Mirrors what the API will run: given an ATECO code and ISO standard,
--    find all active certification bodies and their accreditation evidence.

\echo ''
\echo '2. Certification bodies for ISO 9001 / EA 37 (sorted cheapest first)'
SELECT
    cb.name                                                    AS certification_body,
    cb.country,
    ab.code                                                    AS accreditor,
    cb.has_italian_auditors,
    cb.is_commercial_partner,
    s.status,
    s.proof_url
FROM ateco_ea_mapping aem
JOIN accredited_scopes s
     ON  s.ea_code      = aem.ea_code
     AND s.iso_standard = 'ISO 9001'
     AND s.status       = 'ACTIVE'
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN accreditation_bodies ab ON ab.id = cb.accreditation_body_id
WHERE aem.ateco_code = '88.91.00'
ORDER BY cb.name ASC;


-- 3. Spot-checks (each must return the expected value)

\echo ''
\echo '3. Spot-checks'

\echo '   CertRom present (expect 1)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.name = 'CertRom S.R.L.' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   SRAC CERT present (expect 1)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.name = 'SRAC CERT S.R.L.' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   SGS Italia present (expect 1)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.name = 'SGS Italia S.p.A.' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   Bureau Veritas present (expect 1)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.name = 'Bureau Veritas Italia S.p.A.' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   Italian bodies with ISO 9001 / EA 37 (expect >= 3)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.country = 'Italy' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   Non-Italian bodies with ISO 9001 / EA 37 (expect >= 3)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE cb.country <> 'Italy' AND aem.ateco_code = '88.91.00'
  AND s.iso_standard = 'ISO 9001' AND s.status = 'ACTIVE';

\echo '   CBs without Italian auditors in result (expect 0)'
SELECT count(*) AS result
FROM accredited_scopes s
JOIN certification_bodies cb ON cb.id = s.certification_body_id
JOIN ateco_ea_mapping aem ON aem.ea_code = s.ea_code
WHERE aem.ateco_code = '88.91.00' AND s.iso_standard = 'ISO 9001'
  AND s.status = 'ACTIVE' AND cb.has_italian_auditors = FALSE;


-- 4. Basic data integrity

\echo ''
\echo '4. Data integrity'

\echo '   Orphaned scopes (expect 0)'
SELECT count(*) AS result
FROM accredited_scopes s
LEFT JOIN certification_bodies cb ON cb.id = s.certification_body_id
WHERE cb.id IS NULL;

\echo '   CBs with no accreditation body (expect 0)'
SELECT count(*) AS result FROM certification_bodies WHERE accreditation_body_id IS NULL;

\echo '   Non-IAF-MLA bodies (expect 0)'
SELECT count(*) AS result FROM accreditation_bodies WHERE is_iaf_mla = FALSE;

\echo '   Total scopes (expect 31)'
SELECT count(*) AS result FROM accredited_scopes;

\echo '   Total CBs (expect 12)'
SELECT count(*) AS result FROM certification_bodies;

\echo ''
