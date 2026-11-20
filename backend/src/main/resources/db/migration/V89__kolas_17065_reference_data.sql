-- Reference data for the KOLAS (South Korea) ISO/IEC 17065 dataset (data/kolas-south-korea-17065).
-- KOLAS (Korea Laboratory Accreditation Scheme, run by KATS) accredits Korea's product certification bodies; KAB
-- (management systems) is already in the table. KOLAS has no management system dataset, so the AB row is here.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('KOLAS', 'Korea Laboratory Accreditation Scheme (KATS)', 'South Korea', 'https://www.knab.go.kr')
ON CONFLICT DO NOTHING;
