-- Service and recycling schemes for the ACCREDIA ISO/IEC 17065 dataset, so that tourism,
-- education, health and professional services have schemes to suggest in the search form.
-- Several are Italian UNI standards, kept as product datasets include every line.
-- A body holds many lines; each line keeps its own scheme, sector and product text.
INSERT INTO schemes (code, owner, kind) VALUES
    ('ISO 29993',                    'ISO',                                     'STANDARD'),
    ('ISO 13009',                    'ISO',                                     'STANDARD'),
    ('UNI 11911',                    'UNI',                                     'STANDARD'),
    ('UNI/PdR 131',                  'UNI',                                     'STANDARD'),
    ('GSTC Criteria',                'Global Sustainable Tourism Council',      'PRIVATE'),
    ('Breast Centres Certification', NULL,                                      'PRIVATE'),
    ('UNI/PdR 88',                   'UNI',                                     'STANDARD'),
    ('Plastica Seconda Vita',        'IPPR',                                    'PRIVATE'),
    ('ReMade in Italy',              'ReMade in Italy',                         'PRIVATE'),
    ('ISO 18295',                    'ISO',                                     'STANDARD'),
    ('ISO 22222',                    'ISO',                                     'STANDARD'),
    ('UNI 10891',                    'UNI',                                     'STANDARD'),
    ('UNI 11926',                    'UNI',                                     'STANDARD')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('ISO 29993',                    'public_education'),
    ('ISO 29993',                    'professional'),
    ('ISO 13009',                    'tourism'),
    ('UNI 11911',                    'tourism'),
    ('UNI/PdR 131',                  'tourism'),
    ('UNI/PdR 131',                  'health'),
    ('GSTC Criteria',                'tourism'),
    ('Breast Centres Certification', 'health'),
    ('UNI/PdR 88',                   'other_manufacturing'),
    ('UNI/PdR 88',                   'rubber_plastics'),
    ('Plastica Seconda Vita',        'rubber_plastics'),
    ('ReMade in Italy',              'other_manufacturing'),
    ('ISO 18295',                    'professional'),
    ('ISO 22222',                    'professional'),
    ('UNI 10891',                    'professional'),
    ('UNI 11926',                    'professional')
ON CONFLICT DO NOTHING;
