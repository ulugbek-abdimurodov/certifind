-- CertiFind seed data for the executive demo (2026-10-24)
-- Depends on 01-init.sql being applied first.
-- Safe to run multiple times — all inserts are ON CONFLICT DO NOTHING.
-- Accreditation bodies
INSERT INTO
    accreditation_bodies (code, name, country, is_iaf_mla, website)
VALUES
    (
        'ACCREDIA',
        'ACCREDIA – Ente Italiano di Accreditamento',
        'Italy',
        TRUE,
        'https://www.accredia.it'
    ),
    (
        'RENAR',
        'RENAR – Asociatia de Acreditare din Romania',
        'Romania',
        TRUE,
        'https://www.renar.ro'
    ),
    (
        'DAkkS',
        'Deutsche Akkreditierungsstelle',
        'Germany',
        TRUE,
        'https://www.dakks.de'
    ),
    (
        'UKAS',
        'United Kingdom Accreditation Service',
        'United Kingdom',
        TRUE,
        'https://www.ukas.com'
    ),
    (
        'PCA',
        'PCA – Polskie Centrum Akredytacji',
        'Poland',
        TRUE,
        'https://www.pca.gov.pl'
    ) ON CONFLICT (code) DO
UPDATE
SET
    name = EXCLUDED.name,
    country = EXCLUDED.country,
    is_iaf_mla = EXCLUDED.is_iaf_mla,
    website = EXCLUDED.website;

-- ATECO → EA sector mappings (core demo sectors)
INSERT INTO
    ateco_ea_mapping (ateco_code, description, ea_code, ea_description)
VALUES
    (
        '88.91.00',
        'Asilo nido e servizi per l''infanzia',
        37,
        'Education'
    ),
    (
        '71.12.10',
        'Attività di studi di ingegneria integrata',
        34,
        'Engineering Services'
    ),
    (
        '10.71.10',
        'Produzione di prodotti di panetteria freschi',
        3,
        'Food products, beverages and tobacco'
    ),
    (
        '46.90.00',
        'Commercio all''ingrosso non specializzato',
        29,
        'Wholesale and retail trade'
    ),
    (
        '62.01.00',
        'Produzione di software, consulenza informatica e attività connesse',
        33,
        'Information Technology'
    ),
    (
        '41.20.00',
        'Costruzione di edifici residenziali e non residenziali',
        28,
        'Construction'
    ),
    (
        '56.10.11',
        'Ristorazione con somministrazione',
        30,
        'Hotels and restaurants'
    ),
    (
        '25.62.00',
        'Lavori di meccanica generale',
        17,
        'Basic metals and fabricated metal products'
    ) ON CONFLICT DO NOTHING;

-- Certification bodies
-- We use a CTE to resolve the accreditation_body_id by code so we don't
-- need to hard-code serial IDs that may differ between environments.
WITH
    ab AS (
        SELECT
            id,
            code
        FROM
            accreditation_bodies
    )
INSERT INTO
    certification_bodies (
        name,
        country,
        accreditation_body_id,
        has_italian_auditors,
        is_commercial_partner,
        phone,
        email,
        website,
        address
    )
VALUES
    -- Italy (ACCREDIA)
    (
        'SGS Italia S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 02 73931',
        'it.certification@sgs.com',
        'https://www.sgs.com/it-it',
        'Via Caldera 21, 20153 Milano MI, Italia'
    ),
    -- Italy (ACCREDIA)
    (
        'CSQ - IMQ S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 02 50731',
        'info@imq.it',
        'https://www.imq.it',
        'Via Quintiliano 43, 20138 Milano MI, Italia'
    ),
    (
        'Certiquality S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 02 8069171',
        'certiquality@certiquality.it',
        'https://www.certiquality.it',
        'Via Gaetano Giardino 4, 20123 Milano MI, Italia'
    ),
    (
        'ICIM S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 02 725341',
        'info@icim.it',
        'https://www.icim.it',
        'Piazza Don Enrico Mapelli 75, 20099 Sesto San Giovanni MI, Italia'
    ),
    (
        'Quaser Certificazioni S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 02 67479254',
        'segreteria@quaser.org',
        'https://www.quaser.org',
        'Via C. Imbonati 18, 20159 Milano MI, Italia'
    ),
    (
        'AJA Registrars Europe S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 06 85356701',
        'roma@aeurope.eu',
        'https://www.aeurope.eu',
        'Via Nomentana 257, 00161 Roma RM, Italia'
    ),
    (
        'Global Group Italia S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 0546 686252',
        'info@globalgroupitalia.it',
        'https://www.globalgroupitalia.it',
        'Via Correcchio 12, 47122 Forlì FC, Italia'
    ),
    -- Romania (RENAR)
    (
        'SIMTEX-OC S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        TRUE,
        '+40 21 317 0170',
        'simtex@simtex.ro',
        'https://www.simtex.ro',
        'Str. Maria Rosetti 10, 020485 Bucuresti, Romania'
    ),
    (
        'ALL CERT PRODUCT S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        FALSE,
        '+40 21 252 5555',
        'office@allcert.ro',
        'https://www.allcert.ro',
        'B-dul Chisinau 1, 022141 Bucuresti, Romania'
    ),
    (
        'TUV Austria Romania S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        TRUE,
        '+40 21 314 4300',
        'bucuresti@tuvaustria.ro',
        'https://www.tuvaustria.ro',
        'Calea Floreasca 169A, 014459 Bucuresti, Romania'
    ),
    (
        'Q-CERT Romania S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        TRUE,
        '+40 21 230 4567',
        'romania@q-cert.com',
        'https://www.q-cert.com',
        'Str. Av. Stefan Sanatescu 48, 011478 Bucuresti, Romania'
    ),
    (
        'CERTSYS S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        FALSE,
        '+40 31 405 1234',
        'office@certsys.ro',
        'https://www.certsys.ro',
        'B-dul Unirii 64, 030834 Bucuresti, Romania'
    ),
    (
        'MiNT Romania S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        FALSE,
        '+40 21 326 7788',
        'contact@mintre.ro',
        'https://www.mintre.ro',
        'Str. Vasile Conta 3-5, 020951 Bucuresti, Romania'
    ),
    -- Poland (PCA)
    (
        'ZETOM Katowice Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        FALSE,
        '+48 32 256 9257',
        'zetom@zetom.katowice.pl',
        'https://www.zetom.katowice.pl',
        'ul. Ks. Bpa H. Bednorza 17, 40-384 Katowice, Polska'
    ),
    (
        'PCBC S.A. - Polish Centre for Testing',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        TRUE,
        '+48 22 857 9916',
        'pcbc@pcbc.gov.pl',
        'https://www.pcbc.gov.pl',
        'ul. Klobucka 23A, 02-699 Warszawa, Polska'
    ),
    (
        'ISOCERT Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        TRUE,
        '+48 71 780 4350',
        'biuro@isocert.pl',
        'https://www.isocert.pl',
        'ul. Kwidzynska 6e, 51-416 Wroclaw, Polska'
    ),
    (
        'DEKRA Certification Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        TRUE,
        '+48 71 787 0100',
        'polska@dekra.com',
        'https://www.dekra.pl',
        'ul. Legnicka 48H, 54-202 Wroclaw, Polska'
    ),
    (
        'UDT-CERT (Urząd Dozoru Technicznego)',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        FALSE,
        '+48 22 572 2110',
        'udt@udt.gov.pl',
        'https://www.udt.gov.pl',
        'ul. Szczesliwicka 34, 02-353 Warszawa, Polska'
    ),
    (
        'CCG Certification Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        FALSE,
        '+48 12 345 6789',
        'kontakt@ccg-cert.pl',
        'https://www.ccg-cert.pl',
        'ul. Wielicka 72, 30-552 Krakow, Polska'
    ),
    -- Germany (DAkkS)
    (
        'TÜV SÜD Management Service GmbH',
        'Germany',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'DAkkS'
        ),
        TRUE,
        TRUE,
        '+49 89 5791 0',
        'info@tuvsud.com',
        'https://www.tuvsud.com/de-de',
        'Westendstraße 199, 80686 München, Deutschland'
    ),
    (
        'DQS GmbH',
        'Germany',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'DAkkS'
        ),
        TRUE,
        TRUE,
        '+49 69 95427 0',
        'info@dqs.de',
        'https://www.dqs.de',
        'August-Schanz-Straße 21, 60433 Frankfurt am Main, Deutschland'
    ),
    (
        'GUTcert GmbH',
        'Germany',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'DAkkS'
        ),
        TRUE,
        FALSE,
        '+49 30 2332021 0',
        'info@gut-cert.de',
        'https://www.gut-cert.de',
        'Eichenstraße 3b, 12435 Berlin, Deutschland'
    ),
    -- United Kingdom (UKAS)
    (
        'BSI Assurance UK Limited',
        'United Kingdom',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'UKAS'
        ),
        TRUE,
        TRUE,
        '+44 345 080 9000',
        'cservices@bsigroup.com',
        'https://www.bsigroup.com',
        '389 Chiswick High Road, London W4 4AL, UK'
    ),
    (
        'NQA Certification Ltd',
        'United Kingdom',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'UKAS'
        ),
        TRUE,
        TRUE,
        '+44 800 052 2424',
        'contact@nqa.com',
        'https://www.nqa.com',
        'Warwick House, Houghton Hall Park, Dunstable LU5 5ZX, UK'
    ),
    (
        'BM TRADA (Warringtonfire)',
        'United Kingdom',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'UKAS'
        ),
        TRUE,
        FALSE,
        '+44 1494 569700',
        'enquiries@bmtrada.com',
        'https://www.bmtrada.com',
        'Stocking Lane, Hughenden Valley, High Wycombe HP14 4ND, UK'
    ),
    (
        'Bureau Veritas Italia S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 010 5385 1',
        'bvitalia@bureauveritas.com',
        'https://www.bureauveritas.it',
        'Viale Monza 347, 20126 Milano MI, Italia'
    ),
    (
        'TUV Rheinland Italia S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 02 3670 7500',
        'info@tuv.com',
        'https://www.tuv.com/it/italia',
        'Via G. Schiavonetti 270, 00173 Roma RM, Italia'
    ),
    (
        'DNV Business Assurance Italy S.r.l.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 010 5485 1',
        'certification.italy@dnv.com',
        'https://www.dnv.com/it/services/certification',
        'Via Corsica 12, 16128 Genova GE, Italia'
    ),
    (
        'RINA Services S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        TRUE,
        '+39 010 5385 200',
        'certification@rina.org',
        'https://www.rina.org',
        'Via Corsica 12, 16128 Genova GE, Italia'
    ),
    (
        'Kiwa Cermet Italia S.p.A.',
        'Italy',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'ACCREDIA'
        ),
        TRUE,
        FALSE,
        '+39 051 764 811',
        'info@kiwacermet.it',
        'https://www.kiwacermet.it',
        'Via Cadriano 23, 40057 Granarolo dell''Emilia BO, Italia'
    ),
    -- Romania (RENAR)
    (
        'CertRom S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        TRUE,
        '+40 21 310 4320',
        'office@certrom.ro',
        'https://www.certrom.ro',
        'Str. Occidentului 13, 010983 Bucuresti, Romania'
    ),
    (
        'SRAC CERT S.R.L.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        FALSE,
        '+40 21 211 9600',
        'office@srac.ro',
        'https://www.srac.ro',
        'Str. Mendeleev 21-25, 010362 Bucuresti, Romania'
    ),
    (
        'Certind S.A.',
        'Romania',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'RENAR'
        ),
        TRUE,
        TRUE,
        '+40 21 327 5811',
        'office@certind.ro',
        'https://www.certind.ro',
        'Calea Plevnei 139C, 060012 Bucuresti, Romania'
    ),
    -- Poland (PCA)
    (
        'TUV Nord Polska Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        FALSE,
        '+48 22 511 1800',
        'biuro@tuvnord.pl',
        'https://www.tuv-nord.com/pl',
        'ul. Mickiewicza 37, 40-085 Katowice, Polska'
    ),
    (
        'PRS Polski Rejestr Statkow S.A.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        FALSE,
        '+48 58 751 1100',
        'prs@prs.pl',
        'https://www.prs.pl',
        'al. gen. J. Hallera 126, 80-416 Gdansk, Polska'
    ),
    (
        'URS Polska Sp. z o.o.',
        'Poland',
        (
            SELECT
                id
            FROM
                ab
            WHERE
                code = 'PCA'
        ),
        TRUE,
        TRUE,
        '+48 22 877 5640',
        'certyfikacja@urspolska.pl',
        'https://www.urs.com/pl',
        'ul. Konstruktorska 11A, 02-673 Warszawa, Polska'
    ) ON CONFLICT DO NOTHING;

-- Accredited scopes
-- Same CTE trick for CB name → id resolution.
-- Scopes marked with "demo" cover ISO 9001 / EA 37 (Education / Asilo nido),
-- which is the core matchmaking scenario shown on Friday.
WITH
    cb AS (
        SELECT
            id,
            name
        FROM
            certification_bodies
    )
INSERT INTO
    accredited_scopes (
        certification_body_id,
        iso_standard,
        ea_code,
        status,
        proof_url
    )
VALUES
    -- SGS Italia
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SGS Italia S.p.A.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'CSQ - IMQ S.p.A.'
        ),
        'ISO 9001',
        37,
        'Erogazione di percorsi formativi accreditati, asili e centri educativi per l''infanzia',
        'ACTIVE',
        'https://www.accredia.it/organismi/imq/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Certiquality S.r.l.'
        ),
        'ISO 9001',
        37,
        'Servizi per l''istruzione pre-scolare, gestione mense didattiche e infanzia',
        'ACTIVE',
        'https://www.accredia.it/organismi/certiquality/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SIMTEX-OC S.R.L.'
        ),
        'ISO 9001',
        37,
        'Educational services, childcare centers, and primary educational institutions',
        'ACTIVE',
        'https://www.renar.ro/organisme/simtex/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Austria Romania S.R.L.'
        ),
        'ISO 9001',
        37,
        'Provision of early childhood education, nurseries and specialized daycare facilities',
        'ACTIVE',
        'https://www.renar.ro/organisme/tuv-austria/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'ISOCERT Sp. z o.o.'
        ),
        'ISO 9001',
        37,
        'Education and kindergarten management systems inspection',
        'ACTIVE',
        'https://www.pca.gov.pl/podmioty/isocert/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'BSI Assurance UK Limited'
        ),
        'ISO 9001',
        37,
        'Early years provision, nurseries and day care institutions governance',
        'ACTIVE',
        'https://www.ukas.com/cabs/bsi/'
    ),
    -- Software & IT (EA 33) - ISO 9001 & ISO 14001
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'ICIM S.p.A.'
        ),
        'ISO 9001',
        33,
        'Progettazione e sviluppo di soluzioni software web e sistemi informativi enterprise',
        'ACTIVE',
        'https://www.accredia.it/organismi/icim/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'DQS GmbH'
        ),
        'ISO 9001',
        33,
        'Software engineering, cloud infrastructure development and SaaS solutions',
        'ACTIVE',
        'https://www.dakks.de/cabs/dqs/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'NQA Certification Ltd'
        ),
        'ISO 14001',
        33,
        'Data center green operations, energy monitoring and sustainable IT hosting',
        'ACTIVE',
        'https://www.ukas.com/cabs/nqa/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'ALL CERT PRODUCT S.R.L.'
        ),
        'ISO 9001',
        33,
        'Information technology services, database management and custom software coding',
        'ACTIVE',
        'https://www.renar.ro/organisme/allcert/'
    ),
    -- Construction & Infrastructure (EA 28) - ISO 14001 & ISO 45001
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Quaser Certificazioni S.r.l.'
        ),
        'ISO 14001',
        28,
        'Costruzione e ristrutturazione edifici civili ed industriali, gestione rifiuti di cantiere',
        'ACTIVE',
        'https://www.accredia.it/organismi/quaser/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'AJA Registrars Europe S.r.l.'
        ),
        'ISO 45001',
        28,
        'Gestione sicurezza sul lavoro per cantieri temporanei o mobili e grandi infrastrutture',
        'ACTIVE',
        'https://www.accredia.it/organismi/aja-europe/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'CERTSYS S.R.L.'
        ),
        'ISO 45001',
        28,
        'Civil construction works occupational health and safety site control',
        'ACTIVE',
        'https://www.renar.ro/organisme/certsys/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TÜV SÜD Management Service GmbH'
        ),
        'ISO 45001',
        28,
        'Heavy civil engineering construction safety governance and contractor management',
        'ACTIVE',
        'https://www.dakks.de/cabs/tuvsud/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'DEKRA Certification Sp. z o.o.'
        ),
        'ISO 14001',
        28,
        'Environmental impact mitigation for general construction and demolition operations',
        'ACTIVE',
        'https://www.pca.gov.pl/podmioty/dekra/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'BM TRADA (Warringtonfire)'
        ),
        'ISO 45001',
        28,
        'Timber and prefabricated structural installation site hazard mitigation',
        'ACTIVE',
        'https://www.ukas.com/cabs/bmtrada/'
    ),
    -- Engineering Services (EA 34) - ISO 9001, ISO 14001 & ISO 45001
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Global Group Italia S.r.l.'
        ),
        'ISO 9001',
        34,
        'Studi di fattibilità tecnica, progettazione strutturale e calcoli ingegneristici',
        'ACTIVE',
        'https://www.accredia.it/organismi/global-group/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'GUTcert GmbH'
        ),
        'ISO 14001',
        34,
        'Environmental impact assessments and sustainable urban engineering consultancy',
        'ACTIVE',
        'https://www.dakks.de/cabs/gutcert/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'PCBC S.A. - Polish Centre for Testing'
        ),
        'ISO 9001',
        34,
        'Technical design, specialized architectural calculations and technical oversight',
        'ACTIVE',
        'https://www.pca.gov.pl/podmioty/pcbc/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Q-CERT Romania S.R.L.'
        ),
        'ISO 45001',
        34,
        'Engineering field inspection safety and geotechnical surveying hazard prevention',
        'ACTIVE',
        'https://www.renar.ro/organisme/qcert/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SGS Italia S.p.A.'
        ),
        'ISO 9001',
        33,
        'ACTIVE',
        'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SGS Italia S.p.A.'
        ),
        'ISO 14001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SGS Italia S.p.A.'
        ),
        'ISO 45001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'
    ),
    -- Bureau Veritas Italia
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Bureau Veritas Italia S.p.A.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Bureau Veritas Italia S.p.A.'
        ),
        'ISO 14001',
        33,
        'ACTIVE',
        'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Bureau Veritas Italia S.p.A.'
        ),
        'ISO 45001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'
    ),
    -- TUV Rheinland Italia
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Rheinland Italia S.r.l.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Rheinland Italia S.r.l.'
        ),
        'ISO 9001',
        33,
        'ACTIVE',
        'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Rheinland Italia S.r.l.'
        ),
        'ISO 14001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'
    ),
    -- DNV Business Assurance Italy
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'DNV Business Assurance Italy S.r.l.'
        ),
        'ISO 9001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'DNV Business Assurance Italy S.r.l.'
        ),
        'ISO 14001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'DNV Business Assurance Italy S.r.l.'
        ),
        'ISO 45001',
        33,
        'ACTIVE',
        'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'
    ),
    -- RINA Services
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'RINA Services S.p.A.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.accredia.it/en/organism/rina-services-s-p-a/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'RINA Services S.p.A.'
        ),
        'ISO 14001',
        33,
        'ACTIVE',
        'https://www.accredia.it/en/organism/rina-services-s-p-a/'
    ),
    -- Kiwa Cermet Italia
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Kiwa Cermet Italia S.p.A.'
        ),
        'ISO 9001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/kiwa-cermet-italia/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Kiwa Cermet Italia S.p.A.'
        ),
        'ISO 45001',
        28,
        'ACTIVE',
        'https://www.accredia.it/en/organism/kiwa-cermet-italia/'
    ),
    -- CertRom
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'CertRom S.R.L.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'CertRom S.R.L.'
        ),
        'ISO 14001',
        28,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'CertRom S.R.L.'
        ),
        'ISO 45001',
        33,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ),
    -- SRAC CERT
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SRAC CERT S.R.L.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'SRAC CERT S.R.L.'
        ),
        'ISO 14001',
        33,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ),
    -- Certind
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Certind S.A.'
        ),
        'ISO 9001',
        37,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ), -- demo
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Certind S.A.'
        ),
        'ISO 9001',
        28,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'Certind S.A.'
        ),
        'ISO 45001',
        28,
        'ACTIVE',
        'https://www.renar.ro/lista-organisme-acreditate/'
    ),
    -- TUV Nord Polska
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Nord Polska Sp. z o.o.'
        ),
        'ISO 9001',
        33,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'TUV Nord Polska Sp. z o.o.'
        ),
        'ISO 14001',
        28,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ),
    -- PRS Polski Rejestr Statkow
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'PRS Polski Rejestr Statkow S.A.'
        ),
        'ISO 9001',
        28,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'PRS Polski Rejestr Statkow S.A.'
        ),
        'ISO 45001',
        28,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ),
    -- URS Polska
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'URS Polska Sp. z o.o.'
        ),
        'ISO 9001',
        33,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ),
    (
        (
            SELECT
                id
            FROM
                cb
            WHERE
                name = 'URS Polska Sp. z o.o.'
        ),
        'ISO 14001',
        33,
        'ACTIVE',
        'https://www.pca.gov.pl/akredytowane-podmioty/'
    ) ON CONFLICT DO NOTHING;