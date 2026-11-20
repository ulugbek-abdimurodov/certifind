-- Reference data for the Japanese ISO/IEC 17065 datasets data/iajapan-japan-17065 and data/maff-japan-17065.
-- IAJapan (NITE, ASNITE programme) and MAFF (registration of JAS / organic JAS certification bodies) have no
-- management system dataset, so the AB rows are inserted here.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('IAJapan', 'International Accreditation Japan (NITE)', 'Japan', 'https://www.nite.go.jp/en/iajapan/'),
    ('MAFF', 'Ministry of Agriculture, Forestry and Fisheries (JAS registered certifying bodies)', 'Japan',
     'https://www.maff.go.jp/e/policies/standard/')
ON CONFLICT DO NOTHING;

-- Private / international schemes cited by two or more bodies across the 17065 datasets:
--   Textile Exchange standards (GRS 15 bodies, RCS 23, CCS, OCS 11; ANAB, IOAS, SLAB, JASANZ, ONAC, ... and IAJapan)
--   IECEx Certified Equipment Scheme (CAI, DAkkS, HAA, JSM, SAS and IAJapan)
--   OIML-CS (DANAK, RvA, SAS and IAJapan)
-- Eco Mark (Japan Environment Association) and the PKS certification system are national: text only.
INSERT INTO schemes (code, owner, kind) VALUES
    ('Global Recycled Standard', 'Textile Exchange', 'PRIVATE'),
    ('Recycled Claim Standard', 'Textile Exchange', 'PRIVATE'),
    ('Content Claim Standard', 'Textile Exchange', 'PRIVATE'),
    ('Organic Content Standard', 'Textile Exchange', 'PRIVATE'),
    ('IECEx Certified Equipment Scheme', 'IECEx (IEC)', 'PRIVATE'),
    ('OIML-CS', 'OIML', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Global Recycled Standard', 'textiles'),
    ('Global Recycled Standard', 'rubber_plastics'),
    ('Recycled Claim Standard', 'textiles'),
    ('Recycled Claim Standard', 'rubber_plastics'),
    ('Content Claim Standard', 'textiles'),
    ('Organic Content Standard', 'textiles'),
    ('Organic Content Standard', 'agriculture'),
    ('IECEx Certified Equipment Scheme', 'electrical'),
    ('IECEx Certified Equipment Scheme', 'machinery'),
    ('OIML-CS', 'electrical')
ON CONFLICT DO NOTHING;
