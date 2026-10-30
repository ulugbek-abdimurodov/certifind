-- CertiFind sample data. Certification bodies, certificates, contacts and
-- URLs are fictional; accreditation bodies and EA sectors are real reference data.
--
-- Scenarios covered (search "ISO 9001" + "metallo" = EA 17 to see most of them):
--   * 17021-1 for ISO 9001 in EA 01,02,05,23,25,26 + 27006 for 27001 in all EA (Qualitas)
--   * several bodies accredited for ISO 9001 in EA 17 (metal), across countries
--   * 45001/14001 for EA 17 but not 9001 (Lombardia Safety Cert)
--   * 27006-only body: never returned for ISO 9001 (InfoSec Assurance)
--   * excluded rights: suspended accreditation (CertRom), expired accreditation
--     (Polcert 50003), withdrawn single EA scope (Energia Certa 9001 EA 17),
--     suspended single EA scope (Tecno Audit 9001 EA 38)
--   * accreditation from a non-IAF-MLA body (Adriatik Cert / DPA)

BEGIN;

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('ACCREDIA', 'ACCREDIA - Ente Italiano di Accreditamento',          'Italy',          'https://www.accredia.it'),
('UKAS',     'United Kingdom Accreditation Service',                'United Kingdom', 'https://www.ukas.com'),
('DAkkS',    'Deutsche Akkreditierungsstelle',                      'Germany',        'https://www.dakks.de'),
('RENAR',    'Asociatia de Acreditare din Romania',                 'Romania',        'https://www.renar.ro'),
('PCA',      'Polskie Centrum Akredytacji',                         'Poland',         'https://www.pca.gov.pl'),
('DPA',      'Drejtoria e Pergjithshme e Akreditimit',              'Albania',        'https://www.dpa.gov.al');

INSERT INTO ea_sectors (code, name_en, name_it) VALUES
( 1, 'Agriculture, forestry and fishing',                        'Agricoltura, silvicoltura e pesca'),
( 2, 'Mining and quarrying',                                     'Estrazione di minerali da cave e miniere'),
( 3, 'Food products, beverages and tobacco',                     'Industrie alimentari, delle bevande e del tabacco'),
( 4, 'Textiles and textile products',                            'Prodotti tessili'),
( 5, 'Leather and leather products',                             'Cuoio e prodotti in cuoio'),
( 6, 'Wood and wood products',                                   'Legno e prodotti in legno'),
( 7, 'Pulp, paper and paper products',                           'Pasta di carta, carta e prodotti di carta'),
( 8, 'Publishing companies',                                     'Case editrici'),
( 9, 'Printing companies',                                       'Tipografie'),
(10, 'Manufacture of coke and refined petroleum products',       'Fabbricazione di coke e prodotti petroliferi raffinati'),
(11, 'Nuclear fuel',                                             'Combustibili nucleari'),
(12, 'Chemicals, chemical products and fibres',                  'Prodotti chimici e fibre'),
(13, 'Pharmaceuticals',                                          'Prodotti farmaceutici'),
(14, 'Rubber and plastic products',                              'Articoli in gomma e materie plastiche'),
(15, 'Non-metallic mineral products',                            'Prodotti della lavorazione di minerali non metalliferi'),
(16, 'Concrete, cement, lime, plaster etc.',                     'Calcestruzzo, cemento, calce, gesso'),
(17, 'Basic metals and fabricated metal products',               'Metalli di base e prodotti in metallo'),
(18, 'Machinery and equipment',                                  'Macchine ed apparecchiature'),
(19, 'Electrical and optical equipment',                         'Apparecchiature elettriche e ottiche'),
(20, 'Shipbuilding',                                             'Costruzioni navali'),
(21, 'Aerospace',                                                'Aerospaziale'),
(22, 'Other transport equipment',                                'Altri mezzi di trasporto'),
(23, 'Manufacturing not elsewhere classified',                   'Altre industrie manifatturiere'),
(24, 'Recycling',                                                'Recupero e riciclaggio'),
(25, 'Electricity supply',                                       'Produzione e distribuzione di energia elettrica'),
(26, 'Gas supply',                                               'Produzione e distribuzione di gas'),
(27, 'Water supply',                                             'Produzione e distribuzione di acqua'),
(28, 'Construction',                                             'Costruzioni'),
(29, 'Wholesale and retail trade; repair of motor vehicles',     'Commercio all''ingrosso e al dettaglio; riparazione di autoveicoli'),
(30, 'Hotels and restaurants',                                   'Alberghi e ristoranti'),
(31, 'Transport, storage and communication',                     'Trasporti, logistica e comunicazioni'),
(32, 'Financial intermediation; real estate; renting',           'Intermediazione finanziaria, attività immobiliari, noleggio'),
(33, 'Information technology',                                   'Tecnologia dell''informazione'),
(34, 'Engineering services',                                     'Servizi di ingegneria'),
(35, 'Other services',                                           'Altri servizi'),
(36, 'Public administration',                                    'Pubblica amministrazione'),
(37, 'Education',                                                'Istruzione'),
(38, 'Health and social work',                                   'Sanità e servizi sociali'),
(39, 'Other social services',                                    'Altri servizi sociali');

INSERT INTO standards (code, title, kind) VALUES
('ISO/IEC 17021-1', 'Requirements for bodies providing audit and certification of management systems', 'ACCREDITATION'),
('ISO/IEC 27006',   'Requirements for bodies providing audit and certification of information security management systems', 'ACCREDITATION'),
('ISO 50003',       'Requirements for bodies providing audit and certification of energy management systems', 'ACCREDITATION'),
('ISO 9001',        'Quality management systems',                         'CERTIFICATION'),
('ISO 14001',       'Environmental management systems',                  'CERTIFICATION'),
('ISO 45001',       'Occupational health and safety management systems',  'CERTIFICATION'),
('ISO/IEC 27001',   'Information security management systems',           'CERTIFICATION'),
('ISO 50001',       'Energy management systems',                          'CERTIFICATION'),
('ISO/IEC 17021-4', 'Requirements for bodies providing audit and certification of sustainable event management systems', 'ACCREDITATION'),
('ISO/IEC 17021-6', 'Requirements for bodies providing audit and certification of business continuity management systems', 'ACCREDITATION'),
('ISO/IEC 17021-7', 'Requirements for bodies providing audit and certification of road traffic safety management systems', 'ACCREDITATION'),
('ISO/IEC 17021-9', 'Requirements for bodies providing audit and certification of anti-bribery management systems', 'ACCREDITATION'),
('ISO 22003-1',    'Requirements for bodies providing audit and certification of food safety management systems', 'ACCREDITATION'),
('ISO/IEC 20000-6', 'Requirements for bodies providing audit and certification of service management systems', 'ACCREDITATION'),
('ISO 22301',      'Business continuity management systems', 'CERTIFICATION'),
('ISO 22000',      'Food safety management systems', 'CERTIFICATION'),
('ISO/IEC 20000-1','Information technology service management systems', 'CERTIFICATION'),
('ISO 13485',      'Quality management systems for medical devices', 'CERTIFICATION'),
('ISO 39001',      'Road traffic safety management systems', 'CERTIFICATION'),
('ISO 20121',      'Sustainable event management systems', 'CERTIFICATION'),
('ISO 37001',      'Anti-bribery management systems', 'CERTIFICATION'),
('ISO/IEC 27701',  'Privacy information management systems', 'CERTIFICATION'),
('ISO/IEC 27017',  'Information security controls for cloud services', 'CERTIFICATION'),
('ISO/IEC 27018',  'Protection of personally identifiable information in public clouds', 'CERTIFICATION');

INSERT INTO accreditation_scheme_rules (accreditation_standard, certification_standard) VALUES
('ISO/IEC 17021-1', 'ISO 9001'),
('ISO/IEC 17021-1', 'ISO 14001'),
('ISO/IEC 17021-1', 'ISO 45001'),
('ISO/IEC 27006',   'ISO/IEC 27001'),
('ISO 50003',       'ISO 50001'),
('ISO/IEC 17021-1', 'ISO 13485'),
('ISO/IEC 17021-4', 'ISO 20121'),
('ISO/IEC 17021-6', 'ISO 22301'),
('ISO/IEC 17021-7', 'ISO 39001'),
('ISO/IEC 17021-9', 'ISO 37001'),
('ISO 22003-1',     'ISO 22000'),
('ISO/IEC 20000-6', 'ISO/IEC 20000-1'),
('ISO/IEC 27006',   'ISO/IEC 27701'),
('ISO/IEC 27006',   'ISO/IEC 27017'),
('ISO/IEC 27006',   'ISO/IEC 27018');

-- Every EA sector name is a keyword in both languages ...
INSERT INTO sector_keywords (keyword, language, ea_code)
SELECT name_it, 'it', code FROM ea_sectors
UNION ALL
SELECT name_en, 'en', code FROM ea_sectors;

-- ... plus the words people actually type.
INSERT INTO sector_keywords (keyword, language, ea_code) VALUES
('agricoltura', 'it', 1), ('azienda agricola', 'it', 1), ('farming', 'en', 1),
('cava', 'it', 2), ('miniera', 'it', 2), ('mining', 'en', 2),
('alimentare', 'it', 3), ('caseificio', 'it', 3), ('food', 'en', 3),
('tessile', 'it', 4), ('textile', 'en', 4),
('pelletteria', 'it', 5), ('leather', 'en', 5),
('falegnameria', 'it', 6), ('wood', 'en', 6),
('cartiera', 'it', 7),
('editoria', 'it', 8),
('stampa', 'it', 9), ('printing', 'en', 9),
('raffineria', 'it', 10),
('chimica', 'it', 12), ('chemical', 'en', 12),
('farmaceutica', 'it', 13), ('pharma', 'en', 13),
('plastica', 'it', 14), ('gomma', 'it', 14), ('plastic', 'en', 14),
('vetro', 'it', 15), ('ceramica', 'it', 15), ('glass', 'en', 15),
('cemento', 'it', 16), ('calcestruzzo', 'it', 16), ('concrete', 'en', 16),
('metallo', 'it', 17), ('metalli', 'it', 17), ('metallurgia', 'it', 17),
('carpenteria metallica', 'it', 17), ('acciaio', 'it', 17), ('fonderia', 'it', 17),
('lavorazioni meccaniche', 'it', 17), ('metal', 'en', 17), ('steel', 'en', 17),
('metalworking', 'en', 17), ('foundry', 'en', 17),
('macchinari', 'it', 18), ('machinery', 'en', 18),
('elettronica', 'it', 19), ('impianti elettrici', 'it', 19), ('electronics', 'en', 19),
('cantiere navale', 'it', 20),
('aeronautica', 'it', 21),
('automotive', 'en', 22),
('mobili', 'it', 23), ('gioielleria', 'it', 23), ('furniture', 'en', 23),
('rifiuti', 'it', 24), ('riciclaggio', 'it', 24), ('waste', 'en', 24),
('energia elettrica', 'it', 25), ('fotovoltaico', 'it', 25), ('electricity', 'en', 25),
('distribuzione gas', 'it', 26),
('acquedotto', 'it', 27),
('costruzione di edifici', 'it', 28), ('edilizia', 'it', 28), ('impresa edile', 'it', 28),
('building', 'en', 28),
('commercio', 'it', 29), ('officina meccanica auto', 'it', 29), ('retail', 'en', 29),
('albergo', 'it', 30), ('hotel', 'en', 30), ('ristorante', 'it', 30),
('trasporto merci', 'it', 31), ('logistica', 'it', 31), ('logistics', 'en', 31),
('banca', 'it', 32), ('immobiliare', 'it', 32), ('banking', 'en', 32),
('produzione di software', 'it', 33), ('software', 'en', 33), ('informatica', 'it', 33),
('data center', 'en', 33),
('studi di ingegneria', 'it', 34), ('progettazione', 'it', 34), ('engineering', 'en', 34),
('consulenza', 'it', 35), ('pulizie', 'it', 35), ('consulting', 'en', 35),
('comune', 'it', 36), ('public administration', 'en', 36),
('asilo nido', 'it', 37), ('scuola', 'it', 37), ('formazione', 'it', 37),
('training', 'en', 37),
('ospedale', 'it', 38), ('clinica', 'it', 38), ('hospital', 'en', 38),
('assistenza sociale', 'it', 39), ('cooperativa sociale', 'it', 39);

INSERT INTO certification_bodies (name, country, phone, email, website, address) VALUES
-- sample datas
('Qualitas Certificazioni S.r.l.',     'Italy',          '+39 02 5550 1100', 'info@qualitas-cert.example',   'https://qualitas-cert.example',   'Via Torino 42, 20123 Milano MI'),
('Nord Est Certificazioni S.p.A.',     'Italy',          '+39 049 555 2200', 'info@nordestcert.example',     'https://nordestcert.example',     'Via Venezia 15, 35131 Padova PD'),
('Tecno Audit Italia S.r.l.',          'Italy',          '+39 051 555 3300', 'audit@tecnoaudit.example',     'https://tecnoaudit.example',      'Via Emilia 210, 40139 Bologna BO'),
('Metalcert Europe S.r.l.',            'Italy',          '+39 030 555 4400', 'info@metalcert.example',       'https://metalcert.example',       'Via del Ferro 8, 25125 Brescia BS'),
('Lombardia Safety Cert S.r.l.',       'Italy',          '+39 035 555 5500', 'safety@lombardiacert.example', 'https://lombardiacert.example',   'Via Bergamo 77, 24126 Bergamo BG'),
('InfoSec Assurance Italia S.r.l.',    'Italy',          '+39 06 5550 6600', 'isms@infosec-assurance.example','https://infosec-assurance.example','Via Tiburtina 500, 00159 Roma RM'),
('Energia Certa S.r.l.',               'Italy',          '+39 011 555 7700', 'energia@energiacerta.example', 'https://energiacerta.example',    'Corso Francia 120, 10143 Torino TO'),
('Sigma Quality Registrar Ltd',        'United Kingdom', '+44 161 555 0800', 'enquiries@sigmaqr.example',    'https://sigmaqr.example',         '12 Deansgate, Manchester M3 2BA'),
('Albion Certification Services Ltd',  'United Kingdom', '+44 113 555 0900', 'hello@albioncert.example',     'https://albioncert.example',      '4 Park Row, Leeds LS1 5HD'),
('Mainfranken Zertifizierung GmbH',    'Germany',        '+49 931 555 1000', 'kontakt@mainfranken-zert.example','https://mainfranken-zert.example','Juliuspromenade 30, 97070 Würzburg'),
('CertRom Audit S.R.L.',               'Romania',        '+40 21 555 1100',  'office@certrom.example',       'https://certrom.example',         'Bd. Unirii 45, 030823 Bucuresti'),
('Polcert Sp. z o.o.',                 'Poland',         '+48 12 555 1200',  'biuro@polcert.example',        'https://polcert.example',         'ul. Dluga 18, 31-146 Kraków'),
('Adriatik Cert Sh.p.k.',              'Albania',        '+355 4 555 1300',  'info@adriatikcert.example',    'https://adriatikcert.example',    'Rruga e Kavajës 60, 1001 Tiranë'),


-- real datas
('Legal Cert sh.p.k',                  'Albania',        '+355 692081842',   'info@legalcert.al',             NULL,                              'Njesia administrative nr 5, Rruga Tish Daija, kompleksi KIKA 2, Ndertesa 36, Shkalla 2(14), kati 2, Tiranë'),
('AXE Register sh.p.k',                'Albania',        '+355 696037861',   'sokol.a@axe-register.com',      NULL,                              'Sheshi "Skënderbej", Pallati i Kulturës, Nr. 34, 1001, Tiranë'),
('AQScert',                            'Albania',        '+355 682097080',   NULL,                            NULL,                              'Njësia Bashkiake nr.5, Rruga “Jusuf Vrioni”, Pallati 1, hyrja 6, TIRANË '),
('CAREER CERT INSTITUTE sh.p.k',                 'Albania',        '+355 692062961',   NULL,                            NULL,                              'Sheshi Skënderbej, Pallati i kulturës, Kati 1, Tiranë'),
('European Quality and Safety Control (EQSC) sh.p.k', 'Albania', '+355 693368439',   NULL,                            NULL,                              'Rruga Sulejman Pasha, Pallati 70/1, Kati 1, Nr.1, Tiranë'),
('CERTIS sh.p.k',                               'Albania',        '+355 672013321',   NULL,                            NULL,                              'Rruga Sulejman Pasha, Hyrja Nr.1, Ap. Nr.0, Nr. Pasurie 6/173-N7, Zona Kadastrale 8350, Tiranë'),
('e-Cert sh.p.k',                               'Albania',        '+355 699902185',   'alba@e-cert.al',                NULL,                              'Rruga “Endri Keko”, Shkalla 3/1, Ap. 6, Kati i Dytë, Kodi Postar 1005, Tiranë'),
('Risk Control Advisory – R.C.A sh.p.k',        'Albania',        '+355 699412741',   NULL,                            NULL,                              'Rruga Hysen Zaloshnja, Nd. 2, h. 4, ap. 16, Tiranë'),
('M.G BUGATTI CERTIFICATION sh.p.k',            'Albania',        '+39 3299116015',   'direzione@bugatticertification.it', NULL,                          'Rruga “Ndre Mjeda”, Hyrja 13 AP 10, Tiranë'),
('MSC CERTIFICATIONS sh.p.k',                   'Albania',        '+355 672063632',   'hajdarajeneriko@gmail.com',     NULL,                              'Rruga “Ismail Qemali”, Pallati 34/1, Apartamenti 3, Tiranë'),
('AUTENTICERT Albania sh.p.k',                  'Albania',        '+39 3801467945',   'Albania@autenticert.com',       NULL,                              'Rruga Kajo Karafili, nr. 14, Ap.6, Kodi Postar 1001, Tiranë'),
('CERTI AL sh.p.k',                             'Albania',        '+355 672020502',   NULL,                            NULL,                              'Rruga “Shyqyri Brari”, Pallati “Amfora”, Shkalla 1, Kati 3, Ap. 9, Tiranë');

-- (certification body, accreditation body, accreditation standard, certificate, status, issued, expires)
INSERT INTO accreditations
    (certification_body_id, accreditation_body_id, accreditation_standard, certificate_number,
     status, issue_date, expiry_date, proof_url)
SELECT cb.id, ab.id, v.std, v.cert, v.status, v.issued::date, v.expires::date,
       'https://registry.example/' || lower(ab.code) || '/' || v.cert
FROM (VALUES
    ('Qualitas Certificazioni S.r.l.',    'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-101A',  'ACTIVE',    '2022-04-01', '2030-03-31'),
    ('Qualitas Certificazioni S.r.l.',    'ACCREDIA', 'ISO/IEC 27006',   'ACC-ISMS-102B', 'ACTIVE',    '2023-01-15', '2031-01-14'),
    ('Nord Est Certificazioni S.p.A.',    'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-115A',  'ACTIVE',    '2021-06-10', '2029-06-09'),
    ('Nord Est Certificazioni S.p.A.',    'ACCREDIA', 'ISO 50003',       'ACC-SGE-031',   'ACTIVE',    '2023-09-01', '2031-08-31'),
    ('Tecno Audit Italia S.r.l.',         'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-127A',  'ACTIVE',    '2020-11-20', '2028-11-19'),
    ('Tecno Audit Italia S.r.l.',         'ACCREDIA', 'ISO/IEC 27006',   'ACC-ISMS-128B', 'ACTIVE',    '2022-02-01', '2030-01-31'),
    ('Metalcert Europe S.r.l.',           'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-133A',  'ACTIVE',    '2019-05-05', '2027-05-04'),
    ('Lombardia Safety Cert S.r.l.',      'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-141A',  'ACTIVE',    '2022-07-01', '2030-06-30'),
    ('InfoSec Assurance Italia S.r.l.',   'ACCREDIA', 'ISO/IEC 27006',   'ACC-ISMS-150B', 'ACTIVE',    '2024-03-01', '2032-02-28'),
    ('Energia Certa S.r.l.',              'ACCREDIA', 'ISO/IEC 17021-1', 'ACC-SGQ-162A',  'ACTIVE',    '2021-10-01', '2029-09-30'),
    ('Energia Certa S.r.l.',              'ACCREDIA', 'ISO 50003',       'ACC-SGE-044',   'ACTIVE',    '2022-10-01', '2030-09-30'),
    ('Sigma Quality Registrar Ltd',       'UKAS',     'ISO/IEC 17021-1', 'UKAS-0417',     'ACTIVE',    '2018-03-12', '2028-03-11'),
    ('Sigma Quality Registrar Ltd',       'UKAS',     'ISO/IEC 27006',   'UKAS-0418',     'ACTIVE',    '2020-08-01', '2028-07-31'),
    ('Albion Certification Services Ltd', 'UKAS',     'ISO/IEC 17021-1', 'UKAS-1123',     'ACTIVE',    '2021-01-04', '2029-01-03'),
    ('Mainfranken Zertifizierung GmbH',   'DAkkS',    'ISO/IEC 17021-1', 'D-ZM-19001-01', 'ACTIVE',    '2020-02-17', '2030-02-16'),
    ('Mainfranken Zertifizierung GmbH',   'DAkkS',    'ISO 50003',       'D-ZM-19001-02', 'ACTIVE',    '2021-05-03', '2031-05-02'),
    ('CertRom Audit S.R.L.',              'RENAR',    'ISO/IEC 17021-1', 'SC 251',        'SUSPENDED', '2019-09-09', '2027-09-08'),
    ('Polcert Sp. z o.o.',                'PCA',      'ISO/IEC 17021-1', 'AC 188',        'ACTIVE',    '2020-12-01', '2028-11-30'),
    ('Polcert Sp. z o.o.',                'PCA',      'ISO 50003',       'AC 189',        'ACTIVE',    '2018-07-01', '2026-06-30'),
    ('Adriatik Cert Sh.p.k.',             'DPA',      'ISO/IEC 17021-1', 'DPA-CS-027',    'ACTIVE',    '2022-05-20', '2027-05-19')
) AS v(cb_name, ab_code, std, cert, status, issued, expires)
JOIN certification_bodies cb ON cb.name = v.cb_name
JOIN accreditation_bodies ab ON ab.code = v.ab_code;

-- Issuing rights per certificate: (certificate, certification standard, EA codes).
-- An empty EA array means "all EA sectors 1..39".
INSERT INTO accredited_scopes (accreditation_id, accreditation_standard, certification_standard, ea_code)
SELECT a.id, a.accreditation_standard, v.std, ea
FROM (VALUES
    ('ACC-SGQ-101A',  'ISO 9001',      ARRAY[1, 2, 5, 23, 25, 26]),
    ('ACC-SGQ-101A',  'ISO 14001',     ARRAY[1, 2, 25, 26]),
    ('ACC-ISMS-102B', 'ISO/IEC 27001', ARRAY[]::int[]),

    ('ACC-SGQ-115A',  'ISO 9001',      ARRAY[17, 18, 19, 28, 29, 34]),
    ('ACC-SGQ-115A',  'ISO 14001',     ARRAY[17, 18, 28]),
    ('ACC-SGQ-115A',  'ISO 45001',     ARRAY[17, 18, 28]),
    ('ACC-SGE-031',   'ISO 50001',     ARRAY[17, 18, 25, 26]),

    ('ACC-SGQ-127A',  'ISO 9001',      ARRAY[33, 34, 35, 37, 38]),
    ('ACC-SGQ-127A',  'ISO 14001',     ARRAY[34, 35]),
    ('ACC-SGQ-127A',  'ISO 45001',     ARRAY[34, 35]),
    ('ACC-ISMS-128B', 'ISO/IEC 27001', ARRAY[]::int[]),

    ('ACC-SGQ-133A',  'ISO 9001',      ARRAY[14, 15, 16, 17, 18, 20, 22]),
    ('ACC-SGQ-133A',  'ISO 14001',     ARRAY[17]),

    ('ACC-SGQ-141A',  'ISO 9001',      ARRAY[28, 34, 35, 37, 38]),
    ('ACC-SGQ-141A',  'ISO 14001',     ARRAY[17, 28, 34]),
    ('ACC-SGQ-141A',  'ISO 45001',     ARRAY[17, 28, 34]),

    ('ACC-ISMS-150B', 'ISO/IEC 27001', ARRAY[]::int[]),

    ('ACC-SGQ-162A',  'ISO 9001',      ARRAY[17, 25, 26, 27]),
    ('ACC-SGE-044',   'ISO 50001',     ARRAY[17, 18, 25, 26, 27, 28, 29, 30]),

    ('UKAS-0417',     'ISO 9001',      ARRAY[3, 12, 13, 14, 17, 19, 29, 31, 33]),
    ('UKAS-0417',     'ISO 45001',     ARRAY[17, 28, 29]),
    ('UKAS-0418',     'ISO/IEC 27001', ARRAY[]::int[]),

    ('UKAS-1123',     'ISO 9001',      ARRAY[1, 3, 4, 6, 7, 9, 12, 14, 17, 18, 19, 23, 29, 30, 31, 32, 33, 35, 37, 38, 39]),

    ('D-ZM-19001-01', 'ISO 9001',      ARRAY[17, 18, 19, 20, 21, 22]),
    ('D-ZM-19001-01', 'ISO 14001',     ARRAY[17, 18, 19]),
    ('D-ZM-19001-02', 'ISO 50001',     ARRAY[]::int[]),

    ('SC 251',        'ISO 9001',      ARRAY[1, 3, 17, 28, 29, 30, 35, 37]),

    ('AC 188',        'ISO 9001',      ARRAY[17, 18, 28, 29, 31]),
    ('AC 188',        'ISO 14001',     ARRAY[17, 28]),
    ('AC 189',        'ISO 50001',     ARRAY[17, 25]),

    ('DPA-CS-027',    'ISO 9001',      ARRAY[17, 28, 29, 30, 35])
) AS v(cert, std, eas)
JOIN accreditations a ON a.certificate_number = v.cert
CROSS JOIN LATERAL unnest(
    CASE WHEN cardinality(v.eas) = 0 THEN ARRAY(SELECT generate_series(1, 39)) ELSE v.eas END
) AS ea;

-- Albanian bodies from their DPA accreditation annexes (CS 006 Legal Cert, CS 007 AXE Register).
-- Lettered categories are classified by sector: ISO 50001 A-H, ISO 22000 A-K, ISO 13485 device
-- categories. ISO 22301 covers all eight categories, so it is recorded for all 39 sectors.

INSERT INTO accreditations
    (certification_body_id, accreditation_body_id, accreditation_standard, certificate_number,
     status, issue_date, expiry_date, proof_url)
SELECT cb.id, ab.id, v.std, v.cert, 'ACTIVE', v.issued::date, v.expires::date, 'https://www.dpa.gov.al'
FROM (VALUES
    ('Legal Cert sh.p.k',   'ISO/IEC 17021-1', 'CS 006',         '2025-12-16', '2029-12-15'),
    ('Legal Cert sh.p.k',   'ISO/IEC 27006',   'CS 006 (27006)', '2025-12-16', '2029-12-15'),
    ('Legal Cert sh.p.k',   'ISO/IEC 17021-9', 'CS 006 (37001)', '2025-12-16', '2029-12-15'),
    ('Legal Cert sh.p.k',   'ISO 50003',       'CS 006 (50003)', '2025-12-16', '2029-12-15'),
    ('AXE Register sh.p.k', 'ISO/IEC 17021-1', 'CS 007',         '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 27006',   'CS 007 (27006)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO 50003',       'CS 007 (50003)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 17021-6', 'CS 007 (22301)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO 22003-1',     'CS 007 (22000)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 20000-6', 'CS 007 (20000)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 17021-7', 'CS 007 (39001)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 17021-4', 'CS 007 (20121)', '2026-02-24', '2030-02-23'),
    ('AXE Register sh.p.k', 'ISO/IEC 17021-9', 'CS 007 (37001)', '2026-02-24', '2030-02-23')
) AS v(cb_name, std, cert, issued, expires)
JOIN certification_bodies cb ON cb.name = v.cb_name
JOIN accreditation_bodies ab ON ab.code = 'DPA';

-- AXE 9001 / 14001 / 45001 annexes list EA 1-39 except 11.
-- Legal Cert 27006 and 37001 annexes say "all IAF codes"; AXE annexes without a sector list
-- (27001, 27701, 27017, 27018, 20000-1, 39001, 20121, 37001) are recorded for all 39.
INSERT INTO accredited_scopes (accreditation_id, accreditation_standard, certification_standard, ea_code)
SELECT a.id, a.accreditation_standard, v.std, ea
FROM (VALUES
    ('CS 006',         'ISO 9001',      ARRAY[1, 3, 17, 18]),
    ('CS 006',         'ISO 14001',     ARRAY[1, 3, 17, 18, 24]),
    ('CS 006',         'ISO 45001',     ARRAY[1, 3, 17, 18, 24, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 006 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 006 (37001)', 'ISO 37001',     ARRAY(SELECT generate_series(1, 39))),
    ('CS 006 (50003)', 'ISO 50001',     ARRAY[1, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 28, 30, 31, 32, 34, 36, 37, 38, 39]),

    ('CS 007',         'ISO 9001',      ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11)),
    ('CS 007',         'ISO 14001',     ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11)),
    ('CS 007',         'ISO 45001',     ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11)),
    ('CS 007',         'ISO 13485',     ARRAY[13, 14, 17, 18, 19, 29, 31, 34, 35]),
    ('CS 007 (50003)', 'ISO 50001',     ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 007 (22301)', 'ISO 22301',     ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (22000)', 'ISO 22000',     ARRAY[1, 3, 7, 12, 13, 14, 15, 17, 18, 29, 30, 31, 35]),
    ('CS 007 (20000)', 'ISO/IEC 20000-1', ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (39001)', 'ISO 39001',     ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (20121)', 'ISO 20121',     ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (37001)', 'ISO 37001',     ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (27006)', 'ISO/IEC 27701', ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (27006)', 'ISO/IEC 27017', ARRAY(SELECT generate_series(1, 39))),
    ('CS 007 (27006)', 'ISO/IEC 27018', ARRAY(SELECT generate_series(1, 39)))
) AS v(cert, std, eas)
JOIN accreditations a ON a.certificate_number = v.cert
CROSS JOIN LATERAL unnest(v.eas) AS ea;

-- Albanian bodies CS 008-CS 019 (DPA annexes). Sector lists are transcribed from the annexes;
-- lettered categories (ISO 50001 A-H, ISO 22000 A-K, ISO 22301 A-H, ISO 13485 device categories)
-- are classified to EA codes by sector, as for the earlier Albanian bodies.
INSERT INTO accreditation_scheme_rules (accreditation_standard, certification_standard) VALUES
('ISO/IEC 17021-1', 'ISO 37001'),
('ISO/IEC 17021-1', 'ISO 22301');

INSERT INTO accreditations
    (certification_body_id, accreditation_body_id, accreditation_standard, certificate_number,
     status, issue_date, expiry_date, proof_url)
SELECT cb.id, ab.id, v.std, v.cert, 'ACTIVE', v.issued::date, v.expires::date, 'https://www.dpa.gov.al'
FROM (VALUES
    ('AQScert', 'ISO/IEC 17021-1', 'CS 008', '2026-03-27', '2030-03-26'),
    ('AQScert', 'ISO/IEC 27006', 'CS 008 (27006)', '2026-03-27', '2030-03-26'),
    ('AQScert', 'ISO 50003', 'CS 008 (50003)', '2026-03-27', '2030-03-26'),
    ('AQScert', 'ISO 22003-1', 'CS 008 (22000)', '2026-03-27', '2030-03-26'),

    ('CAREER CERT INSTITUTE sh.p.k', 'ISO/IEC 17021-1', 'CS 009', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO/IEC 27006', 'CS 009 (27006)', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO/IEC 17021-9', 'CS 009 (37001)', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO/IEC 17021-7', 'CS 009 (39001)', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO/IEC 20000-6', 'CS 009 (20000)', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO 50003', 'CS 009 (50003)', '2025-11-27', '2026-12-01'),
    ('CAREER CERT INSTITUTE sh.p.k', 'ISO 22003-1', 'CS 009 (22000)', '2025-11-27', '2026-12-01'),

    ('European Quality and Safety Control (EQSC) sh.p.k', 'ISO/IEC 17021-1', 'CS 010', '2025-11-27', '2026-12-02'),
    ('European Quality and Safety Control (EQSC) sh.p.k', 'ISO 50003', 'CS 010 (50003)', '2025-11-27', '2026-12-02'),
    ('European Quality and Safety Control (EQSC) sh.p.k', 'ISO 22003-1', 'CS 010 (22000)', '2025-11-27', '2026-12-02'),
    ('European Quality and Safety Control (EQSC) sh.p.k', 'ISO/IEC 27006', 'CS 010 (27006)', '2025-11-27', '2026-12-02'),

    ('CERTIS sh.p.k', 'ISO/IEC 17021-1', 'CS 011', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO 50003', 'CS 011 (50003)', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO 22003-1', 'CS 011 (22000)', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO/IEC 27006', 'CS 011 (27006)', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO/IEC 20000-6', 'CS 011 (20000)', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO/IEC 17021-7', 'CS 011 (39001)', '2025-11-27', '2029-02-23'),
    ('CERTIS sh.p.k', 'ISO/IEC 17021-9', 'CS 011 (37001)', '2025-11-27', '2029-02-23'),

    ('e-Cert sh.p.k', 'ISO/IEC 17021-1', 'CS 014', '2025-12-10', '2027-11-08'),
    ('e-Cert sh.p.k', 'ISO 22003-1', 'CS 014 (22000)', '2025-12-10', '2027-11-08'),
    ('e-Cert sh.p.k', 'ISO/IEC 27006', 'CS 014 (27006)', '2025-12-10', '2027-11-08'),

    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 17021-1', 'CS 015', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO 50003', 'CS 015 (50003)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 17021-6', 'CS 015 (22301)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO 22003-1', 'CS 015 (22000)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 27006', 'CS 015 (27006)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 17021-9', 'CS 015 (37001)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 17021-7', 'CS 015 (39001)', '2025-11-27', '2028-09-29'),
    ('Risk Control Advisory – R.C.A sh.p.k', 'ISO/IEC 20000-6', 'CS 015 (20000)', '2025-11-27', '2028-09-29'),

    ('M.G BUGATTI CERTIFICATION sh.p.k', 'ISO/IEC 17021-1', 'CS 016', '2025-11-27', '2028-11-14'),
    ('M.G BUGATTI CERTIFICATION sh.p.k', 'ISO/IEC 27006', 'CS 016 (27006)', '2025-11-27', '2028-11-14'),

    ('MSC CERTIFICATIONS sh.p.k', 'ISO/IEC 17021-1', 'CS 017', '2025-11-27', '2028-11-17'),
    ('MSC CERTIFICATIONS sh.p.k', 'ISO 50003', 'CS 017 (50003)', '2025-11-27', '2028-11-17'),
    ('MSC CERTIFICATIONS sh.p.k', 'ISO 22003-1', 'CS 017 (22000)', '2025-11-27', '2028-11-17'),
    ('MSC CERTIFICATIONS sh.p.k', 'ISO/IEC 27006', 'CS 017 (27006)', '2025-11-27', '2028-11-17'),

    ('AUTENTICERT Albania sh.p.k', 'ISO/IEC 17021-1', 'CS 018', '2026-01-20', '2030-01-19'),
    ('AUTENTICERT Albania sh.p.k', 'ISO/IEC 17021-7', 'CS 018 (39001)', '2026-01-20', '2030-01-19'),
    ('AUTENTICERT Albania sh.p.k', 'ISO/IEC 27006', 'CS 018 (27006)', '2026-01-20', '2030-01-19'),

    ('CERTI AL sh.p.k', 'ISO/IEC 17021-1', 'CS 019', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO 50003', 'CS 019 (50003)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 17021-6', 'CS 019 (22301)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO 22003-1', 'CS 019 (22000)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 27006', 'CS 019 (27006)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 20000-6', 'CS 019 (20000)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 17021-7', 'CS 019 (39001)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 17021-9', 'CS 019 (37001)', '2026-08-17', '2030-08-16'),
    ('CERTI AL sh.p.k', 'ISO/IEC 17021-4', 'CS 019 (20121)', '2026-08-17', '2030-08-16')
) AS v(cb_name, std, cert, issued, expires)
JOIN certification_bodies cb ON cb.name = v.cb_name
JOIN accreditation_bodies ab ON ab.code = 'DPA';

INSERT INTO accredited_scopes (accreditation_id, accreditation_standard, certification_standard, ea_code)
SELECT a.id, a.accreditation_standard, v.std, ea
FROM (VALUES
    -- AQScert
    ('CS 008', 'ISO 9001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 008', 'ISO 14001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 008', 'ISO 45001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 008', 'ISO 22301', ARRAY(SELECT generate_series(1, 39))),
    ('CS 008 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 008 (27006)', 'ISO/IEC 27701', ARRAY(SELECT generate_series(1, 39))),
    ('CS 008 (27006)', 'ISO/IEC 27017', ARRAY(SELECT generate_series(1, 39))),
    ('CS 008 (50003)', 'ISO 50001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 008 (22000)', 'ISO 22000', ARRAY[1, 3, 7, 12, 13, 14, 15, 17, 29, 30, 31, 35]),

    -- Career Cert Institute
    ('CS 009', 'ISO 9001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 009', 'ISO 14001', ARRAY(SELECT generate_series(2, 39))),
    ('CS 009', 'ISO 45001', ARRAY(SELECT generate_series(2, 39))),
    ('CS 009 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 009 (37001)', 'ISO 37001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 009 (39001)', 'ISO 39001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 009 (20000)', 'ISO/IEC 20000-1', ARRAY(SELECT generate_series(1, 39))),
    ('CS 009 (50003)', 'ISO 50001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 009 (22000)', 'ISO 22000', ARRAY[1, 3, 7, 12, 13, 14, 15, 17, 29, 30, 31]),

    -- EQSC
    ('CS 010', 'ISO 9001', ARRAY[3, 4, 5, 9, 12, 13, 15, 16, 17, 19, 22, 23, 28, 29, 30, 31, 33, 34, 35]),
    ('CS 010', 'ISO 14001', ARRAY[3, 4, 5, 9, 12, 13, 15, 16, 17, 19, 22, 23, 28, 29, 30, 31, 33, 34, 35]),
    ('CS 010', 'ISO 45001', ARRAY[3, 4, 5, 9, 12, 13, 15, 16, 17, 19, 22, 23, 28, 29, 30, 31, 33, 34, 35]),
    ('CS 010 (50003)', 'ISO 50001', ARRAY[30, 31, 32, 36, 37, 38, 39]),
    ('CS 010 (22000)', 'ISO 22000', ARRAY[3, 29, 30]),
    ('CS 010 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 010 (27006)', 'ISO/IEC 27701', ARRAY(SELECT generate_series(1, 39))),
    ('CS 010 (27006)', 'ISO/IEC 27017', ARRAY(SELECT generate_series(1, 39))),

    -- CERTIS
    ('CS 011', 'ISO 9001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 38, 39]),
    ('CS 011', 'ISO 14001', ARRAY[1, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 011', 'ISO 45001', ARRAY[1, 3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 011 (50003)', 'ISO 50001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 011 (22000)', 'ISO 22000', ARRAY[3, 7, 12, 13, 14, 15, 17, 29, 30, 31, 35]),
    ('CS 011 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 011 (20000)', 'ISO/IEC 20000-1', ARRAY(SELECT generate_series(1, 39))),
    ('CS 011 (39001)', 'ISO 39001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 011 (37001)', 'ISO 37001', ARRAY(SELECT generate_series(1, 39))),

    -- e-Cert
    ('CS 014', 'ISO 9001', ARRAY[3, 4, 5, 8, 9, 12, 14, 16, 17, 18, 19, 24, 28, 29, 30, 31, 32, 33, 34, 35, 37, 38, 39]),
    ('CS 014', 'ISO 14001', ARRAY[3, 4, 5, 8, 9, 12, 14, 16, 17, 18, 19, 24, 28, 29, 30, 31, 32, 33, 34, 35, 37, 38, 39]),
    ('CS 014', 'ISO 45001', ARRAY[3, 4, 5, 8, 9, 12, 14, 16, 17, 18, 19, 24, 28, 29, 30, 31, 32, 33, 34, 35, 37, 38, 39]),
    ('CS 014 (22000)', 'ISO 22000', ARRAY[3, 7, 14, 15, 17, 29, 30, 31, 35]),
    ('CS 014 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),

    -- RCA
    ('CS 015', 'ISO 9001', ARRAY[1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 015', 'ISO 14001', ARRAY[1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 015', 'ISO 45001', ARRAY[1, 3, 4, 5, 6, 7, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 015 (50003)', 'ISO 50001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 015 (22301)', 'ISO 22301', ARRAY[1, 2, 3, 4, 5, 6, 7, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39]),
    ('CS 015 (22000)', 'ISO 22000', ARRAY[1, 3, 7, 12, 13, 14, 15, 17, 29, 30, 31, 35]),
    ('CS 015 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (27006)', 'ISO/IEC 27701', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (27006)', 'ISO/IEC 27017', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (27006)', 'ISO/IEC 27018', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (37001)', 'ISO 37001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (39001)', 'ISO 39001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 015 (20000)', 'ISO/IEC 20000-1', ARRAY(SELECT generate_series(1, 39))),

    -- Bugatti
    ('CS 016', 'ISO 9001', ARRAY[17, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37]),
    ('CS 016', 'ISO 14001', ARRAY[17, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37]),
    ('CS 016', 'ISO 45001', ARRAY[7, 10, 12, 13, 14, 15, 16, 17, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37]),
    ('CS 016 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),

    -- MSC
    ('CS 017', 'ISO 9001', ARRAY[3, 4, 6, 12, 14, 16, 17, 18, 19, 23]),
    ('CS 017', 'ISO 14001', ARRAY[3, 4, 6, 12, 14, 16, 17, 18, 19, 23, 24]),
    ('CS 017', 'ISO 45001', ARRAY[3, 4, 6, 12, 14, 16, 17, 18, 19, 23, 24, 28, 29, 30, 31, 33, 34, 35, 39]),
    ('CS 017 (50003)', 'ISO 50001', ARRAY[3, 4, 5, 6, 7, 8, 9, 12, 13, 14, 18, 19, 22, 23, 24, 30, 31, 32, 36, 37, 38, 39]),
    ('CS 017 (22000)', 'ISO 22000', ARRAY[3, 29, 30, 31]),
    ('CS 017 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),

    -- Autenticert
    ('CS 018', 'ISO 37001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 018 (39001)', 'ISO 39001', ARRAY[28, 31, 36]),
    ('CS 018 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),

    -- Certi AL
    ('CS 019', 'ISO 9001', ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11)),
    ('CS 019', 'ISO 14001', ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11)),
    ('CS 019', 'ISO 45001', ARRAY(SELECT generate_series(1, 39) EXCEPT SELECT 11 EXCEPT SELECT 21 EXCEPT SELECT 22)),
    ('CS 019', 'ISO 13485', ARRAY[13, 14, 17, 18, 19, 29, 31, 34, 35]),
    ('CS 019 (50003)', 'ISO 50001', ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32, 34, 36, 37, 38, 39]),
    ('CS 019 (22301)', 'ISO 22301', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (22000)', 'ISO 22000', ARRAY[1, 3, 7, 12, 13, 14, 15, 17, 29, 30, 31, 35]),
    ('CS 019 (27006)', 'ISO/IEC 27001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (27006)', 'ISO/IEC 27701', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (27006)', 'ISO/IEC 27017', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (27006)', 'ISO/IEC 27018', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (20000)', 'ISO/IEC 20000-1', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (39001)', 'ISO 39001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (37001)', 'ISO 37001', ARRAY(SELECT generate_series(1, 39))),
    ('CS 019 (20121)', 'ISO 20121', ARRAY(SELECT generate_series(1, 39)))
) AS v(cert, std, eas)
JOIN accreditations a ON a.certificate_number = v.cert
CROSS JOIN LATERAL unnest(v.eas) AS ea;

-- EA 7 is limited to paper products in these annexes; EA 17 is split (17a/17b) in the RCA 14001/45001 annexes.
UPDATE accredited_scopes s
SET scope_note = 'E kufizuar vetëm tek produktet prej letre'
FROM accreditations a
WHERE a.id = s.accreditation_id
  AND a.certificate_number IN ('CS 008', 'CS 019')
  AND s.certification_standard IN ('ISO 9001', 'ISO 14001', 'ISO 45001')
  AND s.ea_code = 7;

UPDATE accredited_scopes s
SET scope_note = '17a: kufizuar në produkte metalike të fabrikuara; 17b: e kufizuar në prodhimin e metaleve bazë'
FROM accreditations a
WHERE a.id = s.accreditation_id
  AND a.certificate_number = 'CS 015'
  AND s.certification_standard IN ('ISO 14001', 'ISO 45001')
  AND s.ea_code = 17;
-- Scope-level exceptions under otherwise active accreditations.
UPDATE accredited_scopes s
SET status = 'WITHDRAWN', scope_note = 'Withdrawn by ACCREDIA on 2025-11-12 after witness audit'
FROM accreditations a
WHERE a.id = s.accreditation_id
  AND a.certificate_number = 'ACC-SGQ-162A' AND s.certification_standard = 'ISO 9001' AND s.ea_code = 17;

UPDATE accredited_scopes s
SET status = 'SUSPENDED', scope_note = 'Suspended pending competence evidence for EA 38'
FROM accreditations a
WHERE a.id = s.accreditation_id
  AND a.certificate_number = 'ACC-SGQ-127A' AND s.certification_standard = 'ISO 9001' AND s.ea_code = 38;

COMMIT;
