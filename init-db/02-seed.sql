-- Idempotent reference and demonstration data for all accreditation bodies.
-- Demo EA assignments are determined by the CAB's certified field, not its NAB.
-- For example: food=EA 03, construction=EA 28, IT=EA 33,
-- engineering=EA 34, education=EA 37. Confirm real schedules at the source.
BEGIN;

INSERT INTO ea_sector (code, name_en, name_it) VALUES
    (1, 'Agriculture, fishing', 'Agricoltura e pesca'),
    (2, 'Mining and quarrying', 'Attività estrattive'),
    (3, 'Food products, beverages and tobacco', 'Prodotti alimentari, bevande e tabacco'),
    (4, 'Textiles and textile products', 'Tessili e prodotti tessili'),
    (5, 'Leather and leather products', 'Pelli e prodotti in pelle'),
    (6, 'Wood and wood products', 'Legno e prodotti in legno'),
    (7, 'Pulp, paper and paper products', 'Pasta di legno, carta e prodotti di carta'),
    (8, 'Publishing companies', 'Case editrici'),
    (9, 'Printing companies', 'Stampa'),
    (10, 'Refined petroleum products', 'Prodotti petroliferi raffinati'),
    (11, 'Nuclear fuel', 'Combustibile nucleare'),
    (12, 'Chemicals and chemical products', 'Prodotti chimici'),
    (13, 'Pharmaceuticals', 'Prodotti farmaceutici'),
    (14, 'Rubber and plastic products', 'Gomma e materie plastiche'),
    (15, 'Non-metallic mineral products', 'Prodotti minerali non metalliferi'),
    (16, 'Concrete, cement, lime, plaster', 'Calcestruzzo, cemento, calce e gesso'),
    (17, 'Basic metals and fabricated metal products', 'Metalli di base e prodotti in metallo'),
    (18, 'Machinery and equipment', 'Macchinari e apparecchiature'),
    (19, 'Electrical and optical equipment', 'Apparecchiature elettriche e ottiche'),
    (20, 'Shipbuilding', 'Cantieristica navale'),
    (21, 'Aerospace', 'Aerospaziale'),
    (22, 'Other transport equipment', 'Altri mezzi di trasporto'),
    (23, 'Manufacturing not elsewhere classified', 'Manifatturiero non classificato altrove'),
    (24, 'Recycling', 'Riciclaggio'),
    (25, 'Electricity supply', 'Fornitura di energia elettrica'),
    (26, 'Gas supply', 'Fornitura di gas'),
    (27, 'Water supply', 'Fornitura di acqua'),
    (28, 'Construction', 'Costruzioni'),
    (29, 'Wholesale and retail trade', 'Commercio all’ingrosso e al dettaglio'),
    (30, 'Hotels and restaurants', 'Alberghi e ristoranti'),
    (31, 'Transport, storage and communication', 'Trasporti, magazzinaggio e comunicazioni'),
    (32, 'Financial intermediation, real estate and renting', 'Intermediazione finanziaria, immobili e noleggio'),
    (33, 'Information technology', 'Tecnologie dell’informazione'),
    (34, 'Engineering services', 'Servizi di ingegneria'),
    (35, 'Other services', 'Altri servizi'),
    (36, 'Public administration', 'Amministrazione pubblica'),
    (37, 'Education', 'Istruzione'),
    (38, 'Health and social work', 'Sanità e assistenza sociale'),
    (39, 'Other social services', 'Altri servizi sociali')
ON CONFLICT (code) DO UPDATE SET
    name_en = EXCLUDED.name_en,
    name_it = EXCLUDED.name_it;

INSERT INTO iso_standard (code, kind, scheme) VALUES
    ('ISO 9001', 'CERTIFICATION', 'MANAGEMENT_SYSTEM'),
    ('ISO 14001', 'CERTIFICATION', 'MANAGEMENT_SYSTEM'),
    ('ISO 45001', 'CERTIFICATION', 'MANAGEMENT_SYSTEM'),
    ('ISO/IEC 17021-1', 'ACCREDITATION', 'MANAGEMENT_SYSTEM'),
    ('ISO/IEC 17065', 'ACCREDITATION', 'PRODUCT'),
    ('ISO/IEC 17024', 'ACCREDITATION', 'PERSONNEL'),
    ('ISO/IEC 17025', 'ACCREDITATION', 'LABORATORY'),
    ('ISO 15189', 'ACCREDITATION', 'MEDICAL_LABORATORY'),
    ('ISO/IEC 17020', 'ACCREDITATION', 'INSPECTION')
ON CONFLICT (code) DO UPDATE SET
    kind = EXCLUDED.kind,
    scheme = EXCLUDED.scheme;

-- ============================================================================
-- CertiFind demonstration seed data (international and Albanian organizations)
-- Scope rows use EA codes when the schedule is classified by sector; otherwise
-- ea_code is NULL and the source scope stays in scope_section.
-- ============================================================================

-- 1. Accreditation Bodies (5 European IAF-MLA Authorities)
INSERT INTO accreditation_bodies (code, name, country, is_iaf_mla, website) VALUES
    ('ACCREDIA', 'ACCREDIA - Ente Italiano di Accreditamento',  'Italy',          TRUE, 'https://www.accredia.it'),
    ('RENAR',    'RENAR - Asociatia de Acreditare din Romania', 'Romania',        TRUE, 'https://www.renar.ro'),
    ('PCA',      'PCA - Polskie Centrum Akredytacji',           'Poland',         TRUE, 'https://www.pca.gov.pl'),
    ('DAkkS',    'DAkkS - Deutsche Akkreditierungsstelle',      'Germany',        TRUE, 'https://www.dakks.de'),
    ('UKAS',     'UKAS - United Kingdom Accreditation Service', 'United Kingdom', TRUE, 'https://www.ukas.com'),
    ('DPA',      'Directorate of Accreditation (DPA)',           'Albania',        TRUE, 'http://www.dpa.gov.al/'),
    ('BATA',     'BATA - Institute for Accreditation of Bosnia and Herzegovina', 'Bosnia and Herzegovina', FALSE, 'https://www.bata.gov.ba')
ON CONFLICT (code) DO UPDATE SET
    name       = EXCLUDED.name,
    country    = EXCLUDED.country,
    is_iaf_mla = EXCLUDED.is_iaf_mla,
    website    = EXCLUDED.website;

-- Six active product certification bodies in BATA's register dated 2026-10-08.
-- The withdrawn/cancelled register dated 2026-09-07 lists different bodies;
-- withdrawn accreditations are not added. Product scopes are ISO/IEC 17065,
-- not ISO management-system scopes, and do not use EA codes in this data model.
WITH ab AS (SELECT id FROM accreditation_bodies WHERE code = 'BATA')
INSERT INTO certification_bodies
    (name, country, accreditation_body_id, phone, email, website, address)
VALUES
    ('Institute for Construction, Construction Materials and Non-Metals - Department for Certification of Construction Materials', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 35 25 80 83', NULL, NULL, 'Kojšino 29, 75000 Tuzla'),
    ('PRO-MOST d.o.o. Mostar', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 36 33 41 88', NULL, NULL, 'Kralja Petra Krešimira IV. 14, 88000 Mostar'),
    ('Federal Institute for Agriculture - Certification Body for Products', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 33 774 241', NULL, NULL, 'Butmirska cesta 40, 71000 Sarajevo'),
    ('Civil Institute Banja Luka - Research and Development Center 1', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 51 492 118', 'sert@institutbl.com', NULL, 'Ada 24, 78000 Banja Luka'),
    ('Federal Agro-Mediterranean Institute - Verification Body', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 36 335 064', 'marijo.leko@faz.gov.ba', NULL, 'Biskupa Čule 10, 88000 Mostar'),
    ('IRC d.o.o.', 'Bosnia and Herzegovina', (SELECT id FROM ab), '+387 66 022 515', 'ejla.putes@inza.ba', NULL, 'Vuka Karadžića 30, 71123 East Sarajevo')
ON CONFLICT (name) DO UPDATE SET
    country = EXCLUDED.country,
    accreditation_body_id = EXCLUDED.accreditation_body_id,
    phone = EXCLUDED.phone,
    email = EXCLUDED.email,
    address = EXCLUDED.address;

-- 2. Activity Sector & ATECO Mappings (Supports both with ATECO and without ATECO)
INSERT INTO ateco_ea_mapping (ateco_code, description, ea_code, ea_description)
SELECT mapping.ateco_code, mapping.description, mapping.ea_code, mapping.ea_description
FROM (VALUES
    -- With Italian ATECO codes
    ('88.91.00', 'Asilo nido, servizi per l''infanzia e istruzione prescolare',          37, 'Education'),
    ('62.01.00', 'Produzione di software, consulenza informatica e cloud',               33, 'Information Technology'),
    ('41.20.00', 'Costruzione di edifici residenziali, non residenziali e opere civili', 28, 'Construction'),
    ('71.12.10', 'Attività di studi di ingegneria integrata e progettazione tecnica',    34, 'Engineering Services'),
    ('10.71.10', 'Produzione alimentare, prodotti di panetteria e bevande',              3,  'Food products, beverages and tobacco'),
    ('46.90.00', 'Commercio all''ingrosso, distribuzione e retail',                      29, 'Wholesale and retail trade'),
    ('56.10.11', 'Ristorazione con somministrazione, mense e alberghi',                  30, 'Hotels and restaurants'),
    ('25.62.00', 'Lavori di meccanica generale e carpenteria metallica',                 17, 'Basic metals and fabricated metal products'),
    -- Without ATECO code (Pure Activity Sector fallback entries)
    (NULL,       'Istruzione, formazione professionale, scuole e università',            37, 'Education'),
    (NULL,       'Servizi IT, sviluppo software, cybersecurity e data center',           33, 'Information Technology'),
    (NULL,       'Edilizia, cantieri, infrastrutture e impianti tecnologici',            28, 'Construction'),
    (NULL,       'Ingegneria civile, industriale, architettura e collaudi tecnici',      34, 'Engineering Services')
) AS mapping (ateco_code, description, ea_code, ea_description)
WHERE NOT EXISTS (
    SELECT 1
    FROM ateco_ea_mapping existing
    WHERE existing.ateco_code IS NOT DISTINCT FROM mapping.ateco_code
      AND existing.ea_code = mapping.ea_code
      AND existing.description = mapping.description
)
ON CONFLICT DO NOTHING;

-- 3. Example certification bodies by accreditation authority
WITH ab AS (SELECT id, code FROM accreditation_bodies)
INSERT INTO certification_bodies
    (name, country, accreditation_body_id, phone, email, website, address)
VALUES
    -- ITALY (ACCREDIA - 12 Bodies)
    ('SGS Italia S.p.A.',                   'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 02 73931',     'it.certification@sgs.com',    'https://www.sgs.com/it-it',                  'Via Caldera 21, 20153 Milano MI, Italia'),
    ('Bureau Veritas Italia S.p.A.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 02 270911',    'bvitalia@bureauveritas.com',  'https://www.bureauveritas.it',               'Viale Monza 347, 20126 Milano MI, Italia'),
    ('TÜV Rheinland Italia S.r.l.',         'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 02 9396871',   'info@it.tuv.com',             'https://www.tuv.com/it/italia',              'Via E. Mattei 3, 20005 Pogliano Milanese MI, Italia'),
    ('DNV Business Assurance Italy S.r.l.', 'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 039 6899905',  'certification.italy@dnv.com', 'https://www.dnv.it',                         'Via Energy Park 14, 20871 Vimercate MB, Italia'),
    ('RINA Services S.p.A.',                'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 010 53851',    'info@rina.org',               'https://www.rina.org',                       'Via Corsica 12, 16128 Genova GE, Italia'),
    ('Kiwa Cermet Italia S.p.A.',           'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 051 4593111',  'info@kiwacermet.it',          'https://www.kiwa.com/it',                    'Via Cadriano 23, 40057 Granarolo dell''Emilia BO, Italia'),
    ('CSQ - IMQ S.p.A.',                    'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 02 50731',     'info@imq.it',                 'https://www.imq.it',                         'Via Quintiliano 43, 20138 Milano MI, Italia'),
    ('Certiquality S.r.l.',                 'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 02 8069171',   'certiquality@certiquality.it','https://www.certiquality.it',                'Via Gaetano Giardino 4, 20123 Milano MI, Italia'),
    ('ICIM S.p.A.',                         'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 02 725341',    'info@icim.it',                'https://www.icim.it',                        'Piazza Don Enrico Mapelli 75, 20099 Sesto San Giovanni MI, Italia'),
    ('Quaser Certificazioni S.r.l.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 02 67479254',  'segreteria@quaser.org',       'https://www.quaser.org',                     'Via C. Imbonati 18, 20159 Milano MI, Italia'),
    ('AJA Registrars Europe S.r.l.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'),  '+39 06 85356701',  'roma@aeurope.eu',             'https://www.aeurope.eu',                     'Via Nomentana 257, 00161 Roma RM, Italia'),
    ('Global Group Italia S.r.l.',          'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), '+39 0546 686252',  'info@globalgroupitalia.it',   'https://www.globalgroupitalia.it',           'Via Correcchio 12, 47122 Forlì FC, Italia'),

    -- ROMANIA (RENAR - 9 Bodies)
    ('CertRom S.R.L.',                      'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),  '+40 21 310 4320',  'office@certrom.ro',           'https://www.certrom.ro',                     'Str. Calea Plevnei 139, 060011 Bucuresti, Romania'),
    ('SRAC CERT S.R.L.',                    'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), '+40 21 313 6335',  'office@srac.ro',              'https://www.srac.ro',                        'Str. Vasile Parvan 14, 010216 Bucuresti, Romania'),
    ('Certind S.A.',                        'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),  '+40 21 313 3651',  'office@certind.ro',           'https://www.certind.ro',                     'Str. George Enescu 27-29, 010303 Bucuresti, Romania'),
    ('SIMTEX-OC S.R.L.',                    'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),  '+40 21 317 0170',  'simtex@simtex.ro',            'https://www.simtex.ro',                      'Str. Maria Rosetti 10, 020485 Bucuresti, Romania'),
    ('ALL CERT PRODUCT S.R.L.',             'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), '+40 21 252 5555',  'office@allcert.ro',           'https://www.allcert.ro',                     'B-dul Chisinau 1, 022141 Bucuresti, Romania'),
    ('TÜV Austria Romania S.R.L.',          'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),  '+40 21 314 4300',  'bucuresti@tuvaustria.ro',     'https://www.tuvaustria.ro',                  'Calea Floreasca 169A, 014459 Bucuresti, Romania'),
    ('Q-CERT Romania S.R.L.',               'Romania', (SELECT id FROM ab WHERE code = 'RENAR'),  '+40 21 230 4567',  'romania@q-cert.com',          'https://www.q-cert.com',                     'Str. Av. Stefan Sanatescu 48, 011478 Bucuresti, Romania'),
    ('CERTSYS S.R.L.',                      'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), '+40 31 405 1234',  'office@certsys.ro',           'https://www.certsys.ro',                     'B-dul Unirii 64, 030834 Bucuresti, Romania'),
    ('MiNT Romania S.R.L.',                 'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), '+40 21 326 7788',  'contact@mintre.ro',           'https://www.mintre.ro',                      'Str. Vasile Conta 3-5, 020951 Bucuresti, Romania'),

    -- POLAND (PCA - 9 Bodies)
    ('TÜV Nord Polska Sp. z o.o.',          'Poland',  (SELECT id FROM ab WHERE code = 'PCA'), '+48 32 784 2800',  'biuro@tuv-nord.pl',           'https://www.tuv-nord.com/pl',                'ul. Mickiewicza 29, 40-085 Katowice, Polska'),
    ('PRS Polski Rejestr Statkow S.A.',     'Poland',  (SELECT id FROM ab WHERE code = 'PCA'), '+48 58 751 1100',  'prs@prs.pl',                  'https://www.prs.pl',                         'al. gen. J. Hallera 126, 80-416 Gdansk, Polska'),
    ('URS Polska Sp. z o.o.',               'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),  '+48 32 700 6910',  'info@urs-polska.pl',          'https://www.urs-polska.pl',                  'ul. Warszawska 31, 40-010 Katowice, Polska'),
    ('ZETOM Katowice Sp. z o.o.',           'Poland',  (SELECT id FROM ab WHERE code = 'PCA'), '+48 32 256 9257',  'zetom@zetom.katowice.pl',     'https://www.zetom.katowice.pl',              'ul. Ks. Bpa H. Bednorza 17, 40-384 Katowice, Polska'),
    ('PCBC S.A. - Polish Centre for Testing','Poland', (SELECT id FROM ab WHERE code = 'PCA'),  '+48 22 857 9916',  'pcbc@pcbc.gov.pl',            'https://www.pcbc.gov.pl',                    'ul. Klobucka 23A, 02-699 Warszawa, Polska'),
    ('ISOCERT Sp. z o.o.',                  'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),  '+48 71 780 4350',  'biuro@isocert.pl',            'https://www.isocert.pl',                     'ul. Kwidzynska 6e, 51-416 Wroclaw, Polska'),
    ('DEKRA Certification Sp. z o.o.',      'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),  '+48 71 787 0100',  'polska@dekra.com',            'https://www.dekra.pl',                       'ul. Legnicka 48H, 54-202 Wroclaw, Polska'),
    ('UDT-CERT (Urząd Dozoru Technicznego)','Poland',  (SELECT id FROM ab WHERE code = 'PCA'), '+48 22 572 2110',  'udt@udt.gov.pl',              'https://www.udt.gov.pl',                     'ul. Szczesliwicka 34, 02-353 Warszawa, Polska'),
    ('CCG Certification Sp. z o.o.',        'Poland',  (SELECT id FROM ab WHERE code = 'PCA'), '+48 12 345 6789',  'kontakt@ccg-cert.pl',         'https://www.ccg-cert.pl',                    'ul. Wielicka 72, 30-552 Krakow, Polska'),

    -- GERMANY (DAkkS - 3 Bodies)
    ('TÜV SÜD Management Service GmbH',     'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'),  '+49 89 5791 0',    'info@tuvsud.com',             'https://www.tuvsud.com/de-de',               'Westendstraße 199, 80686 München, Deutschland'),
    ('DQS GmbH',                            'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'),  '+49 69 95427 0',   'info@dqs.de',                 'https://www.dqs.de',                         'August-Schanz-Straße 21, 60433 Frankfurt am Main, Deutschland'),
    ('GUTcert GmbH',                        'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'), '+49 30 2332021 0', 'info@gut-cert.de',            'https://www.gut-cert.de',                    'Eichenstraße 3b, 12435 Berlin, Deutschland'),

    -- UNITED KINGDOM (UKAS - 3 Bodies)
    ('BSI Assurance UK Limited',            'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'),  '+44 345 080 9000', 'cservices@bsigroup.com', 'https://www.bsigroup.com',                   '389 Chiswick High Road, London W4 4AL, UK'),
    ('NQA Certification Ltd',               'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'),  '+44 800 052 2424', 'contact@nqa.com',        'https://www.nqa.com',                        'Warwick House, Houghton Hall Park, Dunstable LU5 5ZX, UK'),
    ('BM TRADA (Warringtonfire)',           'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'), '+44 1494 569700',  'enquiries@bmtrada.com',  'https://www.bmtrada.com',                    'Stocking Lane, Hughenden Valley, High Wycombe HP14 4ND, UK')
ON CONFLICT (name) DO UPDATE SET
    country               = EXCLUDED.country,
    accreditation_body_id = EXCLUDED.accreditation_body_id,
    phone                 = EXCLUDED.phone,
    email                 = EXCLUDED.email,
    website               = EXCLUDED.website,
    address               = EXCLUDED.address;

-- 4. Accredited Scopes (Every single organization has ISO + EA Code + Scope Section)
WITH cb AS (SELECT id, name FROM certification_bodies)
INSERT INTO accredited_scopes
    (certification_body_id, iso_standard, ea_code, scope_section, status, proof_url)
VALUES
    -- ==================== EA 37: EDUCATION / ASILO NIDO ====================
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'),                'ISO 9001',  37, 'Progettazione ed erogazione di servizi educativi per la prima infanzia, asili nido e formazione professionale', 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'),     'ISO 9001',  37, 'Gestione di strutture educative prescolari, asili nido comunali e privati ed enti di istruzione', 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Rheinland Italia S.r.l.'),      'ISO 9001',  37, 'Servizi didattici, formativi e gestione di centri per l''infanzia e scuole paritarie', 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),
    ((SELECT id FROM cb WHERE name = 'RINA Services S.p.A.'),             'ISO 9001',  37, 'Erogazione di servizi di istruzione, asili nido, ludoteche e formazione continua', 'ACTIVE', 'https://www.accredia.it/en/organism/rina-services-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'CSQ - IMQ S.p.A.'),                 'ISO 9001',  37, 'Erogazione di percorsi formativi accreditati, asili nido e centri educativi per l''infanzia', 'ACTIVE', 'https://www.accredia.it/organismi/imq/'),
    ((SELECT id FROM cb WHERE name = 'Certiquality S.r.l.'),              'ISO 9001',  37, 'Servizi per l''istruzione pre-scolare, gestione mense didattiche e strutture per l''infanzia', 'ACTIVE', 'https://www.accredia.it/organismi/certiquality/'),
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'),                   'ISO 9001',  37, 'Servizi di istruzione prescolare, asili nido e centri di formazione accreditati (IAF-MLA)', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'SRAC CERT S.R.L.'),                 'ISO 9001',  37, 'Sistemi di gestione qualità per istituti scolastici, asili nido e servizi socio-educativi', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'),                     'ISO 9001',  37, 'Certificazione di servizi educativi, formazione professionale e strutture per la prima infanzia', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'SIMTEX-OC S.R.L.'),                 'ISO 9001',  37, 'Servizi educativi, centri per l''infanzia e istituti di istruzione primaria e prescolare', 'ACTIVE', 'https://www.renar.ro/organisme/simtex/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Austria Romania S.R.L.'),       'ISO 9001',  37, 'Erogazione di servizi educativi per la prima infanzia, asili nido e strutture diurne', 'ACTIVE', 'https://www.renar.ro/organisme/tuv-austria/'),
    ((SELECT id FROM cb WHERE name = 'ISOCERT Sp. z o.o.'),               'ISO 9001',  37, 'Ispezione e certificazione di sistemi di gestione per scuole materne, asili nido ed enti formativi', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/isocert/'),
    ((SELECT id FROM cb WHERE name = 'BSI Assurance UK Limited'),         'ISO 9001',  37, 'Governance e gestione qualità per servizi educativi prescolari, asili nido e istituti formativi', 'ACTIVE', 'https://www.ukas.com/cabs/bsi/'),
    ((SELECT id FROM cb WHERE name = 'MiNT Romania S.R.L.'),              'ISO 45001', 37, 'Salute e sicurezza sul lavoro nelle strutture scolastiche, asili nido e centri ricreativi', 'ACTIVE', 'https://www.renar.ro/organisme/mint/'),

    -- ==================== EA 33: INFORMATION TECHNOLOGY ====================
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'),                'ISO 9001',  33, 'Progettazione, sviluppo, manutenzione di software applicativo e servizi di cloud computing', 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'),     'ISO 14001', 33, 'Gestione ambientale di data center, infrastrutture server e uffici di sviluppo software', 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Rheinland Italia S.r.l.'),      'ISO 9001',  33, 'Sviluppo software, system integration, assistenza IT e consulenza informatica aziendale', 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'),'ISO 45001',33, 'Gestione salute e sicurezza per operatori ICT, data center e installazione reti', 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),
    ((SELECT id FROM cb WHERE name = 'RINA Services S.p.A.'),             'ISO 14001', 33, 'Efficienza ambientale e sostenibilità per infrastrutture digitali, telecomunicazioni e IT', 'ACTIVE', 'https://www.accredia.it/en/organism/rina-services-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'ICIM S.p.A.'),                      'ISO 9001',  33, 'Progettazione e sviluppo di soluzioni software web, piattaforme SaaS e sistemi informativi enterprise', 'ACTIVE', 'https://www.accredia.it/organismi/icim/'),
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'),                   'ISO 45001', 33, 'Sicurezza sul lavoro per aziende di sviluppo software, outsourcing IT e centri elaborazione dati', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'SRAC CERT S.R.L.'),                 'ISO 14001', 33, 'Sistemi di gestione ambientale per poli tecnologici, software house e servizi informatici', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'ALL CERT PRODUCT S.R.L.'),          'ISO 9001',  33, 'Servizi di tecnologia dell''informazione, gestione database e sviluppo software su misura', 'ACTIVE', 'https://www.renar.ro/organisme/allcert/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Nord Polska Sp. z o.o.'),       'ISO 9001',  33, 'Ingegneria del software, gestione progetti IT e servizi di trasformazione digitale', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'URS Polska Sp. z o.o.'),            'ISO 9001',  33, 'Consulenza informatica, sviluppo portali enterprise, cybersecurity e supporto tecnico IT', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'URS Polska Sp. z o.o.'),            'ISO 14001', 33, 'Gestione ambientale delle operazioni IT, smaltimento hardware e green hosting', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'CCG Certification Sp. z o.o.'),     'ISO 9001',  33, 'Certificazione qualità per sviluppo applicazioni mobile, piattaforme cloud e assistenza software', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/ccg/'),
    ((SELECT id FROM cb WHERE name = 'DQS GmbH'),                         'ISO 9001',  33, 'Ingegneria del software, sviluppo infrastrutture cloud ed erogazione di servizi SaaS enterprise', 'ACTIVE', 'https://www.dakks.de/cabs/dqs/'),
    ((SELECT id FROM cb WHERE name = 'NQA Certification Ltd'),            'ISO 14001', 33, 'Operazioni green per data center, monitoraggio energetico e hosting IT sostenibile', 'ACTIVE', 'https://www.ukas.com/cabs/nqa/'),

    -- ==================== EA 28: CONSTRUCTION / EDILIZIA ====================
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'),                'ISO 14001', 28, 'Gestione ambientale di cantieri edili, opere di ingegneria civile e recupero ambientale', 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'SGS Italia S.p.A.'),                'ISO 45001', 28, 'Salute e sicurezza nei cantieri edili, lavori stradali e installazione impianti civili', 'ACTIVE', 'https://www.accredia.it/en/organism/sgs-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'Bureau Veritas Italia S.p.A.'),     'ISO 45001', 28, 'Prevenzione infortuni e sicurezza sul lavoro in edilizia residenziale, industriale e grandi opere', 'ACTIVE', 'https://www.accredia.it/en/organism/bureau-veritas-italia-s-p-a/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Rheinland Italia S.r.l.'),      'ISO 14001', 28, 'Controllo impatto ambientale nella costruzione e manutenzione di edifici e infrastrutture', 'ACTIVE', 'https://www.accredia.it/en/organism/tuv-rheinland-italia-s-r-l/'),
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'),'ISO 9001', 28, 'Costruzione, ristrutturazione e manutenzione di edifici civili, industriali e opere pubbliche', 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),
    ((SELECT id FROM cb WHERE name = 'DNV Business Assurance Italy S.r.l.'),'ISO 14001',28, 'Sostenibilità ambientale nei processi di costruzione, demolizione e gestione terre da scavo', 'ACTIVE', 'https://www.accredia.it/en/organism/dnv-business-assurance-italy/'),
    ((SELECT id FROM cb WHERE name = 'Kiwa Cermet Italia S.p.A.'),        'ISO 9001',  28, 'Esecuzione di lavori edili, impiantistica tecnologica e opere generali di costruzione', 'ACTIVE', 'https://www.accredia.it/en/organism/kiwa-cermet-italia/'),
    ((SELECT id FROM cb WHERE name = 'Kiwa Cermet Italia S.p.A.'),        'ISO 45001', 28, 'Sistemi di gestione della sicurezza nei cantieri temporanei e mobili (Bando ISI INAIL)', 'ACTIVE', 'https://www.accredia.it/en/organism/kiwa-cermet-italia/'),
    ((SELECT id FROM cb WHERE name = 'Quaser Certificazioni S.r.l.'),     'ISO 14001', 28, 'Costruzione e ristrutturazione edifici civili ed industriali, gestione rifiuti di cantiere', 'ACTIVE', 'https://www.accredia.it/organismi/quaser/'),
    ((SELECT id FROM cb WHERE name = 'AJA Registrars Europe S.r.l.'),     'ISO 45001', 28, 'Gestione sicurezza sul lavoro per cantieri temporanei o mobili e grandi infrastrutture', 'ACTIVE', 'https://www.accredia.it/organismi/aja-europe/'),
    ((SELECT id FROM cb WHERE name = 'CertRom S.R.L.'),                   'ISO 14001', 28, 'Gestione ambientale per imprese di costruzioni civili, stradali e impiantistica', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'),                     'ISO 9001',  28, 'Controllo qualità nelle costruzioni edili, carpenteria strutturale e opere di urbanizzazione', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'Certind S.A.'),                     'ISO 45001', 28, 'Sicurezza e salute occupazionale nei lavori di costruzione, scavo e montaggio ponteggi', 'ACTIVE', 'https://www.renar.ro/lista-organisme-acreditate/'),
    ((SELECT id FROM cb WHERE name = 'CERTSYS S.R.L.'),                   'ISO 45001', 28, 'Controllo sicurezza nei cantieri di opere civili, costruzioni industriali e ristrutturazioni', 'ACTIVE', 'https://www.renar.ro/organisme/certsys/'),
    ((SELECT id FROM cb WHERE name = 'TÜV Nord Polska Sp. z o.o.'),       'ISO 14001', 28, 'Tutela ambientale nelle attività di costruzione generale e realizzazione infrastrutture', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'PRS Polski Rejestr Statkow S.A.'),  'ISO 9001',  28, 'Qualità esecutiva nelle opere di ingegneria civile, marittima e costruzioni industriali', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'PRS Polski Rejestr Statkow S.A.'),  'ISO 45001', 28, 'Gestione della sicurezza sul lavoro per cantieri edili, infrastrutturali e impiantistici', 'ACTIVE', 'https://www.pca.gov.pl/akredytowane-podmioty/'),
    ((SELECT id FROM cb WHERE name = 'DEKRA Certification Sp. z o.o.'),   'ISO 14001', 28, 'Mitigazione impatto ambientale nelle operazioni di costruzione generale e demolizione controllata', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/dekra/'),
    ((SELECT id FROM cb WHERE name = 'ZETOM Katowice Sp. z o.o.'),        'ISO 45001', 28, 'Certificazione sicurezza sul lavoro per imprese edili, montaggi strutturali e cantieristica', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/zetom/'),
    ((SELECT id FROM cb WHERE name = 'UDT-CERT (Urząd Dozoru Technicznego)'),'ISO 45001',28,'Sicurezza operativa nell''installazione di ascensori, gru di cantiere e impianti tecnologici edili', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/udt/'),
    ((SELECT id FROM cb WHERE name = 'TÜV SÜD Management Service GmbH'),  'ISO 45001', 28, 'Governance della sicurezza nelle grandi opere di ingegneria civile e gestione appaltatori edili', 'ACTIVE', 'https://www.dakks.de/cabs/tuvsud/'),
    ((SELECT id FROM cb WHERE name = 'BM TRADA (Warringtonfire)'),        'ISO 45001', 28, 'Prevenzione rischi di cantiere nell''installazione di strutture in legno, acciaio e prefabbricati', 'ACTIVE', 'https://www.ukas.com/cabs/bmtrada/'),

    -- ==================== EA 34: ENGINEERING SERVICES ====================
    ((SELECT id FROM cb WHERE name = 'Global Group Italia S.r.l.'),       'ISO 9001',  34, 'Studi di fattibilità tecnica, progettazione strutturale, direzione lavori e calcoli ingegneristici', 'ACTIVE', 'https://www.accredia.it/organismi/global-group/'),
    ((SELECT id FROM cb WHERE name = 'GUTcert GmbH'),                     'ISO 14001', 34, 'Valutazioni di impatto ambientale, progettazione energetica e consulenza ingegneristica sostenibile', 'ACTIVE', 'https://www.dakks.de/cabs/gutcert/'),
    ((SELECT id FROM cb WHERE name = 'PCBC S.A. - Polish Centre for Testing'),'ISO 9001',34,'Progettazione tecnica integrata, calcoli architettonici specialistici e collaudi ingegneristici', 'ACTIVE', 'https://www.pca.gov.pl/podmioty/pcbc/'),
    ((SELECT id FROM cb WHERE name = 'Q-CERT Romania S.R.L.'),            'ISO 45001', 34, 'Sicurezza nelle ispezioni ingegneristiche in campo, rilievi geotecnici e direzione cantieri', 'ACTIVE', 'https://www.renar.ro/organisme/qcert/')
ON CONFLICT (certification_body_id, iso_standard, ea_code) DO UPDATE SET
    scope_section = EXCLUDED.scope_section,
    status        = EXCLUDED.status,
    proof_url     = EXCLUDED.proof_url;

-- BATA ISO/IEC 17065 product-certification scopes. EA code is intentionally
-- NULL because the register certifies products, not an ISO management-system
-- sector. Details are transcribed from the active register (2026-10-08).
WITH cb AS (SELECT id, name FROM certification_bodies)
INSERT INTO accredited_scopes
    (certification_body_id, iso_standard, ea_code, scope_section, status, proof_url)
VALUES
    ((SELECT id FROM cb WHERE name = 'Institute for Construction, Construction Materials and Non-Metals - Department for Certification of Construction Materials'), 'ISO/IEC 17065', NULL, 'Product certification: cement; fraction stone aggregate for concrete and asphalt. Accreditation CP-04-02.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-04-02.pdf'),
    ((SELECT id FROM cb WHERE name = 'PRO-MOST d.o.o. Mostar'), 'ISO/IEC 17065', NULL, 'Construction products: structural bearings, aggregate for concrete production, concrete, bituminous mixtures. Accreditation CP-135-01.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-135-01.pdf'),
    ((SELECT id FROM cb WHERE name = 'Federal Institute for Agriculture - Certification Body for Products'), 'ISO/IEC 17065', NULL, 'Product certification: seeds (cereals, industrial plants-soy); planting material (vegetables, ornamental plants). Accreditation CP-67-02.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-67-02.pdf'),
    ((SELECT id FROM cb WHERE name = 'Civil Institute Banja Luka - Research and Development Center 1'), 'ISO/IEC 17065', NULL, 'Product certification: concrete aggregate and fly ash for concrete; bituminous mixtures. Accreditation CP-171-02.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-171-02.pdf'),
    ((SELECT id FROM cb WHERE name = 'Federal Agro-Mediterranean Institute - Verification Body'), 'ISO/IEC 17065', NULL, 'Planting materials, fruits, vegetables. Accreditation CP-45-02.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-45-02.pdf'),
    ((SELECT id FROM cb WHERE name = 'IRC d.o.o.'), 'ISO/IEC 17065', NULL, 'Product certification: self-supporting insulating sandwich panels. Accreditation CP-35-02.', 'ACTIVE', 'http://www.bata.gov.ba/Akreditirana_tijela/Dodaci/CP/CP-35-02.pdf')
ON CONFLICT (certification_body_id, iso_standard) WHERE ea_code IS NULL DO UPDATE SET
    scope_section = EXCLUDED.scope_section,
    status = EXCLUDED.status,
    proof_url = EXCLUDED.proof_url;


-- Albanian register records use the same certification_bodies and
-- accredited_scopes structure as every other country.
-- ============================================================================
-- Albanian Accreditation Register import
-- Source: database/albania_accreditation_scraper/notebook_llm.csv
-- 124 organizations; N/A values are stored as NULL.
-- Generated from the supplied CSV; rerunning this file updates existing rows.
-- ============================================================================

-- Older seeds created DPA while Albanian company rows referenced DA. Reuse
-- that authority row when upgrading a database that has only the old code.
UPDATE accreditation_bodies
SET code = 'DPA', name = 'Directorate of Accreditation (DPA)', country = 'Albania'
WHERE code = 'DPA'
  AND NOT EXISTS (SELECT 1 FROM accreditation_bodies WHERE code = 'DPA');

INSERT INTO accreditation_bodies (code, name, country, is_iaf_mla, website) VALUES
    ('DPA', 'Directorate of Accreditation (DPA)', 'Albania', TRUE, NULL)
ON CONFLICT (code) DO UPDATE SET
    name = EXCLUDED.name, country = EXCLUDED.country, is_iaf_mla = EXCLUDED.is_iaf_mla, website = EXCLUDED.website;
WITH da AS (SELECT id FROM accreditation_bodies WHERE code = 'DPA')
INSERT INTO certification_bodies
    (name, country, accreditation_body_id, phone, email, website, address)
VALUES
    ('“HTM” sh.p.k', 'Albania', (SELECT id FROM da), '+355672040118', 'info-htm.cert@gmail.com', NULL, 'Lagja Perash, Rr.Rrojej, Nr.44, Shkoder'),
    ('“TCPE” sh.p.k', 'Albania', (SELECT id FROM da), '+0682140584', 'info@tcpe.al', NULL, 'Rruga, “Maliq Muco“, pranë Bulevardit Zogu i Parë, Kodi Postar 1023, Tiranë.'),
    ('“CAREER CERT INSTITUTE” sh.p.k', 'Albania', (SELECT id FROM da), '+355692062961', 'arturcela69@yahoo.com', NULL, 'Pallati i Kultures, kati i II-të, Tiranë.'),
    ('“NOA CONTROL” sh.p.k', 'Albania', (SELECT id FROM da), '+355697501178', 'kledia.stefani@noacontrol.al', NULL, 'Adresa 1: Rr. "Nikolla Tupe", Ndertesa Nr.4, kati 1, Tiranë. Adresa 2: Aktivitetit që kryen: inspektimin e matesave të ujit: Njesia Bashkiake Nr.8, Pasuria e paluajtshme e regjistruar me numer 847/1,Tiranë. Adresa 3: Ativiteti që kryen: Inspektim fillestar dhe periodik i kushteve te komoditetit te mjeteve te transportit publik te udhetareve: Mjete motorike te transportit rrugor. Autostrada Tiranë – Durrës km:6'),
    ('H.V.A.T sh.p.k', 'Albania', (SELECT id FROM da), '+355697560789', 'Robertkoci05@gmail.com', NULL, 'Rruga “Zonja Çurre”, Pallati: Emir, Njësia Bashkiake Nr.1, Tiranë'),
    ('“ECIT” sh.p.k', 'Albania', (SELECT id FROM da), '+355693809171', 'ecitshpk@gmail.com', NULL, 'Rruga “Medar Shtylla”, Ndertesa Nr.30, Kati IV, Shkalla 2, Ap. 4/C2, Tiranë.'),
    ('“ALCERT” sh.p.k', 'Albania', (SELECT id FROM da), '+355697501178', 'alcertadm@gmail.com', NULL, 'Rruga: ”Abdyl Frashëri”, Nd nr.9 ( Pallati Vesa Center ) H.3, Ap. 18, 1019, Tiranë'),
    ('“Swiss Approval Albania” sh.p.k', 'Albania', (SELECT id FROM da), '+35544309515 / +355697073002', 'info@swissapproval.al', NULL, 'Rruga: “ Sami Frashëri“, Nertesa 19, Hyrja 8, Kodi Postar 1019 Tirane'),
    ('“CERTIS” sh.p.k', 'Albania', (SELECT id FROM da), '+3550672013321', 'info@certis.com.al', NULL, 'Rruga: Adem Jashari, Shkalla1, Ap.7, Tiranë'),
    ('“Austrian Institute of Exellence” sh.p.k', 'Albania', (SELECT id FROM da), '+355684026340', 'elektro@aie.al', NULL, 'Njësia Bashkiake Nr. 8, Rruga e Dibrës, përballë Vilës Gold, Kompleksi HALILI, Godina C, kati 9, Tiranë. n'),
    ('“UNICERT” sh.p.k', 'Albania', (SELECT id FROM da), '0696060774', 'info@unicert.al', NULL, 'Rruga “Adem Seit Kruja”, Pall.6/1, Shkalla.1, Ap.5, Tiranë'),
    ('“Electrical Body Certification (EBC)” sh.p.k', 'Albania', (SELECT id FROM da), '+355692090878', 'info@ebcalbania.com', 'www.ebcalbania.com', NULL),
    ('“AQScert” sh.p.k', 'Albania', (SELECT id FROM da), '0682097080', 'info@aqscert.org', 'www.aqscert.org', 'Rruga “Jusuf Vrioni”, Pallati 1, hyrja 6, Tiranë'),
    ('Drejtoria e Përgjithshme e Shërbimeve të Transportit Rrugor (DPSHTRR)', 'Albania', (SELECT id FROM da), '+355688015833', 'dpshtrr@dpshtrr.gov.al', 'www.dpshtrr.gov.al', NULL),
    ('“UNITEC-STUDIO” sh.p.k', 'Albania', (SELECT id FROM da), '0682055829', 'l_begaj@yahoo.com', NULL, 'Rruga “Reshit Çollaku”, Godina e Shallvareve, Hyrja 4, Apartamenti 45, Tiranë'),
    ('”AUTENTICERT Albania” sh.p.k', 'Albania', (SELECT id FROM da), '+393801467945 / 0692684637', 'Albania@autenticert.com', 'www.autenticert.com', 'Rruga Don Bosko, Trio Tower, Objekti 3, shkalla 8, kati 5, Tiranë.'),
    ('“AXE Register” sh.p.k', 'Albania', (SELECT id FROM da), '+355696037861', 'sokol.a@axe-register.com', 'www.axe-register.com', NULL),
    ('“SINTEA Matje Teknike” sh.p.k', 'Albania', (SELECT id FROM da), '0698229044', 'sintea15@gmail.com', NULL, 'Rruga Lord Bajron, Nd.54/1, Ap.6, Njësia Bashkiake nr.11, Tiranë'),
    ('“SARP & LAB” sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Autostrada Tiranë -Durrës, km 29, Fshati Vrrin, Komuna Rrashbull, Durrës.'),
    ('AL-INSPEKTIM sh.p.k', 'Albania', (SELECT id FROM da), '+355692045111', 'al.inspektim@yahoo.com', NULL, 'Zona Kadastrave 2978, nr. Pasurie 77/7, Pjezë, Xhafzotaj Durrës'),
    ('NOA CONTROL sh.p.k', 'Albania', (SELECT id FROM da), '+355697501178', 'kledia.stefani@noacontrol.al', NULL, 'Adresa 1: Rr. "Nikolla Tupe", Ndertesa Nr.4, kati 1, Tiranë. Adresa 2: Aktivitetit që kryen: inspektimin e matesave të ujit: Njesia Bashkiake Nr.8, Pasuria e paluajtshme e regjistruar me numer 847/1,Tiranë. Adresa 3: Ativiteti që kryen: Inspektim fillestar dhe periodik i kushteve te komoditetit te mjeteve te transportit publik te udhetareve: Mjete motorike te transportit rrugor. Autostrada Tiranë – Durrës km:6'),
    ('M.F.M.sh.p.k', 'Albania', (SELECT id FROM da), '+355696078562', 'm.f.m-shpk@live.com', NULL, 'Njësia bashkiake Nr.7, Rr.‘’Frosina Plaku , Pall Nr.21, kati I, Tiranë'),
    ('Almeta GmbH sh.p.k', 'Albania', (SELECT id FROM da), '+355686026444', 'info@almeta.al', NULL, 'Autostrada Tiranë-Durrës, Km 14, Tiranë'),
    ('HTT-High Tech Test sh.p.k', 'Albania', (SELECT id FROM da), '+355689088467', 'info@htt-al.com', NULL, 'Rr,Andrea Kushi.Nr.27,Apt.5,njesia Administrative Nr.7,Tirane'),
    ('ERGI PINK sh.p.k', 'Albania', (SELECT id FROM da), '+355674097992', 'info@ergipink.com', NULL, 'Ish Kombinati Metalurgjik, Uzina 12, Bradashesh, Elbasan'),
    ('Tech-Inspect sh.p.k', 'Albania', (SELECT id FROM da), '+355672016333', 'info@techinspect.al', NULL, 'Rr. Besnik Sykja, P. 30, Hyrja 2 / 12. Bashki/Komuna : Tiranë.'),
    ('SHPRESA-AL sh.p.k', 'Albania', (SELECT id FROM da), '+355682030617', 'shpresa.al@gmail.com', NULL, 'Rruga Urani Pano, Prapa Veve Center, pall: 11, Tiranë'),
    ('SWISS APPROVAL ALBANIA', 'Albania', (SELECT id FROM da), '+35544309515', 'info@swissapproval.al', 'www.swissapproval.al', 'Rr: Sami Frashëri, Nd. 19 hyrja 8, Kodi Postar 1019 Tirane'),
    ('NOA INSPECT sh.p.k', 'Albania', (SELECT id FROM da), '+355692062126', 'info@noainspect.al', NULL, 'Bulevardi Dëshmorët e Kombit, Kullat Binjake, Kati 2, Kodi Postar 1000, Tiranë'),
    ('“Electrical Inspection Services Albania” sh.p.k', 'Albania', (SELECT id FROM da), '+355699390872', 'info@eisa.al', NULL, 'Rruga “Shkëlqim Fusha”, Pallati 24/1, Shkalla 2, Kati i 2-te, Ap.4 Bashki/Komuna : Tiranë.'),
    ('ALCERT sh.p.k', 'Albania', (SELECT id FROM da), '+355697501178', 'alcertadm@gmail.com', NULL, 'Rruga: ”Abdyl Frashëri”, Nd nr.9 ( Pallati Vesa Center ) H.3, Ap. 18, 1019, Tiranë'),
    ('ECIT shpk', 'Albania', (SELECT id FROM da), '+355697501178', 'mirametaj@yahoo.com', NULL, 'Rruga “Medar Shtylla”, Ndertesa Nr.30, Kati IV, Shkalla 2, Ap. 4/C2, Tiranë.'),
    ('ISEI shpk', 'Albania', (SELECT id FROM da), '+355699959740', 'isei.ekspert@gmail.com', NULL, NULL),
    ('Siguria ne presion', 'Albania', (SELECT id FROM da), '+355699485977', 'siguriapresion@gmail.com', NULL, 'Fier Ballsh Zona Kadastrale 1090, Nr. Pasurie 2/406, Ish SMT, Ballsh'),
    ('ARJANI shpk', 'Albania', (SELECT id FROM da), '+355698562304', 'arjanitravel@yahoo.com', NULL, 'Lagjia Apollonia, rruga Brigada e 11 Sulmuese, pallati i Ri përballë bashkisë, kati 1, Fier.'),
    ('“ T C P E ” sh.p.k', 'Albania', (SELECT id FROM da), '355682140548', 'info@tcpe.al', NULL, 'Rruga, “Maliq Muco“, pranë Bulevardit Zogu i Parë, Kodi Postar 1023, Tiranë.'),
    ('3G sh.p.k.', 'Albania', (SELECT id FROM da), '+355684012086', 'laboratori3g@yahoo.com', NULL, 'Sheshi 2 Prilli, pas Rektorit të Universitetit, Shkodër'),
    ('UNICERT shpk', 'Albania', (SELECT id FROM da), '+355696060774', 'info@unicert.al', NULL, 'Rruga “Adem Seit Kruja”, Pall.6/1, Shkalla.1, Ap.5, Tiranë'),
    ('J-ENERGY shpk', 'Albania', (SELECT id FROM da), '+355672040118', 'info@j-energy.al', NULL, 'Rruga A.Goga Lagjia Nr 18, P 1056, H1, Shkalla 2 Durres'),
    ('DPSHTRR', 'Albania', (SELECT id FROM da), '+355688015833', 'dpshtrr@dpshtrr.gov.al', NULL, 'Rruga “Muhedin Llagani”, Nr. 10 Tiranë'),
    ('Alfa ATest', 'Albania', (SELECT id FROM da), '+355693777733', 'besnik.qoku@alfa-atest.al', NULL, '"Bajram Curri", Zona Kadastrale 8270, Kati II, Apartmenti No. 6, Pallati "Tekno Projekt", Njësia Bashkiake No. 5, Kodi Postar 1019 Tiranë'),
    ('“CERT – AL SOLUTION ” SH.P.K', 'Albania', (SELECT id FROM da), '+355684808602', 'certasolution@gmail.com', NULL, 'Rruga Gjin Bue Shpata, Godina Av. Vjetër, Hyrja 7, Ap.34, Tiranë'),
    ('EPAS CERTIFY“ sh.p.k', 'Albania', (SELECT id FROM da), '+3550698552208', 'epas.certify@gmail.com', NULL, 'Durrës Shijak, Lagjja Popullore, Rruga 29 Nëntori, Zona Kadastrale 3369, Nr.123, Shijak'),
    ('“Synergy-Inspect“ sh.p.k', 'Albania', (SELECT id FROM da), '+355688554626', 'info@synergy.com.al', NULL, 'Lagjia Nr.15 Rruga ‘Shën Maria ‘objekt me Nr.pasurie 9/38 dhe Zone Kadastrale 8511. Durrës'),
    ('Certification Service Albania,“C S A”sh.p.k', 'Albania', (SELECT id FROM da), '+355688089635', 'info@csa.al', NULL, 'Farkë e Vogël, Zona kadastrale 1605, Vol.6, fq. 154, Nr. Pasurie 219/12, Njësi Bashkiake Nr.2; Tiranë.'),
    ('“H.V.A.T” sh.p.k', 'Albania', (SELECT id FROM da), '+355697560789', 'robertkoci05@gmail.com', NULL, 'Rruga “Zonja Çurre”, Pallati: Emir, Njësia Bashkiake Nr.1, Tiranë'),
    ('“ ST 2 ” sh.p.k', 'Albania', (SELECT id FROM da), '+355696404753', NULL, NULL, 'Rruga Tish Daija, Godina Nr. G12, Kati 4/A, Komuna e Parisit, Tirane.'),
    ('E.T.I.S Sh.p.k', 'Albania', (SELECT id FROM da), '+355696705721', NULL, NULL, 'Rruga “Zihni Sako”, Pallati “Progeen”, Tiranë.'),
    ('''''Lift Service'''' shpk', 'Albania', (SELECT id FROM da), '+355692020818', 'hasani.kledi@yahoo.com', NULL, NULL),
    ('Metro Alb 12 shpk', 'Albania', (SELECT id FROM da), '+355682009731', 'metroalb@gmail.com', NULL, NULL),
    ('“Legal Cert” sh.p.k', 'Albania', (SELECT id FROM da), '+355692081842', 'info@legalcert.al', NULL, 'Njesia administrative nr 5, Rruga Tish Daija, kompleksi KIKA 2, Ndertesa 36, Shkalla 2(14), kati 2, Tiranë.'),
    ('AXE Register sh.p.k', 'Albania', (SELECT id FROM da), '+355696037861', 'sokol.a@axe-register.com', NULL, 'Sheshi “Skënderbej”, Pallati i Kulturës, Kati II, Nr.7, 1001, Tiranë'),
    ('AQSCERT sh.p.k.', 'Albania', (SELECT id FROM da), '+355682097080', 'info@aqscert.org', NULL, 'Rruga “Jusuf Vrioni”, Pallati 1, hyrja 6, Tiranë'),
    ('CAREER CERT INSTITUTE sh.p.k', 'Albania', (SELECT id FROM da), '+355692062961', NULL, NULL, 'Sheshi Skenderbej,Pallati i Kultures,Kati 1,Tirane.'),
    ('European Quality and Safety Control (EQSC) sh.p.k', 'Albania', (SELECT id FROM da), '+35542227674 / +355693368439', NULL, NULL, NULL),
    ('CERTIS sh.p.k.', 'Albania', (SELECT id FROM da), '+355672013321', 'info@certis.com.al', NULL, 'Rruga: Adem Jashari, Shkalla1, Ap.7, Tiranë'),
    ('UNICERT sh.p.k', 'Albania', (SELECT id FROM da), '+355696060774', 'info@unicert.al', NULL, 'Rruga “Adem Seit Kruja”, Pall.6/1, Shkalla.1, Ap.5, Tiranë'),
    ('WR ERN BERATUNG sh.p.k Cert-ERN', 'Albania', (SELECT id FROM da), '+3550693861911 / 00491756082549', 'silva.sala@certern.de', NULL, 'Rruga “Ali Progri”, Nd. 26, Hyrja 2, Njesia Bashkiake 9,Tiranë'),
    ('e - Cert sh.p.k', 'Albania', (SELECT id FROM da), '+355699902185', 'alba@e-cert.al', NULL, 'Adresa: Rruga “Mujo Ulqinaku”, Hyrja 1, Ap: 4, Njësia bashkiake Nr: 10, Kodi Postar 1001, Tiranë'),
    ('Risk Control Advisory – R.C.A shpk', 'Albania', (SELECT id FROM da), '+355699412741', NULL, NULL, 'Rruga Hysen Zaloshnja, Nd. 2, h. 4, ap. 16, - Tiranë'),
    ('“M.G BUGATTI CERTIFICATION” sh.p.k', 'Albania', (SELECT id FROM da), '+393299116015', 'direzione@bugatticertification.it', NULL, 'Rruga “Ndre Mjeda” ,Hyrja 13 AP 10 Tiranë.'),
    ('MSC certification shpk', 'Albania', (SELECT id FROM da), '+355672063632', 'hajdarajeneriko@gmail.com', NULL, 'Rruga "Ismail Qemali", Pallati 34/1, Apartamenti 3, Tiranë'),
    ('AUTENTICERT Albania sh.p.k', 'Albania', (SELECT id FROM da), '+393801467945', 'Albania@autenticert.com', NULL, 'Rruga Don Bosko, Trio Tower, Objekti 3, shkalla 8, kati 5, Tiranë.'),
    ('CERTI AL shpk', 'Albania', (SELECT id FROM da), '+355672020502', NULL, NULL, 'Adresa: FARKE Rruga Shyqyri Brari, Pallati Amfora, Shkalla nr 1, Kati 3, Ap.9, Tiranë.'),
    ('“Genius Lab” sh.p.k', 'Albania', (SELECT id FROM da), '+355695630679', 'info@geniuslab.al', 'www.geniuslab.al', 'Njësia Bashkiake Nr. 7, Rruga e Kavajës, Zona kadastrale nr. 8220, nr pasurie 6/343+1, Kodi postar 1023, Tiranë'),
    ('Pegasus Lab sh.p.k (PEGASUS MED)', 'Albania', (SELECT id FROM da), '+355684040167', 'info@pegasusmed.al', 'www.pegasusmed.al', NULL),
    ('“3P LIFE LOGISTIC” sh.p.k', 'Albania', (SELECT id FROM da), '+355696006784', 'Kolaneci.l@lifelog.al', NULL, 'Autostrada Tiranë-Durrës, Rruga dytësore, km 9, Godinë 3 katëshe, Zona kadestrale 2119, Nr pasurie 147/47 Kashar, Tiranë'),
    ('“SPITALI SALUS” Sh.A', 'Albania', (SELECT id FROM da), '00355689053555', 'laboratori@salus.al', 'www.salus.al', 'Rruga “Vidhe Gjata”, Nr. 16, Mëzez – Kashar, Autostrada Tiranë – Durrës'),
    ('ECCAT sh.p.k', 'Albania', (SELECT id FROM da), '++355673991111', 'eccat@eccat.al', NULL, 'Rr:”Irfan Tomini”, Pallati 50, Kati I, Tiranë'),
    ('ISHTI shpk', 'Albania', (SELECT id FROM da), '+383 44 156 786', NULL, 'www.ishti.gov.al', 'Rruga "Muhamet Gjollesha"Nr 54 Tirane'),
    ('NORD – COMAT sh.p.k', 'Albania', (SELECT id FROM da), '+355682098814', 'info@nordcomat.com', NULL, 'Rruga "Muhamet Deliu" , Pallat i Firmes "DODAJ", Kati I, afer Restorant Fresku, Dajt,Tiranë'),
    ('Noa Control sh.p.k', 'Albania', (SELECT id FROM da), '+355698116596', 'info@noadekra.com', 'www.noacontrol.al', 'Adresa 1: Rr. "Nikolla Tupe", Ndertesa Nr.4, kati 1, Tiranë. Adresa 2: Aktivitetit që kryen: inspektimin e matesave të ujit: Njesia Bashkiake Nr.8, Pasuria e paluajtshme e regjistruar me numer 847/1,Tiranë. Adresa 3: Ativiteti që kryen: Inspektim fillestar dhe periodik i kushteve te komoditetit te mjeteve te transportit publik te udhetareve: Mjete motorike te transportit rrugor. Autostrada Tiranë – Durrës km:6'),
    ('A.L.T.E.A & GEOSTUDIO 2000 shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Autostrada Tirane-Durrës, Km 12, Picar, Vore, Tiranë.'),
    ('HTT-High Tech Test SHPK', 'Albania', (SELECT id FROM da), '+355689088467', 'info@htt-al.com', 'www.htt-al.com', 'Rr,Andrea Kushi.Nr.27,Apt.5,njesia Administrative Nr.7,Tirane'),
    ('SARP & LAB sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Autostrada Tiranë -Durrës, km 29, Fshati Vrrin, Komuna Rrashbull, Durrës.'),
    ('Eko-Studio-Projekt sh.p.k', 'Albania', (SELECT id FROM da), '+355692077227', 'eko_studio@yahoo.com ', NULL, 'Blv. "Gjergj Fishta" , Nr.48, Tirane.'),
    ('VME Verifikim i Matesave Elektrik sh.p.k', 'Albania', (SELECT id FROM da), '+355 69 70 18 103', NULL, 'www.vme.al', 'Rr."Perlat Rexhepi", Pall "Kallfa", Kati 10/C, 1019, Njesia Nr.5, Tirane.'),
    ('UNIVERSITETI ALEKSANDER XHUVANI', 'Albania', (SELECT id FROM da), '+35542269097', 'info@dpa.gov.al', NULL, 'Pranë ish Kombinatit Metalurgjik Elbasan.'),
    ('Sherbimi Gjeologjik Shqiptar', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Blloku Vasil Shanto,Tiranë'),
    ('GR ALBANIA sh.p.k', 'Albania', (SELECT id FROM da), '+35544309515', 'info@gralbania.com', NULL, 'Rr: "Sami Frasheri", Nd. 19, H.9, KP 1019, Tirane'),
    ('Tenuis LABORATORIES', 'Albania', (SELECT id FROM da), '+355688042045', 'info@tenuis.al', NULL, 'Fshati Koxhas, 2.5Km nga Kryqezimi i Maminasit, 100 M nga Rruga Vore-Maminas, Kapanon, Zona Kadastrale 2255, Nr.Pasurise 20/38, Durres'),
    ('Go Green', 'Albania', (SELECT id FROM da), '+355 69 74 87 976', NULL, 'www.go-green.al', 'Rr:Margarita Tutulani,Pallati 29,Kati 1,Hyrja 31,Zk 8270,Tiranë'),
    ('ELBA', 'Albania', (SELECT id FROM da), '+355 4 265857 / +355 69 20 34 033', 'elba_projekt@yahoo.com', NULL, 'Rr: ”Dora D’Istria”, Pll. INSIG-ut, Nr.6, Tiranë'),
    ('ALB CONSULT 2', 'Albania', (SELECT id FROM da), '+355 69 20 80 982', NULL, NULL, 'Rr. "Artan Lenja", Tirane'),
    ('INSTITUTI STUDIMEVE AMBJENTALE', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga”Tish Daija”Ndermarja:4,H:14,Ap:24,Tirane'),
    ('ALBA BETON', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Njësia Administrative Petrele,Fshati Stërmas,Ura e Farkes,Tiranë.'),
    ('GEOTEST', 'Albania', (SELECT id FROM da), '+355 68 485 0982', NULL, 'www.sgailab.net', 'Autostrada Tiranë-Durrës,Km 2.Mëzez ,Kashar,Tiranë'),
    ('ECM STUDIO sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga:"Hasan Riza Pasha", Ndërtesa e Dhomës së Tregtisë, Kati III, Shkodër'),
    ('Qendra e Monitorimit te Mjedisit (QMM)', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga “Kastriotet” Pallati Mehillaj, Mezez, Tiranë'),
    ('Alpha Studio sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga: "Myrteza Topi", Pallati nr. 18, Kodi Postar 1017, dyqani nr. 23, Tiranë'),
    ('S.W.O.T sh.p.k', 'Albania', (SELECT id FROM da), '+355 69 83 90 970', NULL, NULL, 'Rr:”Xhanfie Keko”, Pallati Andi Konstruksion, Njësia Bashkiake Nr.4, Tiranë.'),
    ('BIO-V sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga Shaban Bardhoshi, Godina 2 katëshe nr.12, 1027, Njësia bashkiake Nr. 6, Tiranë'),
    ('Eko Geolab & Chimica sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Adresa: Rruga "Llazi Miho”, Lagja e Vjetër, Pranë Hotel Mustang ose Ikona, Vaqarr, Kombinat. Tiranë'),
    ('Alb Lab shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Kruje Halil, zona kadestrale nr.1921, nr.pasurie: 56/3, Durrës'),
    ('Enologic Group Shpk', 'Albania', (SELECT id FROM da), '+355 67 500 1101', NULL, 'www.enologic.al', 'Fabrika e qelqit, blloku i pallateve Derveni, Kulla 8/3, kutia postare 1000, Tirane'),
    ('Laboratori i Agjencisë Kombëtare të Mjedisit', 'Albania', (SELECT id FROM da), '+355 4 22371237', NULL, 'www.akm.gov.al', '“Sami Frashëri”, Godina Nr. 4,Tiranë'),
    ('Laborator ISUV', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga: “Aleksandër Moisiu”, Nr. 82, Tirane.'),
    ('Laboratori Fizikokimik i Mineraleve-Agjencia Kombëtare e Burimeve Natyrore (AKBN)', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga Bulevardi “Bajram Curri”, Blloku “Vasil Shanto”, Tiranë'),
    ('VITROS LAB shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga Jordan Misja, pranë kompleksit panorama,Tiranë'),
    ('Laboratori i UKT Ujësjellës Kanalizime ” sh.a', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Adresa 1. Rruga Jusuf Vrioni nr.5 Adresa 2. Impianti Bovillë Paskuqan'),
    ('I.T.M shpk', 'Albania', (SELECT id FROM da), '+355 67 20 52 135 / +355 69 70 50 320', NULL, NULL, 'Lagjja Mëzez, Rruga Mbikalimi i Kamzës, Pallati Mëhillaj, Nr.1, Kati 0, Kashar, Tiranë.'),
    ('AQSCERT shpk', 'Albania', (SELECT id FROM da), '+355 68 20 97 080', NULL, 'www.aqscert.org', 'Rruga “Jusuf Vrioni”, Pallati 1, hyrja 6, Tiranë'),
    ('Laboratori A - Consultant', 'Albania', (SELECT id FROM da), '+355 69 60 32 083', NULL, 'www.aconsultant.com', 'Njësia Bashkiake nr.11, Rruga “Elez Isufi”, ndërtesë private nr, 1, Tiranë'),
    ('Studio Eko-Keshillim sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rr: "Muhamet Gjollesha”, Pallati 2/3, shk.2, kati 5, Ap.14, Tiranë'),
    ('GTS-Gazra Teknike Shqiptare shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga: “Lekë Zaharia”,Vaqarr, Tiranë.'),
    ('S G S ALBANIA sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Bulevardi “Gjergj Fishta”, Pallati Alpas, kati 8 Njësia Bashkiake Nr.7, Tiranë'),
    ('Laboratori Qendror i Restaurimit Drejtoria e Përgjithshme e Arkivave', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Adresa: Rruga “Jordan Misja”, Nr. 8303, Tiranë'),
    ('Drejtoria e Laboratorit Doganor', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga ``Ali Bakiu``, pranë sheshit ``Shqiponja``, Laprakë, Tiranë'),
    ('BERDICA CEMENT', 'Albania', (SELECT id FROM da), NULL, NULL, 'www.berdicacement.al', 'Adresa: Xhafzotaj, 2019, Durrës'),
    ('Instituti i Ndërtimit, Drejtoria e Laboratorëve', 'Albania', (SELECT id FROM da), '+355 69 33 73 372', NULL, NULL, 'Myslym Keta”, Brar, Tufinë, Tiranë'),
    ('EHW shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Superstrada Tiranë-Durrës, km 4.8, Tiranë'),
    ('Agjencia Kombëtare e Barnave dhe Pajisjeve Mjekësore Laboratori i Kontrollit', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rr. e Dibres nr 359/1 Tiranë'),
    ('ALBCHROME SHPK', 'Albania', (SELECT id FROM da), '+355 4 22 42 938', NULL, 'www.albchrome.al', 'Rruga Dervish Hima, Pallati Ambasador 3, Kati 1, Ap. 3, ZK. Nr. 8160, Tiranë'),
    ('LENI-ING sh.p.k', 'Albania', (SELECT id FROM da), '+355 69 26 19 231', NULL, NULL, 'Adresa: Rruga "Don Bosko”, Pallatet e Arabit, kulla 2, kati 1, Zona Kadestrale 8330, Nr. Pasurie 0/760-N2. Tiranë'),
    ('WATER BOUTIQUE sh.p.k', 'Albania', (SELECT id FROM da), '+355 69 800 2228', NULL, 'www.waterboutique.al', 'Adresa: Vangjel Noti, Blloku Gintash, Tiranë, & Rruga Jusuf Vrioni, Njesia Bashkiake nr.5, Pallati 1, Hyrja 2, Tirane.'),
    ('Rozafa shpk', 'Albania', (SELECT id FROM da), '+355 69 856 0866', NULL, 'www.rozafa.al', 'Adresa: Labinot – Fushë, ELBASAN'),
    ('Loerma shpk', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Lagjja:”Aqif Pasha”, Rr:”Rruga e Re”, Pallati nr. 500/3, kati 1, Elbasan.'),
    ('IBRA Labs shpk', 'Albania', (SELECT id FROM da), '+355 67 737 2488', NULL, NULL, 'Njësia Bashkiake Nr:5,Rr:”Irfan Tomini”,Nr:5,Kati:1,ZK 8260,Nr,Pasurie1/215-N3,Tiranë.'),
    ('INSPEKTORIATI SHTETEROR TEKNIK DHE INDUSTRIAL', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga Muhamet Gjollesha Nr.56 Tiranë'),
    ('ENTI SHTETËROR I FARËRAVE DHE FIDANËVE LABORATORI QËNDROR I TESTIMIT TË FARËRAVE (LQTF)', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, 'Rruga "Siri Kodra”, nr. 132, Tiranë'),
    ('Profarma sh.a', 'Albania', (SELECT id FROM da), '+355 69 40 45 619', NULL, 'www.profarma.al', 'Rruga "Skënder Vila" Nd.6/1007'),
    ('Laboratori i mjedisit universitetit Polis', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, NULL),
    ('VIELF STUDIO sh.p.k', 'Albania', (SELECT id FROM da), NULL, NULL, NULL, NULL)
ON CONFLICT (name) DO UPDATE SET
    country = EXCLUDED.country, accreditation_body_id = EXCLUDED.accreditation_body_id,
    phone = EXCLUDED.phone, email = EXCLUDED.email, website = EXCLUDED.website,
    address = EXCLUDED.address;

WITH cb AS (SELECT id, name FROM certification_bodies)
INSERT INTO accredited_scopes
    (certification_body_id, iso_standard, ea_code, scope_section, status, proof_url, accreditation_date, expiration_date)
VALUES
    ((SELECT id FROM cb WHERE name = '“HTM” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Electrical safety & high-voltage installation operators)', 'ACTIVE', NULL, '2023-11-21', '2027-11-20'),
    ((SELECT id FROM cb WHERE name = '“HTM” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Electrical safety & high-voltage installation operators)', 'ACTIVE', NULL, '2023-11-21', '2027-11-20'),
    ((SELECT id FROM cb WHERE name = '“TCPE” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Technical safety of electrical installations & high-voltage lines)', 'ACTIVE', NULL, '2023-11-21', '2027-11-20'),
    ((SELECT id FROM cb WHERE name = '“TCPE” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Technical safety of electrical installations & high-voltage lines)', 'ACTIVE', NULL, '2023-11-21', '2027-11-20'),
    ((SELECT id FROM cb WHERE name = '“CAREER CERT INSTITUTE” sh.p.k'), 'ISO/IEC 17024', 35, 'Other Services / Education (Auditors & technical trades qualification)', 'EXPIRED', NULL, '2022-02-01', '2026-01-31'),
    ((SELECT id FROM cb WHERE name = '“CAREER CERT INSTITUTE” sh.p.k'), 'ISO/IEC 17024', 37, 'Other Services / Education (Auditors & technical trades qualification)', 'EXPIRED', NULL, '2022-02-01', '2026-01-31'),
    ((SELECT id FROM cb WHERE name = '“NOA CONTROL” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Construction (Pressure vessels, lifts & electrical equipment personnel)', 'EXPIRED', NULL, '2022-05-10', '2026-05-09'),
    ((SELECT id FROM cb WHERE name = '“NOA CONTROL” sh.p.k'), 'ISO/IEC 17024', 28, 'Machinery / Construction (Pressure vessels, lifts & electrical equipment personnel)', 'EXPIRED', NULL, '2022-05-10', '2026-05-09'),
    ((SELECT id FROM cb WHERE name = 'H.V.A.T sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Electrical personnel certification)', 'ACTIVE', NULL, '2024-04-30', '2028-04-29'),
    ((SELECT id FROM cb WHERE name = 'H.V.A.T sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Electrical personnel certification)', 'ACTIVE', NULL, '2024-04-30', '2028-04-29'),
    ((SELECT id FROM cb WHERE name = '“ECIT” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Wholesale & retail (Pressure vessels, steam boilers & gas storage tanks personnel)', 'ACTIVE', NULL, '2024-04-21', '2028-04-20'),
    ((SELECT id FROM cb WHERE name = '“ECIT” sh.p.k'), 'ISO/IEC 17024', 23, 'Machinery / Wholesale & retail (Pressure vessels, steam boilers & gas storage tanks personnel)', 'ACTIVE', NULL, '2024-04-21', '2028-04-20'),
    ((SELECT id FROM cb WHERE name = '“ALCERT” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Construction (Electrical equipment, pressure equipment & lift maintenance personnel)', 'ACTIVE', NULL, '2024-12-16', '2028-12-15'),
    ((SELECT id FROM cb WHERE name = '“ALCERT” sh.p.k'), 'ISO/IEC 17024', 28, 'Machinery / Construction (Electrical equipment, pressure equipment & lift maintenance personnel)', 'ACTIVE', NULL, '2024-12-16', '2028-12-15'),
    ((SELECT id FROM cb WHERE name = '“Swiss Approval Albania” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Construction (Pressure equipment, LPG tanks, cranes & lifting machinery operators)', 'ACTIVE', NULL, '2024-11-11', '2028-11-10'),
    ((SELECT id FROM cb WHERE name = '“Swiss Approval Albania” sh.p.k'), 'ISO/IEC 17024', 28, 'Machinery / Construction (Pressure equipment, LPG tanks, cranes & lifting machinery operators)', 'ACTIVE', NULL, '2024-11-11', '2028-11-10'),
    ((SELECT id FROM cb WHERE name = '“CERTIS” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Business services (Tradesmen, painters, banking & technical professions)', 'EXPIRED', NULL, '2022-07-08', '2026-07-07'),
    ((SELECT id FROM cb WHERE name = '“CERTIS” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Business services (Tradesmen, painters, banking & technical professions)', 'EXPIRED', NULL, '2022-07-08', '2026-07-07'),
    ((SELECT id FROM cb WHERE name = '“Austrian Institute of Exellence” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Electrical safety & technical installations personnel)', 'EXPIRED', NULL, '2022-08-22', '2026-08-21'),
    ((SELECT id FROM cb WHERE name = '“Austrian Institute of Exellence” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Electrical safety & technical installations personnel)', 'EXPIRED', NULL, '2022-08-22', '2026-08-21'),
    ((SELECT id FROM cb WHERE name = '“UNICERT” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Construction (Pressure equipment, elevators & energy management auditors)', 'ACTIVE', NULL, '2022-09-06', '2030-09-04'),
    ((SELECT id FROM cb WHERE name = '“UNICERT” sh.p.k'), 'ISO/IEC 17024', 28, 'Machinery / Construction (Pressure equipment, elevators & energy management auditors)', 'ACTIVE', NULL, '2022-09-06', '2030-09-04'),
    ((SELECT id FROM cb WHERE name = '“Electrical Body Certification (EBC)” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Low & high voltage electrical installation personnel)', 'EXPIRED', NULL, '2023-05-25', '2024-10-23'),
    ((SELECT id FROM cb WHERE name = '“Electrical Body Certification (EBC)” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Low & high voltage electrical installation personnel)', 'EXPIRED', NULL, '2023-05-25', '2024-10-23'),
    ((SELECT id FROM cb WHERE name = '“AQScert” sh.p.k'), 'ISO/IEC 17024', 18, 'Machinery / Business services (Pressure equipment, lifts, electrical lines & management system auditors)', 'ACTIVE', NULL, '2023-11-07', '2027-11-06'),
    ((SELECT id FROM cb WHERE name = '“AQScert” sh.p.k'), 'ISO/IEC 17024', 35, 'Machinery / Business services (Pressure equipment, lifts, electrical lines & management system auditors)', 'ACTIVE', NULL, '2023-11-07', '2027-11-06'),
    ((SELECT id FROM cb WHERE name = 'Drejtoria e Përgjithshme e Shërbimeve të Transportit Rrugor (DPSHTRR)'), 'ISO/IEC 17024', 31, 'Transport, storage and communication (Road transport managers, ADR & professional vehicle drivers)', 'ACTIVE', NULL, '2024-06-24', '2028-06-23'),
    ((SELECT id FROM cb WHERE name = '“UNITEC-STUDIO” sh.p.k'), 'ISO/IEC 17024', 28, 'Construction / Electricity supply (Electrical power lines, switchgear & installations personnel)', 'ACTIVE', NULL, '2025-07-03', '2029-07-02'),
    ((SELECT id FROM cb WHERE name = '“UNITEC-STUDIO” sh.p.k'), 'ISO/IEC 17024', 35, 'Construction / Electricity supply (Electrical power lines, switchgear & installations personnel)', 'ACTIVE', NULL, '2025-07-03', '2029-07-02'),
    ((SELECT id FROM cb WHERE name = '”AUTENTICERT Albania” sh.p.k'), 'ISO/IEC 17024', 33, 'Information technology / Business services (ISO management auditors & digital competence Digcomp)', 'ACTIVE', NULL, '2026-06-12', '2030-06-11'),
    ((SELECT id FROM cb WHERE name = '”AUTENTICERT Albania” sh.p.k'), 'ISO/IEC 17024', 35, 'Information technology / Business services (ISO management auditors & digital competence Digcomp)', 'ACTIVE', NULL, '2026-06-12', '2030-06-11'),
    ((SELECT id FROM cb WHERE name = '“AXE Register” sh.p.k'), 'ISO/IEC 17024', 35, 'Other Services / Professional verification (Management systems auditors ISO 9001, 14001, 22000, 27001)', 'ACTIVE', NULL, '2020-12-18', '2030-07-20'),
    ((SELECT id FROM cb WHERE name = '“SINTEA Matje Teknike” sh.p.k'), 'ISO/IEC 17025', 16, 'Concrete, cement, lime / Construction (Calibration of non-automatic weighing instruments & asphalt concrete dosing plants)', 'ACTIVE', NULL, '2024-09-29', '2028-09-28'),
    ((SELECT id FROM cb WHERE name = '“SINTEA Matje Teknike” sh.p.k'), 'ISO/IEC 17025', 28, 'Concrete, cement, lime / Construction (Calibration of non-automatic weighing instruments & asphalt concrete dosing plants)', 'ACTIVE', NULL, '2024-09-29', '2028-09-28'),
    ((SELECT id FROM cb WHERE name = '“SARP & LAB” sh.p.k'), 'ISO/IEC 17025', 16, 'Concrete, cement, lime / Construction (Calibration of non-automatic weighing instruments & mass scales)', 'ACTIVE', NULL, '2025-08-06', '2029-08-05'),
    ((SELECT id FROM cb WHERE name = '“SARP & LAB” sh.p.k'), 'ISO/IEC 17025', 28, 'Concrete, cement, lime / Construction (Calibration of non-automatic weighing instruments & mass scales)', 'ACTIVE', NULL, '2025-08-06', '2029-08-05'),
    ((SELECT id FROM cb WHERE name = 'AL-INSPEKTIM sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Machinery & pressure equipment)', 'ACTIVE', NULL, '2024-08-02', '2028-08-01'),
    ((SELECT id FROM cb WHERE name = 'NOA CONTROL sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 31 / EA 27 / EA 29 (Machinery & pressure equipment / Elevators / Transport inspection / Water & fuel metering)', 'ACTIVE', NULL, '2024-09-20', '2028-09-19'),
    ((SELECT id FROM cb WHERE name = 'NOA CONTROL sh.p.k'), 'ISO/IEC 17020', 31, 'EA 18 / EA 31 / EA 27 / EA 29 (Machinery & pressure equipment / Elevators / Transport inspection / Water & fuel metering)', 'ACTIVE', NULL, '2024-09-20', '2028-09-19'),
    ((SELECT id FROM cb WHERE name = 'NOA CONTROL sh.p.k'), 'ISO/IEC 17020', 27, 'EA 18 / EA 31 / EA 27 / EA 29 (Machinery & pressure equipment / Elevators / Transport inspection / Water & fuel metering)', 'ACTIVE', NULL, '2024-09-20', '2028-09-19'),
    ((SELECT id FROM cb WHERE name = 'NOA CONTROL sh.p.k'), 'ISO/IEC 17020', 29, 'EA 18 / EA 31 / EA 27 / EA 29 (Machinery & pressure equipment / Elevators / Transport inspection / Water & fuel metering)', 'ACTIVE', NULL, '2024-09-20', '2028-09-19'),
    ((SELECT id FROM cb WHERE name = 'M.F.M.sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Machinery & pressure equipment)', 'ACTIVE', NULL, '2024-10-13', '2028-10-29'),
    ((SELECT id FROM cb WHERE name = 'Almeta GmbH sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Machinery & pressure equipment)', 'ACTIVE', NULL, '2024-10-22', '2028-10-21'),
    ((SELECT id FROM cb WHERE name = 'HTT-High Tech Test sh.p.k'), 'ISO/IEC 17020', 25, 'EA 25 (Electricity supply & electrical installations)', 'ACTIVE', NULL, '2026-01-01', '2029-12-31'),
    ((SELECT id FROM cb WHERE name = 'ERGI PINK sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Machinery & pressure equipment)', 'EXPIRED', NULL, '2022-02-04', '2026-02-03'),
    ((SELECT id FROM cb WHERE name = 'Tech-Inspect sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Lifting equipment & elevators / Electricity supply)', 'ACTIVE', NULL, '2026-03-04', '2030-03-03'),
    ((SELECT id FROM cb WHERE name = 'Tech-Inspect sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Lifting equipment & elevators / Electricity supply)', 'ACTIVE', NULL, '2026-03-04', '2030-03-03'),
    ((SELECT id FROM cb WHERE name = 'SHPRESA-AL sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 / EA 31 (Pressure equipment / Electricity supply / Automotive & ADR inspection)', 'ACTIVE', NULL, '2026-07-22', '2030-07-21'),
    ((SELECT id FROM cb WHERE name = 'SHPRESA-AL sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 / EA 31 (Pressure equipment / Electricity supply / Automotive & ADR inspection)', 'ACTIVE', NULL, '2026-07-22', '2030-07-21'),
    ((SELECT id FROM cb WHERE name = 'SHPRESA-AL sh.p.k'), 'ISO/IEC 17020', 31, 'EA 18 / EA 25 / EA 31 (Pressure equipment / Electricity supply / Automotive & ADR inspection)', 'ACTIVE', NULL, '2026-07-22', '2030-07-21'),
    ((SELECT id FROM cb WHERE name = 'SWISS APPROVAL ALBANIA'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Elevators & cranes / Electrical installations)', 'ACTIVE', NULL, '2022-11-07', '2026-11-06'),
    ((SELECT id FROM cb WHERE name = 'SWISS APPROVAL ALBANIA'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Elevators & cranes / Electrical installations)', 'ACTIVE', NULL, '2022-11-07', '2026-11-06'),
    ((SELECT id FROM cb WHERE name = 'NOA INSPECT sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 27 / EA 29 (Pressure equipment / Water & fuel dispensers)', 'ACTIVE', NULL, '2023-12-11', '2027-12-10'),
    ((SELECT id FROM cb WHERE name = 'NOA INSPECT sh.p.k'), 'ISO/IEC 17020', 27, 'EA 18 / EA 27 / EA 29 (Pressure equipment / Water & fuel dispensers)', 'ACTIVE', NULL, '2023-12-11', '2027-12-10'),
    ((SELECT id FROM cb WHERE name = 'NOA INSPECT sh.p.k'), 'ISO/IEC 17020', 29, 'EA 18 / EA 27 / EA 29 (Pressure equipment / Water & fuel dispensers)', 'ACTIVE', NULL, '2023-12-11', '2027-12-10'),
    ((SELECT id FROM cb WHERE name = '“Electrical Inspection Services Albania” sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 / EA 31 (Elevators / Electrical installations & charging stations / Vehicles)', 'ACTIVE', NULL, '2024-06-01', '2028-05-31'),
    ((SELECT id FROM cb WHERE name = '“Electrical Inspection Services Albania” sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 / EA 31 (Elevators / Electrical installations & charging stations / Vehicles)', 'ACTIVE', NULL, '2024-06-01', '2028-05-31'),
    ((SELECT id FROM cb WHERE name = '“Electrical Inspection Services Albania” sh.p.k'), 'ISO/IEC 17020', 31, 'EA 18 / EA 25 / EA 31 (Elevators / Electrical installations & charging stations / Vehicles)', 'ACTIVE', NULL, '2024-06-01', '2028-05-31'),
    ((SELECT id FROM cb WHERE name = 'ALCERT sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Pressure equipment & elevators)', 'ACTIVE', NULL, '2024-06-28', '2028-06-27'),
    ((SELECT id FROM cb WHERE name = 'ECIT shpk'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Electrical installations)', 'ACTIVE', NULL, '2025-02-21', '2029-02-20'),
    ((SELECT id FROM cb WHERE name = 'ECIT shpk'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Electrical installations)', 'ACTIVE', NULL, '2025-02-21', '2029-02-20'),
    ((SELECT id FROM cb WHERE name = 'ISEI shpk'), 'ISO/IEC 17020', 25, 'EA 25 (Electricity supply & electrical installations)', 'WITHDRAWN', NULL, '2021-06-30', '2024-12-28'),
    ((SELECT id FROM cb WHERE name = 'Siguria ne presion'), 'ISO/IEC 17020', 18, 'EA 18 (Machinery & pressure equipment)', 'ACTIVE', NULL, '2025-12-29', '2029-12-28'),
    ((SELECT id FROM cb WHERE name = 'ARJANI shpk'), 'ISO/IEC 17020', 31, 'EA 31 (Transport & automotive inspection)', 'ACTIVE', NULL, '2021-02-09', '2029-02-07'),
    ((SELECT id FROM cb WHERE name = '“ T C P E ” sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Lifting machinery & containers / Electrical installations & grid lines)', 'ACTIVE', NULL, '2025-05-11', '2029-05-10'),
    ((SELECT id FROM cb WHERE name = '“ T C P E ” sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Lifting machinery & containers / Electrical installations & grid lines)', 'ACTIVE', NULL, '2025-05-11', '2029-05-10'),
    ((SELECT id FROM cb WHERE name = 'UNICERT shpk'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment & elevators / Industrial lifting gear / Electrical installations)', 'ACTIVE', NULL, '2026-09-06', '2030-09-05'),
    ((SELECT id FROM cb WHERE name = 'UNICERT shpk'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment & elevators / Industrial lifting gear / Electrical installations)', 'ACTIVE', NULL, '2026-09-06', '2030-09-05'),
    ((SELECT id FROM cb WHERE name = 'J-ENERGY shpk'), 'ISO/IEC 17020', 25, 'EA 25 (Electricity supply & low/high voltage electrical installations)', 'ACTIVE', NULL, '2023-01-26', '2027-01-25'),
    ((SELECT id FROM cb WHERE name = 'DPSHTRR'), 'ISO/IEC 17020', 31, 'EA 31 (Transport & vehicle technical inspection / Tachograph / Passenger comfort)', 'ACTIVE', NULL, '2023-04-19', '2027-04-18'),
    ((SELECT id FROM cb WHERE name = 'Alfa ATest'), 'ISO/IEC 17020', 18, 'EA 18 (Lifting equipment & elevators)', 'ACTIVE', NULL, '2023-11-22', '2027-11-21'),
    ((SELECT id FROM cb WHERE name = '“CERT – AL SOLUTION ” SH.P.K'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-06-19', '2028-06-18'),
    ((SELECT id FROM cb WHERE name = '“CERT – AL SOLUTION ” SH.P.K'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-06-19', '2028-06-18'),
    ((SELECT id FROM cb WHERE name = 'EPAS CERTIFY“ sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-09-10', '2028-09-09'),
    ((SELECT id FROM cb WHERE name = 'EPAS CERTIFY“ sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-09-10', '2028-09-09'),
    ((SELECT id FROM cb WHERE name = '“Synergy-Inspect“ sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-10-25', '2028-10-24'),
    ((SELECT id FROM cb WHERE name = '“Synergy-Inspect“ sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2024-10-25', '2028-10-24'),
    ((SELECT id FROM cb WHERE name = 'Certification Service Albania,“C S A”sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Passenger & freight elevators / Electrical installations)', 'ACTIVE', NULL, '2025-06-03', '2029-06-02'),
    ((SELECT id FROM cb WHERE name = 'Certification Service Albania,“C S A”sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Passenger & freight elevators / Electrical installations)', 'ACTIVE', NULL, '2025-06-03', '2029-06-02'),
    ((SELECT id FROM cb WHERE name = '“H.V.A.T” sh.p.k'), 'ISO/IEC 17020', 25, 'EA 25 (Electricity supply & electrical installations TU/TL)', 'ACTIVE', NULL, '2025-06-05', '2029-06-04'),
    ((SELECT id FROM cb WHERE name = '“ ST 2 ” sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 (Pressure equipment & hydrocarbon fuel tanks)', 'ACTIVE', NULL, '2025-09-25', '2029-09-24'),
    ((SELECT id FROM cb WHERE name = 'E.T.I.S Sh.p.k'), 'ISO/IEC 17020', 18, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2025-11-10', '2029-11-09'),
    ((SELECT id FROM cb WHERE name = 'E.T.I.S Sh.p.k'), 'ISO/IEC 17020', 25, 'EA 18 / EA 25 (Pressure equipment / Industrial lifting machinery / Electrical installations)', 'ACTIVE', NULL, '2025-11-10', '2029-11-09'),
    ((SELECT id FROM cb WHERE name = '''''Lift Service'''' shpk'), 'ISO/IEC 17020', 18, 'EA 18 (Lifting equipment & elevators)', 'SUSPENDED', NULL, '2023-12-13', '2024-08-09'),
    ((SELECT id FROM cb WHERE name = 'Metro Alb 12 shpk'), 'ISO/IEC 17020', 27, 'EA 27 / EA 29 (Water & fuel metering verification)', 'SUSPENDED', NULL, '2023-06-16', '2024-05-21'),
    ((SELECT id FROM cb WHERE name = 'Metro Alb 12 shpk'), 'ISO/IEC 17020', 29, 'EA 27 / EA 29 (Water & fuel metering verification)', 'SUSPENDED', NULL, '2023-06-16', '2024-05-21'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 17, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 18, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 24, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = '“Legal Cert” sh.p.k'), 'ISO/IEC 17021-1', 28, 'EA 01 (Agriculture) / EA 03 (Food) / EA 17 (Metals) / EA 18 (Machinery) / EA 24 (Recycling) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-12-16', '2029-12-15'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 2, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 4, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 5, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 6, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 7, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 8, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 9, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 10, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 12, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 37, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 38, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AXE Register sh.p.k'), 'ISO/IEC 17021-1', 39, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper) / EA 08 (Publishing) / EA 09 (Printing) / EA 10 (Refined petroleum) / EA 12 (Chemicals) / EA 37 (Education) / EA 38 (Health) / EA 39 (Other social services)', 'ACTIVE', NULL, '2026-02-24', '2030-02-23'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT sh.p.k.'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2026-03-27', '2030-03-26'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT sh.p.k.'), 'ISO/IEC 17021-1', 2, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2026-03-27', '2030-03-26'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT sh.p.k.'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2026-03-27', '2030-03-26'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT sh.p.k.'), 'ISO/IEC 17021-1', 4, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2026-03-27', '2030-03-26'),
    ((SELECT id FROM cb WHERE name = 'CAREER CERT INSTITUTE sh.p.k'), 'ISO/IEC 17021-1', 39, 'EA 39 (Other social services)', 'ACTIVE', NULL, '2022-12-02', '2026-12-01'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 3, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 4, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 5, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 9, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 12, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 13, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'European Quality and Safety Control (EQSC) sh.p.k'), 'ISO/IEC 17021-1', 15, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 09 (Printing) / EA 12 (Chemicals) / EA 13 (Pharmaceuticals) / EA 15 (Non-metallic mineral products)', 'ACTIVE', NULL, '2018-12-04', '2026-12-02'),
    ((SELECT id FROM cb WHERE name = 'CERTIS sh.p.k.'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2025-02-24', '2029-02-23'),
    ((SELECT id FROM cb WHERE name = 'CERTIS sh.p.k.'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2025-02-24', '2029-02-23'),
    ((SELECT id FROM cb WHERE name = 'CERTIS sh.p.k.'), 'ISO/IEC 17021-1', 4, 'EA 01 (Agriculture) / EA 03 (Food) / EA 04 (Textiles)', 'ACTIVE', NULL, '2025-02-24', '2029-02-23'),
    ((SELECT id FROM cb WHERE name = 'UNICERT sh.p.k'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'EXPIRED', NULL, '2022-09-14', '2026-09-13'),
    ((SELECT id FROM cb WHERE name = 'UNICERT sh.p.k'), 'ISO/IEC 17021-1', 2, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'EXPIRED', NULL, '2022-09-14', '2026-09-13'),
    ((SELECT id FROM cb WHERE name = 'UNICERT sh.p.k'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'EXPIRED', NULL, '2022-09-14', '2026-09-13'),
    ((SELECT id FROM cb WHERE name = 'UNICERT sh.p.k'), 'ISO/IEC 17021-1', 4, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles)', 'EXPIRED', NULL, '2022-09-14', '2026-09-13'),
    ((SELECT id FROM cb WHERE name = 'WR ERN BERATUNG sh.p.k Cert-ERN'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 02 (Mining)', 'EXPIRED', NULL, '2022-09-15', '2026-09-14'),
    ((SELECT id FROM cb WHERE name = 'WR ERN BERATUNG sh.p.k Cert-ERN'), 'ISO/IEC 17021-1', 2, 'EA 01 (Agriculture) / EA 02 (Mining)', 'EXPIRED', NULL, '2022-09-15', '2026-09-14'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 3, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 4, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 5, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 8, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 9, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'e - Cert sh.p.k'), 'ISO/IEC 17021-1', 12, 'EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 08 (Publishing) / EA 09 (Printing) / EA 12 (Chemicals)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'Risk Control Advisory – R.C.A shpk'), 'ISO/IEC 17021-1', NULL, 'A (Industry & distribution) / D (Public administration) / E (Health) / F (Services) / G (Financial, postal, telecom, transport)', 'ACTIVE', NULL, '2024-09-30', '2028-09-29'),
    ((SELECT id FROM cb WHERE name = '“M.G BUGATTI CERTIFICATION” sh.p.k'), 'ISO/IEC 17021-1', 7, 'EA 07 (Pulp, paper and paper products)', 'ACTIVE', NULL, '2024-11-15', '2028-11-14'),
    ((SELECT id FROM cb WHERE name = 'MSC certification shpk'), 'ISO/IEC 17021-1', NULL, 'Management Systems Certification', 'ACTIVE', NULL, '2024-11-18', '2028-11-17'),
    ((SELECT id FROM cb WHERE name = 'AUTENTICERT Albania sh.p.k'), 'ISO/IEC 17021-1', NULL, 'EA 33 (Information technology) / EA 35 (Other services)', 'ACTIVE', NULL, '2026-01-20', '2030-01-19'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 1, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 2, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 3, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 4, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 5, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 6, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = 'CERTI AL shpk'), 'ISO/IEC 17021-1', 7, 'EA 01 (Agriculture) / EA 02 (Mining) / EA 03 (Food) / EA 04 (Textiles) / EA 05 (Leather) / EA 06 (Wood) / EA 07 (Paper)', 'ACTIVE', NULL, '2026-08-17', '2030-08-16'),
    ((SELECT id FROM cb WHERE name = '“Genius Lab” sh.p.k'), 'ISO 15189', 38, 'EA 38 (Health and social work - Medical diagnostic testing)', 'ACTIVE', NULL, '2024-07-12', '2028-07-11'),
    ((SELECT id FROM cb WHERE name = 'Pegasus Lab sh.p.k (PEGASUS MED)'), 'ISO 15189', 38, 'EA 38 (Health and social work - Medical diagnostic assays)', 'ACTIVE', NULL, '2025-05-03', '2029-05-02'),
    ((SELECT id FROM cb WHERE name = '“3P LIFE LOGISTIC” sh.p.k'), 'ISO 15189', 38, 'EA 38 (Health and social work - Medical diagnostic laboratory testing)', 'EXPIRED', NULL, '2022-09-06', '2026-06-02'),
    ((SELECT id FROM cb WHERE name = '“SPITALI SALUS” Sh.A'), 'ISO 15189', 38, 'EA 38 (Health and social work - Hospital clinical diagnostic testing)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'ECCAT sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2024-03-11', '2028-03-10'),
    ((SELECT id FROM cb WHERE name = 'ECCAT sh.p.k'), 'ISO/IEC 17025', 3, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2024-03-11', '2028-03-10'),
    ((SELECT id FROM cb WHERE name = 'ISHTI shpk'), 'ISO/IEC 17025', 10, 'EA 10 (Refined petroleum products & fuels)', 'ACTIVE', NULL, '2025-07-26', '2029-07-25'),
    ((SELECT id FROM cb WHERE name = 'NORD – COMAT sh.p.k'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-02-08', '2029-02-09'),
    ((SELECT id FROM cb WHERE name = 'NORD – COMAT sh.p.k'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-02-08', '2029-02-09'),
    ((SELECT id FROM cb WHERE name = 'Noa Control sh.p.k'), 'ISO/IEC 17025', 25, 'EA 25 (Electricity supply & electrical metering)', 'ACTIVE', NULL, '2024-12-22', '2028-12-21'),
    ((SELECT id FROM cb WHERE name = 'A.L.T.E.A & GEOSTUDIO 2000 shpk'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-03-10', '2029-03-09'),
    ((SELECT id FROM cb WHERE name = 'A.L.T.E.A & GEOSTUDIO 2000 shpk'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-03-10', '2029-03-09'),
    ((SELECT id FROM cb WHERE name = 'HTT-High Tech Test SHPK'), 'ISO/IEC 17025', 25, 'EA 25 (Electricity supply & electrical metering)', 'ACTIVE', NULL, '2025-03-19', '2029-03-18'),
    ((SELECT id FROM cb WHERE name = 'SARP & LAB sh.p.k'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'EXPIRED', NULL, '2021-06-09', '2025-06-08'),
    ((SELECT id FROM cb WHERE name = 'SARP & LAB sh.p.k'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'EXPIRED', NULL, '2021-06-09', '2025-06-08'),
    ((SELECT id FROM cb WHERE name = 'Eko-Studio-Projekt sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2026-02-10', '2030-02-09'),
    ((SELECT id FROM cb WHERE name = 'VME Verifikim i Matesave Elektrik sh.p.k'), 'ISO/IEC 17025', 25, 'EA 25 (Electricity supply & electrical metering)', 'ACTIVE', NULL, '2025-09-15', '2029-09-14'),
    ((SELECT id FROM cb WHERE name = 'UNIVERSITETI ALEKSANDER XHUVANI'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 10 (Refined petroleum products & fuels) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-02-06', '2030-02-05'),
    ((SELECT id FROM cb WHERE name = 'UNIVERSITETI ALEKSANDER XHUVANI'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 10 (Refined petroleum products & fuels) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-02-06', '2030-02-05'),
    ((SELECT id FROM cb WHERE name = 'UNIVERSITETI ALEKSANDER XHUVANI'), 'ISO/IEC 17025', 10, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 10 (Refined petroleum products & fuels) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-02-06', '2030-02-05'),
    ((SELECT id FROM cb WHERE name = 'UNIVERSITETI ALEKSANDER XHUVANI'), 'ISO/IEC 17025', 2, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 10 (Refined petroleum products & fuels) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-02-06', '2030-02-05'),
    ((SELECT id FROM cb WHERE name = 'UNIVERSITETI ALEKSANDER XHUVANI'), 'ISO/IEC 17025', 17, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 10 (Refined petroleum products & fuels) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-02-06', '2030-02-05'),
    ((SELECT id FROM cb WHERE name = 'Sherbimi Gjeologjik Shqiptar'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-09-11', '2030-09-10'),
    ((SELECT id FROM cb WHERE name = 'Sherbimi Gjeologjik Shqiptar'), 'ISO/IEC 17025', 2, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-09-11', '2030-09-10'),
    ((SELECT id FROM cb WHERE name = 'Sherbimi Gjeologjik Shqiptar'), 'ISO/IEC 17025', 17, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2026-09-11', '2030-09-10'),
    ((SELECT id FROM cb WHERE name = 'GR ALBANIA sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2022-11-08', '2026-11-07'),
    ((SELECT id FROM cb WHERE name = 'Tenuis LABORATORIES'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2023-05-12', '2027-05-11'),
    ((SELECT id FROM cb WHERE name = 'Tenuis LABORATORIES'), 'ISO/IEC 17025', 3, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2023-05-12', '2027-05-11'),
    ((SELECT id FROM cb WHERE name = 'Go Green'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'ELBA'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'ELBA'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'ALB CONSULT 2'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'ALB CONSULT 2'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'INSTITUTI STUDIMEVE AMBJENTALE'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'ALBA BETON'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-03-06', '2027-03-05'),
    ((SELECT id FROM cb WHERE name = 'ALBA BETON'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-03-06', '2027-03-05'),
    ((SELECT id FROM cb WHERE name = 'GEOTEST'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-03-06', '2027-03-05'),
    ((SELECT id FROM cb WHERE name = 'GEOTEST'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-03-06', '2027-03-05'),
    ((SELECT id FROM cb WHERE name = 'ECM STUDIO sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'Qendra e Monitorimit te Mjedisit (QMM)'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-07-26', '2027-07-25'),
    ((SELECT id FROM cb WHERE name = 'Alpha Studio sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-11-22', '2027-11-21'),
    ((SELECT id FROM cb WHERE name = 'S.W.O.T sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2024-04-30', '2028-04-29'),
    ((SELECT id FROM cb WHERE name = '3G sh.p.k'), 'ISO/IEC 17025', 25, 'EA 25 (Electricity supply & electrical metering)', 'ACTIVE', NULL, '2024-12-11', '2028-12-10'),
    ((SELECT id FROM cb WHERE name = 'BIO-V sh.p.k'), 'ISO/IEC 17025', 3, 'EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2025-02-24', '2029-02-23'),
    ((SELECT id FROM cb WHERE name = 'Eko Geolab & Chimica sh.p.k'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-04-06', '2029-04-05'),
    ((SELECT id FROM cb WHERE name = 'Eko Geolab & Chimica sh.p.k'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-04-06', '2029-04-05'),
    ((SELECT id FROM cb WHERE name = 'Alb Lab shpk'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-04-18', '2029-04-17'),
    ((SELECT id FROM cb WHERE name = 'Alb Lab shpk'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2025-04-18', '2029-04-17'),
    ((SELECT id FROM cb WHERE name = 'Enologic Group Shpk'), 'ISO/IEC 17025', 3, 'EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2025-05-20', '2029-05-19'),
    ((SELECT id FROM cb WHERE name = 'Laboratori i Agjencisë Kombëtare të Mjedisit'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2025-07-25', '2029-07-24'),
    ((SELECT id FROM cb WHERE name = 'Laborator ISUV'), 'ISO/IEC 17025', 3, 'EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2025-09-18', '2029-09-17'),
    ((SELECT id FROM cb WHERE name = 'Laboratori Fizikokimik i Mineraleve-Agjencia Kombëtare e Burimeve Natyrore (AKBN)'), 'ISO/IEC 17025', 2, 'EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2022-09-15', '2030-09-13'),
    ((SELECT id FROM cb WHERE name = 'Laboratori Fizikokimik i Mineraleve-Agjencia Kombëtare e Burimeve Natyrore (AKBN)'), 'ISO/IEC 17025', 17, 'EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2022-09-15', '2030-09-13'),
    ((SELECT id FROM cb WHERE name = 'VITROS LAB shpk'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2022-12-07', '2026-12-06'),
    ((SELECT id FROM cb WHERE name = 'VITROS LAB shpk'), 'ISO/IEC 17025', 3, 'EA 39 (Environmental testing - water, air, noise & soil) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2022-12-07', '2026-12-06'),
    ((SELECT id FROM cb WHERE name = 'Laboratori i UKT Ujësjellës Kanalizime ” sh.a'), 'ISO/IEC 17025', 35, 'EA 35 (Other technical testing services)', 'ACTIVE', NULL, '2022-12-29', '2026-12-28'),
    ((SELECT id FROM cb WHERE name = 'I.T.M shpk'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'I.T.M shpk'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2023-01-24', '2027-01-23'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT shpk'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2023-02-21', '2027-02-20'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT shpk'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2023-02-21', '2027-02-20'),
    ((SELECT id FROM cb WHERE name = 'AQSCERT shpk'), 'ISO/IEC 17025', 3, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction) / EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2023-02-21', '2027-02-20'),
    ((SELECT id FROM cb WHERE name = 'Laboratori A - Consultant'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-05-31', '2027-05-30'),
    ((SELECT id FROM cb WHERE name = 'Studio Eko-Keshillim sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-10-06', '2027-10-05'),
    ((SELECT id FROM cb WHERE name = 'GTS-Gazra Teknike Shqiptare shpk'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2023-11-13', '2027-11-12'),
    ((SELECT id FROM cb WHERE name = 'S G S ALBANIA sh.p.k'), 'ISO/IEC 17025', 10, 'EA 10 (Refined petroleum products & fuels)', 'ACTIVE', NULL, '2023-11-09', '2027-11-08'),
    ((SELECT id FROM cb WHERE name = 'Laboratori Qendror i Restaurimit Drejtoria e Përgjithshme e Arkivave'), 'ISO/IEC 17025', 7, 'EA 07 (Pulp, paper & consumer product testing)', 'ACTIVE', NULL, '2024-04-09', '2028-04-08'),
    ((SELECT id FROM cb WHERE name = 'Drejtoria e Laboratorit Doganor'), 'ISO/IEC 17025', 3, 'EA 03 (Food products, beverages & agriculture) / EA 10 (Refined petroleum products & fuels)', 'ACTIVE', NULL, '2024-04-30', '2028-04-29'),
    ((SELECT id FROM cb WHERE name = 'Drejtoria e Laboratorit Doganor'), 'ISO/IEC 17025', 10, 'EA 03 (Food products, beverages & agriculture) / EA 10 (Refined petroleum products & fuels)', 'ACTIVE', NULL, '2024-04-30', '2028-04-29'),
    ((SELECT id FROM cb WHERE name = 'BERDICA CEMENT'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2024-08-06', '2028-08-05'),
    ((SELECT id FROM cb WHERE name = 'BERDICA CEMENT'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2024-08-06', '2028-08-05'),
    ((SELECT id FROM cb WHERE name = 'Instituti i Ndërtimit, Drejtoria e Laboratorëve'), 'ISO/IEC 17025', 16, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2024-09-10', '2028-09-09'),
    ((SELECT id FROM cb WHERE name = 'Instituti i Ndërtimit, Drejtoria e Laboratorëve'), 'ISO/IEC 17025', 28, 'EA 16 (Concrete, cement, lime) / EA 28 (Construction)', 'ACTIVE', NULL, '2024-09-10', '2028-09-09'),
    ((SELECT id FROM cb WHERE name = 'EHW shpk'), 'ISO/IEC 17025', 3, 'EA 03 (Food products, beverages & agriculture)', 'ACTIVE', NULL, '2024-12-11', '2028-12-10'),
    ((SELECT id FROM cb WHERE name = 'Agjencia Kombëtare e Barnave dhe Pajisjeve Mjekësore Laboratori i Kontrollit'), 'ISO/IEC 17025', 13, 'EA 13 (Pharmaceuticals & medical products)', 'ACTIVE', NULL, '2025-01-31', '2029-01-30'),
    ((SELECT id FROM cb WHERE name = 'ALBCHROME SHPK'), 'ISO/IEC 17025', 2, 'EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2025-05-19', NULL),
    ((SELECT id FROM cb WHERE name = 'ALBCHROME SHPK'), 'ISO/IEC 17025', 17, 'EA 02 (Mining & quarrying) / EA 17 (Basic metals)', 'ACTIVE', NULL, '2025-05-19', NULL),
    ((SELECT id FROM cb WHERE name = 'LENI-ING sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2025-05-19', '2029-05-18'),
    ((SELECT id FROM cb WHERE name = 'WATER BOUTIQUE sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2025-06-16', '2029-06-15'),
    ((SELECT id FROM cb WHERE name = 'Rozafa shpk'), 'ISO/IEC 17025', 35, 'EA 35 (Other technical testing services)', 'ACTIVE', NULL, '2025-08-25', '2029-08-24'),
    ((SELECT id FROM cb WHERE name = 'Loerma shpk'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2025-09-18', '2029-09-17'),
    ((SELECT id FROM cb WHERE name = 'IBRA Labs shpk'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'ACTIVE', NULL, '2025-10-03', '2029-10-02'),
    ((SELECT id FROM cb WHERE name = 'INSPEKTORIATI SHTETEROR TEKNIK DHE INDUSTRIAL'), 'ISO/IEC 17025', 7, 'EA 07 (Pulp, paper & consumer product testing)', 'ACTIVE', NULL, '2025-12-15', '2029-12-14'),
    ((SELECT id FROM cb WHERE name = 'ENTI SHTETËROR I FARËRAVE DHE FIDANËVE LABORATORI QËNDROR I TESTIMIT TË FARËRAVE (LQTF)'), 'ISO/IEC 17025', 35, 'EA 35 (Other technical testing services)', 'ACTIVE', NULL, '2026-02-09', '2030-02-08'),
    ((SELECT id FROM cb WHERE name = 'Profarma sh.a'), 'ISO/IEC 17025', 13, 'EA 13 (Pharmaceuticals & medical products)', 'EXPIRED', NULL, '2026-07-02', '2026-07-02'),
    ((SELECT id FROM cb WHERE name = 'Laboratori i mjedisit universitetit Polis'), 'ISO/IEC 17025', 35, 'EA 35 (Other technical testing services)', 'WITHDRAWN', NULL, '2022-03-01', '2024-01-22'),
    ((SELECT id FROM cb WHERE name = 'VIELF STUDIO sh.p.k'), 'ISO/IEC 17025', 39, 'EA 39 (Environmental testing - water, air, noise & soil)', 'SUSPENDED', NULL, '2024-02-05', '2026-04-01')
ON CONFLICT (certification_body_id, iso_standard, ea_code) DO UPDATE SET
    scope_section = EXCLUDED.scope_section, status = EXCLUDED.status,
    accreditation_date = EXCLUDED.accreditation_date, expiration_date = EXCLUDED.expiration_date,
    proof_url = EXCLUDED.proof_url;


COMMIT;

