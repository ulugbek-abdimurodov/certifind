-- Scheme for the EMA (Mexico) ISO/IEC 17065 dataset (data/ema-mexico-17065).
-- PrimusGFS (GFSI-benchmarked food safety scheme owned by Azzule Systems): EMA accreditations PRIMUS-164/20 and
-- PRIMUS-243/25, and 12 ANAB product accreditations (data/anab-usa-17065) cite it.
INSERT INTO schemes (code, owner, kind) VALUES
    ('PrimusGFS', 'Azzule Systems', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('PrimusGFS', 'agriculture'),
    ('PrimusGFS', 'food')
ON CONFLICT DO NOTHING;
