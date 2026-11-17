-- Schemes for the DAkkS ISO/IEC 17065 dataset (data/dakks-germany-17065), each held by two or more
-- DAkkS bodies. German national schemes (QS, KAT, Ü-Zeichen / DIBt approvals, VDE-AR-N grid
-- connection, BSI TR, AZAV, Präqualifikation) are kept as line text without a scheme.
INSERT INTO schemes (code, owner, kind) VALUES
    ('FSC Chain of Custody',            'Forest Stewardship Council',  'PRIVATE'),
    ('MSC Chain of Custody',            'Marine Stewardship Council',  'PRIVATE'),
    ('Common Criteria (ISO/IEC 15408)', 'ISO/IEC',                     'STANDARD'),
    ('IEC 62443',                       'IEC',                         'STANDARD'),
    ('IEC 61508',                       'IEC',                         'STANDARD'),
    ('ISO 26262',                       'ISO',                         'STANDARD'),
    ('EN 50126 / 50128 / 50129',        'CENELEC',                     'STANDARD'),
    ('IEC 61400-22 / IECRE',            'IEC',                         'STANDARD'),
    ('IEC 61215 / IEC 61730',           'IEC',                         'STANDARD'),
    ('CEN Keymark',                     'CEN / CENELEC',               'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('FSC Chain of Custody',            'agriculture'),
    ('FSC Chain of Custody',            'wood_paper'),
    ('MSC Chain of Custody',            'agriculture'),
    ('MSC Chain of Custody',            'food'),
    ('Common Criteria (ISO/IEC 15408)', 'ict'),
    ('IEC 62443',                       'ict'),
    ('IEC 62443',                       'electrical'),
    ('IEC 61508',                       'electrical'),
    ('IEC 61508',                       'machinery'),
    ('ISO 26262',                       'transport_equipment'),
    ('ISO 26262',                       'electrical'),
    ('EN 50126 / 50128 / 50129',        'transport_equipment'),
    ('EN 50126 / 50128 / 50129',        'electrical'),
    ('IEC 61400-22 / IECRE',            'energy'),
    ('IEC 61400-22 / IECRE',            'machinery'),
    ('IEC 61215 / IEC 61730',           'energy'),
    ('IEC 61215 / IEC 61730',           'electrical'),
    ('CEN Keymark',                     'construction'),
    ('CEN Keymark',                     'machinery'),
    ('CEN Keymark',                     'energy')
ON CONFLICT DO NOTHING;
