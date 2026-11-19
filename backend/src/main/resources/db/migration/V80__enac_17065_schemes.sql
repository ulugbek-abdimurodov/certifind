-- Schemes for the ENAC (Spain) ISO/IEC 17065 dataset (data/enac-spain-17065). ENplus (wood pellet quality
-- certification, owned by the European Pellet Council) is cited by three product bodies across the 17065 datasets
-- (ENAC 01/C-PR038, AA 0923 and 0974), so it gets a catalogue code. Every other code the dataset uses already exists
-- (EU directives and regulations, GLOBALG.A.P., IFS, BRCGS, LEAF Marque, PEFC, eIDAS, EN 15343, Common Criteria...).
-- Spanish national schemes (Esquema Nacional de Seguridad, Real Decreto product controls, Código Estructural,
-- regional quality marks, R&D+i project certification) and single-body schemes stay as line text with an industry.
INSERT INTO schemes (code, owner, kind) VALUES
    ('ENplus', 'European Pellet Council', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('ENplus', 'energy')
ON CONFLICT DO NOTHING;
