-- Reference data for the TUNAC ISO/IEC 17065 dataset (data/tunac-tunisia-17065).
-- The TUNAC row already exists from V12__tunac_reference_data.sql; repeated here so the dataset stands alone.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('TUNAC', 'Conseil National d''Accréditation (TUNAC)', 'Tunisia', 'https://www.tunac.tn')
ON CONFLICT DO NOTHING;

-- New scheme: EN 15343 recycled-plastics traceability (CTPC 3-0025; also cited by ACCREDIA and BELAC bodies).
-- Tunisian national schemes (organic farming law 99-30, quality label for processed foods) are imported as
-- text with an industry and no scheme code, per the national-scheme rule for product datasets.
INSERT INTO schemes (code, owner, kind) VALUES
    ('EN 15343', 'CEN', 'STANDARD')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('EN 15343', 'rubber_plastics')
ON CONFLICT DO NOTHING;
