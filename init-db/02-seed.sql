-- CertiFind seed data for the executive demo (2026-10-24)
-- Depends on 01-init.sql being applied first.
-- Safe to run multiple times — all inserts are ON CONFLICT DO NOTHING.


-- Accreditation bodies

INSERT INTO accreditation_bodies (code, name, country, is_iaf_mla, avg_daily_rate_eur, website)
VALUES
    ('ACCREDIA', 'ACCREDIA – Ente Italiano di Accreditamento',  'Italy',   TRUE, 1100.00, 'https://www.accredia.it'),
    ('RENAR',    'RENAR – Asociatia de Acreditare din Romania', 'Romania', TRUE,  650.00, 'https://www.renar.ro'),
    ('PCA',      'PCA – Polskie Centrum Akredytacji',           'Poland',  TRUE,  700.00, 'https://www.pca.gov.pl')
ON CONFLICT (code) DO UPDATE SET
    name               = EXCLUDED.name,
    country            = EXCLUDED.country,
    is_iaf_mla         = EXCLUDED.is_iaf_mla,
    avg_daily_rate_eur = EXCLUDED.avg_daily_rate_eur,
    website            = EXCLUDED.website;


-- ATECO → EA sector mappings (core demo sectors)

INSERT INTO ateco_ea_mapping (ateco_code, description, ea_code, ea_description)
VALUES
    ('88.91.00', 'Asilo nido e servizi per l''infanzia',                               37, 'Education'),
    ('62.01.00', 'Produzione di software, consulenza informatica e attività connesse', 33, 'Information Technology'),
    ('41.20.00', 'Costruzione di edifici residenziali e non residenziali',             28, 'Construction'),
    ('56.10.11', 'Ristorazione con somministrazione',                                  30, 'Hotels and restaurants'),
    ('25.62.00', 'Lavori di meccanica generale',                                       17, 'Basic metals and fabricated metal products')
ON CONFLICT DO NOTHING;


-- Certification bodies
-- We use a CTE to resolve the accreditation_body_id by code so we don't
-- need to hard-code serial IDs that may differ between environments.

WITH ab AS (
    SELECT id, code FROM accreditation_bodies
)
INSERT INTO certification_bodies
    (name, country, accreditation_body_id, has_italian_auditors, is_commercial_partner,
     custom_daily_rate_eur, phone, email, website, address)
VALUES
    -- Italy (ACCREDIA)
    ('SGS Italia S.p.A.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, TRUE, NULL,
     '+39 02 73931', 'it.certification@sgs.com', 'https://www.sgs.com/it-it',
     'Via Caldera 21, 20153 Milano MI, Italia'),

    ('Bureau Veritas Italia S.p.A.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, TRUE, NULL,
     '+39 010 5385 1', 'bvitalia@bureauveritas.com', 'https://www.bureauveritas.it',
     'Viale Monza 347, 20126 Milano MI, Italia'),

    ('TUV Rheinland Italia S.r.l.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, FALSE, 1050.00,
     '+39 02 3670 7500', 'info@tuv.com', 'https://www.tuv.com/it/italia',
     'Via G. Schiavonetti 270, 00173 Roma RM, Italia'),

    ('DNV Business Assurance Italy S.r.l.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, FALSE, 1080.00,
     '+39 010 5485 1', 'certification.italy@dnv.com', 'https://www.dnv.com/it/services/certification',
     'Via Corsica 12, 16128 Genova GE, Italia'),

    ('RINA Services S.p.A.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, TRUE, 990.00,
     '+39 010 5385 200', 'certification@rina.org', 'https://www.rina.org',
     'Via Corsica 12, 16128 Genova GE, Italia'),

    ('Kiwa Cermet Italia S.p.A.',
     'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),
     TRUE, FALSE, 920.00,
     '+39 051 764 811', 'info@kiwacermet.it', 'https://www.kiwacermet.it',
     'Via Cadriano 23, 40057 Granarolo dell''Emilia BO, Italia'),

    -- Romania (RENAR)
    ('CertRom S.R.L.',
     'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),
     TRUE, TRUE, 620.00,
     '+40 21 310 4320', 'office@certrom.ro', 'https://www.certrom.ro',
     'Str. Occidentului 13, 010983 Bucuresti, Romania'),

    ('SRAC CERT S.R.L.',
     'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),
     TRUE, FALSE, 640.00,
     '+40 21 211 9600', 'office@srac.ro', 'https://www.srac.ro',
     'Str. Mendeleev 21-25, 010362 Bucuresti, Romania'),

    ('Certind S.A.',
     'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),
     TRUE, TRUE, 630.00,
     '+40 21 327 5811', 'office@certind.ro', 'https://www.certind.ro',
     'Calea Plevnei 139C, 060012 Bucuresti, Romania'),

    -- Poland (PCA)
    ('TUV Nord Polska Sp. z o.o.',
     'Poland', (SELECT id FROM ab WHERE code = 'PCA'),
     TRUE, FALSE, 700.00,
     '+48 22 511 1800', 'biuro@tuvnord.pl', 'https://www.tuv-nord.com/pl',
     'ul. Mickiewicza 37, 40-085 Katowice, Polska'),

    ('PRS Polski Rejestr Statkow S.A.',
     'Poland', (SELECT id FROM ab WHERE code = 'PCA'),
     TRUE, FALSE, 680.00,
     '+48 58 751 1100', 'prs@prs.pl', 'https://www.prs.pl',
     'al. gen. J. Hallera 126, 80-416 Gdansk, Polska'),

    ('URS Polska Sp. z o.o.',
     'Poland', (SELECT id FROM ab WHERE code = 'PCA'),
     TRUE, TRUE, 720.00,
     '+48 22 877 5640', 'certyfikacja@urspolska.pl', 'https://www.urs.com/pl',
     'ul. Konstruktorska 11A, 02-673 Warszawa, Polska')
ON CONFLICT DO NOTHING;


-- Accredited scopes
-- Same CTE trick for CB name → id resolution.
-- Scopes marked with "demo" cover ISO 9001 / EA 37 (Education / Asilo nido),
-- which is the core matchmaking scenario shown on Friday.

WITH cb AS (
    SELECT id, name FROM certification_bodies
)
INSERT INTO accredited_scopes (certification_body_id, iso_standard, ea_code, status, proof_url)
VALUES
    -- SGS Italia
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'), 'ISO 9001',  33, 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'), 'ISO 14001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'), 'ISO 45001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),

    -- Bureau Veritas Italia
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'), 'ISO 14001', 33, 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'), 'ISO 45001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),

    -- TUV Rheinland Italia
    ((SELECT id FROM cb WHERE name = 'TUV Rheinland Italia S.r.l.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'TUV Rheinland Italia S.r.l.'), 'ISO 9001',  33, 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),
    ((SELECT id FROM cb WHERE name = 'TUV Rheinland Italia S.r.l.'), 'ISO 14001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),

    -- DNV Business Assurance Italy
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'), 'ISO 9001',  28, 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'), 'ISO 14001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'), 'ISO 45001', 33, 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),

    -- RINA Services
    ((SELECT id FROM cb WHERE name = 'RINA Services S.p.A.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.accredia.it/en/organism/rina-services-s-p-a/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'RINA Services S.p.A.'), 'ISO 14001', 33, 'ACTIVE', 'https://www.accredia.it/en/organism/rina-services-s-p-a/'),

    -- Kiwa Cermet Italia
    ((SELECT id FROM cb WHERE name = 'Kiwa Cermet Italia S.p.A.'), 'ISO 9001',  28, 'ACTIVE', 'https://www.accredia.it/en/organism/kiwa-cermet-italia/'),
    ((SELECT id FROM cb WHERE name = 'Kiwa Cermet Italia S.p.A.'), 'ISO 45001', 28, 'ACTIVE', 'https://www.accredia.it/en/organism/kiwa-cermet-italia/'),

    -- CertRom
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'), 'ISO 14001', 28, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'), 'ISO 45001', 33, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),

    -- SRAC CERT
    ((SELECT id FROM cb WHERE name = 'SRAC CERT S.R.L.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'SRAC CERT S.R.L.'), 'ISO 14001', 33, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),

    -- Certind
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'), 'ISO 9001',  37, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),  -- demo
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'), 'ISO 9001',  28, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'), 'ISO 45001', 28, 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),

    -- TUV Nord Polska
    ((SELECT id FROM cb WHERE name = 'TUV Nord Polska Sp. z o.o.'), 'ISO 9001',  33, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'TUV Nord Polska Sp. z o.o.'), 'ISO 14001', 28, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),

    -- PRS Polski Rejestr Statkow
    ((SELECT id FROM cb WHERE name = 'PRS Polski Rejestr Statkow S.A.'), 'ISO 9001',  28, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'PRS Polski Rejestr Statkow S.A.'), 'ISO 45001', 28, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),

    -- URS Polska
    ((SELECT id FROM cb WHERE name = 'URS Polska Sp. z o.o.'), 'ISO 9001',  33, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'URS Polska Sp. z o.o.'), 'ISO 14001', 33, 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/')
ON CONFLICT DO NOTHING;
