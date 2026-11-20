-- Schemes for the SAE (Ecuador) ISO/IEC 17065 dataset (data/sae-ecuador-17065). Both are private international
-- schemes cited by two or more bodies across the 17065 datasets:
--   Best Aquaculture Practices (Global Seafood Alliance): SAE CP 07-001, ANAB and NABCB product accreditations.
--   Florverde Sustainable Flowers (Asocolflores): SAE CP 07-001, 14-001, 22-002, 25-003, ANAB and ONAC lines.
-- FlorEcuador, Punto Verde, Producción más Limpia and Ecuadorian organic production are national: text only.
INSERT INTO schemes (code, owner, kind) VALUES
    ('Best Aquaculture Practices', 'Global Seafood Alliance', 'PRIVATE'),
    ('Florverde Sustainable Flowers', 'Asocolflores', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Best Aquaculture Practices', 'agriculture'),
    ('Best Aquaculture Practices', 'food'),
    ('Florverde Sustainable Flowers', 'agriculture')
ON CONFLICT DO NOTHING;
