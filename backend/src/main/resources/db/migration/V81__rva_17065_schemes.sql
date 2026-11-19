-- Schemes for the RvA (Netherlands) ISO/IEC 17065 dataset (data/rva-netherlands-17065). Two EU regulations with
-- notified-body conformity assessment are cited by several RvA product bodies and were missing from V69:
--   Cyber Resilience Act, Regulation (EU) 2024/2847  - C001, C646, C648, C651, C702
--   Artificial Intelligence Act, Regulation (EU) 2024/1689 - C001, C646
-- Every other code the dataset uses already exists. Dutch national schemes (BRL / KOMO, CCV, NCS, SKH, Kiwa K
-- product certificates, IKB, Holland Varken Quality, Maatlat Duurzame Veehouderij, Fertigarant, Bouwbesluit,
-- Regeling) and single-body private marks (DEKRA Mark, KEMA-KEUR, KAT) stay as line text with an industry.
INSERT INTO schemes (code, owner, kind) VALUES
    ('Cyber Resilience Act (EU) 2024/2847', 'European Union', 'EU_REGULATION'),
    ('AI Act (EU) 2024/1689', 'European Union', 'EU_REGULATION')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Cyber Resilience Act (EU) 2024/2847', 'ict'),
    ('Cyber Resilience Act (EU) 2024/2847', 'electrical'),
    ('AI Act (EU) 2024/1689', 'ict')
ON CONFLICT DO NOTHING;
