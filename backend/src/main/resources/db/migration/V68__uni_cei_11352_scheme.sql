-- UNI CEI 11352 (energy service companies, ESCO) for the ACCREDIA ISO/IEC 17065 dataset.
-- An Italian national standard, kept on request as an exception to the national-scheme rule: ESCO
-- certification is searched for by Italian companies (D.Lgs. 102/2014, white certificates). 25 ACCREDIA bodies.
INSERT INTO schemes (code, owner, kind) VALUES
    ('UNI CEI 11352', 'UNI / CEI', 'STANDARD')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('UNI CEI 11352', 'energy'),
    ('UNI CEI 11352', 'services')
ON CONFLICT DO NOTHING;
