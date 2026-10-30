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

INSERT INTO accreditation_bodies (code, name, country, is_iaf_mla, website) VALUES
('ACCREDIA', 'ACCREDIA - Ente Italiano di Accreditamento',          'Italy',          TRUE,  'https://www.accredia.it'),
('UKAS',     'United Kingdom Accreditation Service',                'United Kingdom', TRUE,  'https://www.ukas.com'),
('DAkkS',    'Deutsche Akkreditierungsstelle',                      'Germany',        TRUE,  'https://www.dakks.de'),
('RENAR',    'Asociatia de Acreditare din Romania',                 'Romania',        TRUE,  'https://www.renar.ro'),
('PCA',      'Polskie Centrum Akredytacji',                         'Poland',         TRUE,  'https://www.pca.gov.pl'),
('DPA',      'Drejtoria e Pergjithshme e Akreditimit',              'Albania',        FALSE, 'https://www.dpa.gov.al');

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
('ISO 50001',       'Energy management systems',                          'CERTIFICATION');

INSERT INTO accreditation_scheme_rules (accreditation_standard, certification_standard) VALUES
('ISO/IEC 17021-1', 'ISO 9001'),
('ISO/IEC 17021-1', 'ISO 14001'),
('ISO/IEC 17021-1', 'ISO 45001'),
('ISO/IEC 27006',   'ISO/IEC 27001'),
('ISO 50003',       'ISO 50001');

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
('Adriatik Cert Sh.p.k.',              'Albania',        '+355 4 555 1300',  'info@adriatikcert.example',    'https://adriatikcert.example',    'Rruga e Kavajës 60, 1001 Tiranë');

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
