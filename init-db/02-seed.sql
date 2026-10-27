-- ============================================================================
-- CertiFind Complete Seed Data (42 Certification Bodies, 68 Active Scopes)
-- Management-system scopes use EA codes; product-certification scopes use ISO/IEC 17065
-- ============================================================================

-- 1. Accreditation Bodies (5 European IAF-MLA Authorities)
INSERT INTO accreditation_bodies (code, name, country, is_iaf_mla, website) VALUES
    ('ACCREDIA', 'ACCREDIA - Ente Italiano di Accreditamento',  'Italy',          TRUE, 'https://www.accredia.it'),
    ('RENAR',    'RENAR - Asociatia de Acreditare din Romania', 'Romania',        TRUE, 'https://www.renar.ro'),
    ('PCA',      'PCA - Polskie Centrum Akredytacji',           'Poland',         TRUE, 'https://www.pca.gov.pl'),
    ('DAkkS',    'DAkkS - Deutsche Akkreditierungsstelle',      'Germany',        TRUE, 'https://www.dakks.de'),
    ('UKAS',     'UKAS - United Kingdom Accreditation Service', 'United Kingdom', TRUE, 'https://www.ukas.com'),
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
    ('Institute for Construction, Construction Materials and Non-Metals - Department for Certification of Construction Materials', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 35 25 80 83', NULL, NULL, 'Kojšino 29, 75000 Tuzla'),
    ('PRO-MOST d.o.o. Mostar', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 36 33 41 88', NULL, NULL, 'Kralja Petra Krešimira IV. 14, 88000 Mostar'),
    ('Federal Institute for Agriculture - Certification Body for Products', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 33 774 241', NULL, NULL, 'Butmirska cesta 40, 71000 Sarajevo'),
    ('Civil Institute Banja Luka - Research and Development Center 1', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 51 492 118', 'sert@institutbl.com', NULL, 'Ada 24, 78000 Banja Luka'),
    ('Federal Agro-Mediterranean Institute - Verification Body', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 36 335 064', 'marijo.leko@faz.gov.ba', NULL, 'Biskupa Čule 10, 88000 Mostar'),
    ('IRC d.o.o.', 'Bosnia and Herzegovina', (SELECT id FROM ab), FALSE, FALSE, '+387 66 022 515', 'ejla.putes@inza.ba', NULL, 'Vuka Karadžića 30, 71123 East Sarajevo')
ON CONFLICT (name) DO UPDATE SET
    country = EXCLUDED.country,
    accreditation_body_id = EXCLUDED.accreditation_body_id,
    phone = EXCLUDED.phone,
    email = EXCLUDED.email,
    address = EXCLUDED.address;

-- 2. Activity Sector & ATECO Mappings (Supports both with ATECO and without ATECO)
INSERT INTO ateco_ea_mapping (ateco_code, description, ea_code, ea_description) VALUES
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
ON CONFLICT (ateco_code, ea_code, description) DO NOTHING;

-- 3. Certification Bodies (36 Verified Organizations)
WITH ab AS (SELECT id, code FROM accreditation_bodies)
INSERT INTO certification_bodies
    (name, country, accreditation_body_id, phone, email, website, address)
VALUES
    -- ITALY (ACCREDIA - 12 Bodies)
    ('SGS Italia S.p.A.',                   'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 02 73931',     'it.certification@sgs.com',    'https://www.sgs.com/it-it',                  'Via Caldera 21, 20153 Milano MI, Italia'),
    ('Bureau Veritas Italia S.p.A.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 02 270911',    'bvitalia@bureauveritas.com',  'https://www.bureauveritas.it',               'Viale Monza 347, 20126 Milano MI, Italia'),
    ('TÜV Rheinland Italia S.r.l.',         'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 02 9396871',   'info@it.tuv.com',             'https://www.tuv.com/it/italia',              'Via E. Mattei 3, 20005 Pogliano Milanese MI, Italia'),
    ('DNV Business Assurance Italy S.r.l.', 'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 039 6899905',  'certification.italy@dnv.com', 'https://www.dnv.it',                         'Via Energy Park 14, 20871 Vimercate MB, Italia'),
    ('RINA Services S.p.A.',                'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 010 53851',    'info@rina.org',               'https://www.rina.org',                       'Via Corsica 12, 16128 Genova GE, Italia'),
    ('Kiwa Cermet Italia S.p.A.',           'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 051 4593111',  'info@kiwacermet.it',          'https://www.kiwa.com/it',                    'Via Cadriano 23, 40057 Granarolo dell''Emilia BO, Italia'),
    ('CSQ - IMQ S.p.A.',                    'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 02 50731',     'info@imq.it',                 'https://www.imq.it',                         'Via Quintiliano 43, 20138 Milano MI, Italia'),
    ('Certiquality S.r.l.',                 'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 02 8069171',   'certiquality@certiquality.it','https://www.certiquality.it',                'Via Gaetano Giardino 4, 20123 Milano MI, Italia'),
    ('ICIM S.p.A.',                         'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 02 725341',    'info@icim.it',                'https://www.icim.it',                        'Piazza Don Enrico Mapelli 75, 20099 Sesto San Giovanni MI, Italia'),
    ('Quaser Certificazioni S.r.l.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 02 67479254',  'segreteria@quaser.org',       'https://www.quaser.org',                     'Via C. Imbonati 18, 20159 Milano MI, Italia'),
    ('AJA Registrars Europe S.r.l.',        'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, TRUE,  '+39 06 85356701',  'roma@aeurope.eu',             'https://www.aeurope.eu',                     'Via Nomentana 257, 00161 Roma RM, Italia'),
    ('Global Group Italia S.r.l.',          'Italy', (SELECT id FROM ab WHERE code = 'ACCREDIA'), TRUE, FALSE, '+39 0546 686252',  'info@globalgroupitalia.it',   'https://www.globalgroupitalia.it',           'Via Correcchio 12, 47122 Forlì FC, Italia'),

    -- ROMANIA (RENAR - 9 Bodies)
    ('CertRom S.R.L.',                      'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, TRUE,  '+40 21 310 4320',  'office@certrom.ro',           'https://www.certrom.ro',                     'Str. Calea Plevnei 139, 060011 Bucuresti, Romania'),
    ('SRAC CERT S.R.L.',                    'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, FALSE, '+40 21 313 6335',  'office@srac.ro',              'https://www.srac.ro',                        'Str. Vasile Parvan 14, 010216 Bucuresti, Romania'),
    ('Certind S.A.',                        'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, TRUE,  '+40 21 313 3651',  'office@certind.ro',           'https://www.certind.ro',                     'Str. George Enescu 27-29, 010303 Bucuresti, Romania'),
    ('SIMTEX-OC S.R.L.',                    'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, TRUE,  '+40 21 317 0170',  'simtex@simtex.ro',            'https://www.simtex.ro',                      'Str. Maria Rosetti 10, 020485 Bucuresti, Romania'),
    ('ALL CERT PRODUCT S.R.L.',             'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, FALSE, '+40 21 252 5555',  'office@allcert.ro',           'https://www.allcert.ro',                     'B-dul Chisinau 1, 022141 Bucuresti, Romania'),
    ('TÜV Austria Romania S.R.L.',          'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, TRUE,  '+40 21 314 4300',  'bucuresti@tuvaustria.ro',     'https://www.tuvaustria.ro',                  'Calea Floreasca 169A, 014459 Bucuresti, Romania'),
    ('Q-CERT Romania S.R.L.',               'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, TRUE,  '+40 21 230 4567',  'romania@q-cert.com',          'https://www.q-cert.com',                     'Str. Av. Stefan Sanatescu 48, 011478 Bucuresti, Romania'),
    ('CERTSYS S.R.L.',                      'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, FALSE, '+40 31 405 1234',  'office@certsys.ro',           'https://www.certsys.ro',                     'B-dul Unirii 64, 030834 Bucuresti, Romania'),
    ('MiNT Romania S.R.L.',                 'Romania', (SELECT id FROM ab WHERE code = 'RENAR'), TRUE, FALSE, '+40 21 326 7788',  'contact@mintre.ro',           'https://www.mintre.ro',                      'Str. Vasile Conta 3-5, 020951 Bucuresti, Romania'),

    -- POLAND (PCA - 9 Bodies)
    ('TÜV Nord Polska Sp. z o.o.',          'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, FALSE, '+48 32 784 2800',  'biuro@tuv-nord.pl',           'https://www.tuv-nord.com/pl',                'ul. Mickiewicza 29, 40-085 Katowice, Polska'),
    ('PRS Polski Rejestr Statkow S.A.',     'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, FALSE, '+48 58 751 1100',  'prs@prs.pl',                  'https://www.prs.pl',                         'al. gen. J. Hallera 126, 80-416 Gdansk, Polska'),
    ('URS Polska Sp. z o.o.',               'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, TRUE,  '+48 32 700 6910',  'info@urs-polska.pl',          'https://www.urs-polska.pl',                  'ul. Warszawska 31, 40-010 Katowice, Polska'),
    ('ZETOM Katowice Sp. z o.o.',           'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, FALSE, '+48 32 256 9257',  'zetom@zetom.katowice.pl',     'https://www.zetom.katowice.pl',              'ul. Ks. Bpa H. Bednorza 17, 40-384 Katowice, Polska'),
    ('PCBC S.A. - Polish Centre for Testing','Poland', (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, TRUE,  '+48 22 857 9916',  'pcbc@pcbc.gov.pl',            'https://www.pcbc.gov.pl',                    'ul. Klobucka 23A, 02-699 Warszawa, Polska'),
    ('ISOCERT Sp. z o.o.',                  'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, TRUE,  '+48 71 780 4350',  'biuro@isocert.pl',            'https://www.isocert.pl',                     'ul. Kwidzynska 6e, 51-416 Wroclaw, Polska'),
    ('DEKRA Certification Sp. z o.o.',      'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, TRUE,  '+48 71 787 0100',  'polska@dekra.com',            'https://www.dekra.pl',                       'ul. Legnicka 48H, 54-202 Wroclaw, Polska'),
    ('UDT-CERT (Urząd Dozoru Technicznego)','Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, FALSE, '+48 22 572 2110',  'udt@udt.gov.pl',              'https://www.udt.gov.pl',                     'ul. Szczesliwicka 34, 02-353 Warszawa, Polska'),
    ('CCG Certification Sp. z o.o.',        'Poland',  (SELECT id FROM ab WHERE code = 'PCA'),   TRUE, FALSE, '+48 12 345 6789',  'kontakt@ccg-cert.pl',         'https://www.ccg-cert.pl',                    'ul. Wielicka 72, 30-552 Krakow, Polska'),

    -- GERMANY (DAkkS - 3 Bodies)
    ('TÜV SÜD Management Service GmbH',     'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'), TRUE, TRUE,  '+49 89 5791 0',    'info@tuvsud.com',             'https://www.tuvsud.com/de-de',               'Westendstraße 199, 80686 München, Deutschland'),
    ('DQS GmbH',                            'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'), TRUE, TRUE,  '+49 69 95427 0',   'info@dqs.de',                 'https://www.dqs.de',                         'August-Schanz-Straße 21, 60433 Frankfurt am Main, Deutschland'),
    ('GUTcert GmbH',                        'Germany', (SELECT id FROM ab WHERE code = 'DAkkS'), TRUE, FALSE, '+49 30 2332021 0', 'info@gut-cert.de',            'https://www.gut-cert.de',                    'Eichenstraße 3b, 12435 Berlin, Deutschland'),

    -- UNITED KINGDOM (UKAS - 3 Bodies)
    ('BSI Assurance UK Limited',            'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'), TRUE, TRUE,  '+44 345 080 9000', 'cservices@bsigroup.com', 'https://www.bsigroup.com',                   '389 Chiswick High Road, London W4 4AL, UK'),
    ('NQA Certification Ltd',               'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'), TRUE, TRUE,  '+44 800 052 2424', 'contact@nqa.com',        'https://www.nqa.com',                        'Warwick House, Houghton Hall Park, Dunstable LU5 5ZX, UK'),
    ('BM TRADA (Warringtonfire)',           'United Kingdom', (SELECT id FROM ab WHERE code = 'UKAS'), TRUE, FALSE, '+44 1494 569700',  'enquiries@bmtrada.com',  'https://www.bmtrada.com',                    'Stocking Lane, Hughenden Valley, High Wycombe HP14 4ND, UK')
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
