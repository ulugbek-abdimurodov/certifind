-- ACCREDIA (Italy) ISO/IEC 17065 product certification: schemes missing from the V66 catalogue.
-- Dataset: data/accredia-italy-17065 (the accreditation body ACCREDIA already exists from V2).
--
-- Added: international schemes found at two or more ACCREDIA 17065 bodies.
-- Left out of the dataset (not catalogued, lines not imported):
--   * EU directive / notified-body work: CSAAR annexes (Machinery, Lifts, PED, ATEX, EMC, RED, PPE, gas
--     appliances, toys, measuring instruments, rail interoperability, ECM / CSM) and CSACPR annexes
--     (Construction Products Regulation (EU) 305/2011 AVCP).
--   * Schemes designated by the Italian authorities: DOP/IGP/STG control (Reg. (EU) 2024/1143), organic control
--     (Reg. (EU) 2018/848), F-gas company and training certification (DPR 146/2018).
--   * Italian national schemes: UNI/PdR practices, ESCO (UNI CEI 11352), National Quality System for Animal
--     Welfare, SQNPI / UNI 11233 integrated production, national biofuel sustainability system, REMADE,
--     private security institutes (UNI 10891 / DM 269/2010), beach establishments (UNI 11911), UNI 11926,
--     tax-credit technical analyses (Legge di bilancio 2017).
-- Kept without a catalogued scheme (one body only): COSMOS, Interprivacy, and other proprietary schemes.

INSERT INTO schemes (code, owner, kind) VALUES
    ('GLOBALG.A.P. Chain of Custody', 'FoodPLUS GmbH',                         'PRIVATE'),
    ('BRCGS Consumer Products',       'BRCGS',                                 'PRIVATE'),
    ('IFS Wholesale',                 'IFS Management GmbH',                   'PRIVATE'),
    ('Friend of the Sea',             'World Sustainability Organization',     'PRIVATE'),
    ('LEAF Marque',                   'LEAF (Linking Environment and Farming)', 'PRIVATE'),
    ('ISO 22005',                     'ISO',                                   'STANDARD'),
    ('ISO 3834',                      'ISO',                                   'STANDARD'),
    ('EN 15085-2',                    'CEN',                                   'STANDARD')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('GLOBALG.A.P. Chain of Custody', 'agriculture'),
    ('GLOBALG.A.P. Chain of Custody', 'food'),
    ('BRCGS Consumer Products',       'chemicals'),
    ('BRCGS Consumer Products',       'electrical'),
    ('IFS Wholesale',                 'food'),
    ('IFS Wholesale',                 'transport'),
    ('Friend of the Sea',             'agriculture'),
    ('Friend of the Sea',             'food'),
    ('LEAF Marque',                   'agriculture'),
    ('ISO 22005',                     'food'),
    ('ISO 22005',                     'agriculture'),
    ('ISO 3834',                      'machinery'),
    ('EN 15085-2',                    'transport'),
    ('EN 15085-2',                    'machinery')
ON CONFLICT DO NOTHING;
