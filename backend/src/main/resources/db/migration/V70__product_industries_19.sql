-- Product certification (ISO/IEC 17065): replace the 13 starter industries with a list of
-- 19 sectors, closer to how Italian companies describe their business. "Tutti i settori"
-- is the empty choice in the search form, not a row here.
--
-- Old -> new: forestry -> wood_paper, packaging -> rubber_plastics (and wood_paper for
-- schemes), transport -> transport_equipment for lines (all of them were railway) and
-- trade_logistics for logistics schemes, services -> professional. The other codes keep
-- their name. Line industries are refined again when the datasets are re-imported.

INSERT INTO industries (code, name_it, name_en, sort_order) VALUES
    ('wood_paper',          'Legno, carta e stampa',                         'Wood, paper and printing',                      104),
    ('rubber_plastics',     'Gomma e plastica',                              'Rubber and plastics',                           106),
    ('metals',              'Metalli e prodotti in metallo',                 'Metals and metal products',                     108),
    ('transport_equipment', 'Mezzi di trasporto',                            'Transport equipment',                           111),
    ('other_manufacturing', 'Altri manufatti e riciclo',                     'Other manufacturing and recycling',             112),
    ('trade_logistics',     'Commercio, trasporti e logistica',              'Trade, transport and logistics',                114),
    ('tourism',             'Turismo e ristorazione',                        'Tourism and catering',                          115),
    ('professional',        'Servizi professionali e finanziari',            'Professional and financial services',           117),
    ('public_education',    'Pubblica amministrazione e istruzione',         'Public administration and education',           118),
    ('health',              'Sanità e servizi sociali',                      'Health and social services',                    119);

UPDATE product_scopes SET industry_code = CASE industry_code
        WHEN 'forestry'  THEN 'wood_paper'
        WHEN 'packaging' THEN 'rubber_plastics'
        WHEN 'transport' THEN 'transport_equipment'
        WHEN 'services'  THEN 'professional'
    END
WHERE industry_code IN ('forestry', 'packaging', 'transport', 'services');

DELETE FROM scheme_industries;
DELETE FROM industries WHERE code IN ('forestry', 'packaging', 'transport', 'services');

UPDATE industries SET sort_order = 100 + sort_order WHERE sort_order < 100;
UPDATE industries AS i SET name_it = v.name_it, name_en = v.name_en, sort_order = v.sort_order
FROM (VALUES
    ('agriculture',         'Agricoltura, foreste, pesca e acquacoltura',     'Agriculture, forestry, fishing and aquaculture', 1),
    ('food',                'Alimenti, bevande e mangimi',                    'Food, beverages and feed',                       2),
    ('textiles',            'Tessile, abbigliamento e pelle',                 'Textiles, clothing and leather',                 3),
    ('wood_paper',          'Legno, carta e stampa',                          'Wood, paper and printing',                       4),
    ('chemicals',           'Chimica, farmaceutica e cosmetici',              'Chemicals, pharmaceuticals and cosmetics',       5),
    ('rubber_plastics',     'Gomma e plastica',                               'Rubber and plastics',                            6),
    ('construction',        'Edilizia, materiali da costruzione ed estrazione','Construction, building materials and quarrying', 7),
    ('metals',              'Metalli e prodotti in metallo',                  'Metals and metal products',                      8),
    ('machinery',           'Macchine e attrezzature',                        'Machinery and equipment',                        9),
    ('electrical',          'Elettrico, elettronico e ottico',                'Electrical, electronic and optical',            10),
    ('transport_equipment', 'Mezzi di trasporto',                             'Transport equipment',                           11),
    ('other_manufacturing', 'Altri manufatti e riciclo',                      'Other manufacturing and recycling',             12),
    ('energy',              'Energia, gas, acqua e raffinazione',             'Energy, gas, water and refining',               13),
    ('trade_logistics',     'Commercio, trasporti e logistica',               'Trade, transport and logistics',                14),
    ('tourism',             'Turismo e ristorazione',                         'Tourism and catering',                          15),
    ('ict',                 'ICT e servizi digitali',                         'ICT and digital services',                      16),
    ('professional',        'Servizi professionali e finanziari',             'Professional and financial services',           17),
    ('public_education',    'Pubblica amministrazione e istruzione',          'Public administration and education',           18),
    ('health',              'Sanità e servizi sociali',                       'Health and social services',                    19)
) AS v (code, name_it, name_en, sort_order)
WHERE i.code = v.code;

INSERT INTO scheme_industries (scheme_code, industry_code)
SELECT v.scheme_code, v.industry_code
FROM (VALUES
    ('GLOBALG.A.P. IFA',                                        'agriculture'),
    ('GLOBALG.A.P. Chain of Custody',                           'agriculture'),
    ('GLOBALG.A.P. Chain of Custody',                           'food'),
    ('BRCGS Food Safety',                                       'food'),
    ('BRCGS Packaging Materials',                               'wood_paper'),
    ('BRCGS Packaging Materials',                               'rubber_plastics'),
    ('BRCGS Storage and Distribution',                          'food'),
    ('BRCGS Storage and Distribution',                          'trade_logistics'),
    ('BRCGS Agents and Brokers',                                'food'),
    ('BRCGS Agents and Brokers',                                'trade_logistics'),
    ('BRCGS Consumer Products',                                 'chemicals'),
    ('BRCGS Consumer Products',                                 'electrical'),
    ('BRCGS Consumer Products',                                 'other_manufacturing'),
    ('IFS Food',                                                'food'),
    ('IFS Logistics',                                           'food'),
    ('IFS Logistics',                                           'trade_logistics'),
    ('IFS Broker',                                              'food'),
    ('IFS Broker',                                              'trade_logistics'),
    ('IFS Wholesale',                                           'food'),
    ('IFS Wholesale',                                           'trade_logistics'),
    ('IFS HPC',                                                 'chemicals'),
    ('IFS PACsecure',                                           'wood_paper'),
    ('IFS PACsecure',                                           'rubber_plastics'),
    ('SQF',                                                     'food'),
    ('GMP+ FSA',                                                'food'),
    ('Friend of the Sea',                                       'agriculture'),
    ('Friend of the Sea',                                       'food'),
    ('LEAF Marque',                                             'agriculture'),
    ('ISO 22005',                                               'agriculture'),
    ('ISO 22005',                                               'food'),
    ('ISCC EU',                                                 'energy'),
    ('ISCC PLUS',                                               'energy'),
    ('ISCC PLUS',                                               'chemicals'),
    ('ISCC PLUS',                                               'rubber_plastics'),
    ('2BSvs',                                                   'energy'),
    ('PEFC Chain of Custody',                                   'agriculture'),
    ('PEFC Chain of Custody',                                   'wood_paper'),
    ('eIDAS',                                                   'ict'),
    ('Europrivacy',                                             'ict'),
    ('Europrivacy',                                             'professional'),
    ('ISO 3834',                                                'metals'),
    ('ISO 3834',                                                'machinery'),
    ('EN 15085-2',                                              'metals'),
    ('EN 15085-2',                                              'transport_equipment'),
    ('UNI CEI 11352',                                           'energy'),
    ('UNI CEI 11352',                                           'professional'),
    ('Construction Products Regulation (EU) 305/2011',          'construction'),
    ('Machinery Regulation (EU) 2023/1230',                     'machinery'),
    ('Machinery Directive 2006/42/EC',                          'machinery'),
    ('Lifts Directive 2014/33/EU',                              'machinery'),
    ('Lifts Directive 2014/33/EU',                              'construction'),
    ('Pressure Equipment Directive 2014/68/EU',                 'machinery'),
    ('Pressure Equipment Directive 2014/68/EU',                 'metals'),
    ('Simple Pressure Vessels Directive 2014/29/EU',            'machinery'),
    ('Simple Pressure Vessels Directive 2014/29/EU',            'metals'),
    ('ATEX Directive 2014/34/EU',                               'machinery'),
    ('ATEX Directive 2014/34/EU',                               'electrical'),
    ('EMC Directive 2014/30/EU',                                'electrical'),
    ('Radio Equipment Directive 2014/53/EU',                    'electrical'),
    ('Radio Equipment Directive 2014/53/EU',                    'ict'),
    ('Measuring Instruments Directive 2014/32/EU',              'electrical'),
    ('Measuring Instruments Directive 2014/32/EU',              'machinery'),
    ('Non-automatic Weighing Instruments Directive 2014/31/EU', 'electrical'),
    ('Non-automatic Weighing Instruments Directive 2014/31/EU', 'machinery'),
    ('Toy Safety Directive 2009/48/EC',                         'other_manufacturing'),
    ('Outdoor Noise Directive 2000/14/EC',                      'machinery'),
    ('Hot-water Boilers Directive 92/42/EEC',                   'machinery'),
    ('Hot-water Boilers Directive 92/42/EEC',                   'energy'),
    ('PPE Regulation (EU) 2016/425',                            'textiles'),
    ('PPE Regulation (EU) 2016/425',                            'other_manufacturing'),
    ('Gas Appliances Regulation (EU) 2016/426',                 'machinery'),
    ('Gas Appliances Regulation (EU) 2016/426',                 'energy'),
    ('Cableway Installations Regulation (EU) 2016/424',         'machinery'),
    ('Cableway Installations Regulation (EU) 2016/424',         'trade_logistics'),
    ('Rail Interoperability Directive (EU) 2016/797',           'transport_equipment'),
    ('Rail Interoperability Directive (EU) 2016/797',           'trade_logistics'),
    ('ECM Regulation (EU) 2019/779',                            'transport_equipment'),
    ('ECM Regulation (EU) 2019/779',                            'trade_logistics'),
    ('CSM Risk Assessment Regulation (EU) 402/2013',            'transport_equipment'),
    ('CSM Risk Assessment Regulation (EU) 402/2013',            'trade_logistics'),
    ('EU Geographical Indications (DOP/IGP/STG)',               'agriculture'),
    ('EU Geographical Indications (DOP/IGP/STG)',               'food'),
    ('EU Organic Regulation (EU) 2018/848',                     'agriculture'),
    ('EU Organic Regulation (EU) 2018/848',                     'food'),
    ('EU F-gas Regulation',                                     'machinery'),
    ('EU F-gas Regulation',                                     'professional')
) AS v (scheme_code, industry_code)
JOIN schemes s ON s.code = v.scheme_code;
