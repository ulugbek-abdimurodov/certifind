-- Reference data for the CAEQ (Québec, Canada) ISO/IEC 17065 dataset (data/caeq-canada-17065).
-- CAEQ accredits organic and Québec reserved-designation certification bodies only. It has no 17021-1
-- dataset, so the AB row is inserted here (ON CONFLICT DO NOTHING in case it is added elsewhere).
-- New schemes:
--   Canada Organic Regime (COR)          - Organic appellation + COR product categories (SFCR Part 13, CAN/CGSB-32.310/32.311)
--   Québec Reserved Designations (CARTV) - Québec PGIs / designations / added-value terms (Acerum, Quebec Ice Cider, Quebec Wine, ...)
-- EU Organic Regulation (EU) 2018/848 (EU-equivalence product categories (a)-(g)) already exists.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('CAEQ', 'Conseil des appellations réservées et des termes valorisants', 'Canada', 'https://caeq.ca')
ON CONFLICT DO NOTHING;

INSERT INTO schemes (code, owner, kind) VALUES
    ('Canada Organic Regime (COR)', 'Canadian Food Inspection Agency', 'STANDARD'),
    ('Québec Reserved Designations (CARTV)', 'CARTV (Gouvernement du Québec)', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Canada Organic Regime (COR)', 'agriculture'),
    ('Canada Organic Regime (COR)', 'food'),
    ('Québec Reserved Designations (CARTV)', 'food')
ON CONFLICT DO NOTHING;
