-- =====================================================================
-- V2__seed_reference_data.sql
-- NOTE: nab_mla is intentionally NOT seeded. Fill it from the official
--       EA / IAF signatory lists and record verified_at / verified_by.
-- =====================================================================

-- Countries for phase 1 (add the other EA members as connectors/imports are built)
INSERT INTO country (iso_code, name, nab_name, nab_website) VALUES
    ('IT', 'Italy',   'ACCREDIA',                         'https://www.accredia.it'),
    ('AL', 'Albania', 'Directorate of Accreditation (DPA)', NULL);  -- verify exact name/website

-- Accreditation standards (what the CB is accredited against)
INSERT INTO standard (code, title, kind, scheme, uses_ea_codes) VALUES
    ('ISO 9001',       'Quality management systems',                                  'CERTIFICATION', 'MANAGEMENT_SYSTEM', TRUE),
    ('ISO 14001',      'Environmental management systems',                            'CERTIFICATION', 'MANAGEMENT_SYSTEM', TRUE),
    ('ISO 45001',      'Occupational health and safety management systems',           'CERTIFICATION', 'MANAGEMENT_SYSTEM', TRUE),
    ('ISO/IEC 27001',  'Information security management systems',                     'CERTIFICATION', 'MANAGEMENT_SYSTEM', TRUE),
    ('ISO/IEC 17021-1', 'Conformity assessment - Bodies providing audit and certification of management systems', 'ACCREDITATION', 'MANAGEMENT_SYSTEM', TRUE),
    ('ISO/IEC 17065',   'Conformity assessment - Bodies certifying products, processes and services',              'ACCREDITATION', 'PRODUCT',           FALSE),
    ('ISO/IEC 17024',   'Conformity assessment - Bodies operating certification of persons',                       'ACCREDITATION', 'PERSONNEL',         FALSE),
    ('ISO/IEC 17025',   'General requirements for the competence of testing and calibration laboratories',         'ACCREDITATION', 'LABORATORY',        FALSE),
    ('ISO 15189',       'Medical laboratories - Requirements for quality and competence',                          'ACCREDITATION', 'MEDICAL_LABORATORY',FALSE),
    ('ISO/IEC 17020',   'Conformity assessment - Requirements for the operation of various types of inspection bodies', 'ACCREDITATION', 'INSPECTION',   FALSE);

-- Management-system standards are accredited under ISO/IEC 17021-1
INSERT INTO standard_link (certification_standard_id, accreditation_standard_id)
SELECT cs.id, ast.id
FROM standard cs, standard ast
WHERE cs.kind = 'CERTIFICATION' AND cs.scheme = 'MANAGEMENT_SYSTEM'
  AND ast.code = 'ISO/IEC 17021-1';

-- EA / IAF sector codes
INSERT INTO ea_sector (code, name_en, name_it) VALUES
    (1,  'Agriculture, fishing',                                         'Agricoltura, pesca'),
    (2,  'Mining and quarrying',                                         'Estrazione di minerali'),
    (3,  'Food products, beverages and tobacco',                         'Prodotti alimentari, bevande e tabacco'),
    (4,  'Textiles and textile products',                                'Tessili e prodotti tessili'),
    (5,  'Leather and leather products',                                 'Cuoio e prodotti in cuoio'),
    (6,  'Wood and wood products',                                       'Legno e prodotti in legno'),
    (7,  'Pulp, paper and paper products',                               'Pasta carta, carta e prodotti di carta'),
    (8,  'Publishing companies',                                         'Editoria'),
    (9,  'Printing companies',                                           'Stampa'),
    (10, 'Manufacture of coke and refined petroleum products',           'Coke e prodotti petroliferi raffinati'),
    (11, 'Nuclear fuel',                                                 'Combustibile nucleare'),
    (12, 'Chemicals, chemical products and fibres',                      'Prodotti chimici e fibre'),
    (13, 'Pharmaceuticals',                                              'Prodotti farmaceutici'),
    (14, 'Rubber and plastic products',                                  'Prodotti in gomma e plastica'),
    (15, 'Non-metallic mineral products',                                'Prodotti della lavorazione di minerali non metalliferi'),
    (16, 'Concrete, cement, lime, plaster etc.',                         'Calcestruzzo, cemento, calce, gesso ecc.'),
    (17, 'Basic metals and fabricated metal products',                   'Metalli e prodotti in metallo'),
    (18, 'Machinery and equipment',                                      'Macchine e apparecchi meccanici'),
    (19, 'Electrical and optical equipment',                             'Apparecchiature elettriche ed ottiche'),
    (20, 'Shipbuilding',                                                 'Costruzioni navali'),
    (21, 'Aerospace',                                                    'Aerospaziale'),
    (22, 'Other transport equipment',                                    'Altre apparecchiature per il trasporto'),
    (23, 'Manufacturing not elsewhere classified',                       'Altre attivita manifatturiere'),
    (24, 'Recycling',                                                    'Recupero e riciclo'),
    (25, 'Electricity supply',                                           'Fornitura di energia elettrica'),
    (26, 'Gas supply',                                                   'Fornitura di gas'),
    (27, 'Water supply',                                                 'Fornitura di acqua'),
    (28, 'Construction',                                                 'Costruzioni'),
    (29, 'Wholesale and retail trade; repair of motor vehicles',         'Commercio all''ingrosso e al dettaglio; riparazione veicoli'),
    (30, 'Hotels and restaurants',                                       'Alberghi e ristoranti'),
    (31, 'Transport, storage and communication',                         'Trasporti, magazzinaggio e comunicazioni'),
    (32, 'Financial intermediation, real estate, renting',               'Intermediazione finanziaria, attivita immobiliari, noleggio'),
    (33, 'Information technology',                                       'Tecnologia dell''informazione'),
    (34, 'Engineering services',                                         'Servizi di ingegneria'),
    (35, 'Other services',                                               'Altri servizi'),
    (36, 'Public administration',                                        'Pubblica amministrazione'),
    (37, 'Education',                                                    'Istruzione'),
    (38, 'Health and social work',                                       'Sanita e altri servizi sociali'),
    (39, 'Other social services',                                        'Altri servizi sociali');
