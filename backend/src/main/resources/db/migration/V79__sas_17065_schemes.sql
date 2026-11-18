-- Schemes for the SAS (Switzerland) ISO/IEC 17065 dataset (data/sas-switzerland-17065). Bio Suisse Standard
-- (Knospe) is a private association standard cited by five SAS product bodies, so it gets a catalogue code.
-- Every other code the dataset uses already exists in V66-V72 (EU directives and regulations, ISO 3834, EN
-- 50126 / 50128 / 50129, IEC 61508, IEC 62443, ISO 26262, Common Criteria, ECM, Rail, CPR, organic regulation).
-- Swiss national ordinances (Bio-Verordnung SR 910.18, NEV SR 734.26, BauPG, Swiss AOP/IGP lists, Swiss
-- Safety Center modules) and single-body EU directives (Low Voltage 2014/35/EU) stay as line text.
INSERT INTO schemes (code, owner, kind) VALUES
    ('Bio Suisse Standard', 'Bio Suisse', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Bio Suisse Standard', 'agriculture'),
    ('Bio Suisse Standard', 'food')
ON CONFLICT DO NOTHING;
