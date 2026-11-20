-- GOTS and Halal, cited by 19 and 6 product certification bodies across the 17065 datasets (ANAB, COFRAC, DAkkS,
-- IOAS, IPAC, NABCB, RvA, SLAB; ANAB, JASANZ, JSM, NABCB). Halal is one code for halal product certification
-- whatever the halal standard (MS 1500, GSO 2055-1, OIC/SMIIC 1, ...), which the line text keeps.
INSERT INTO schemes (code, owner, kind) VALUES
    ('GOTS', 'Global Standard gGmbH', 'PRIVATE'),
    ('Halal', 'Halal certification authorities', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('GOTS', 'textiles'),
    ('Halal', 'food'),
    ('Halal', 'chemicals')
ON CONFLICT DO NOTHING;
