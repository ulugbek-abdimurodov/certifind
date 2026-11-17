-- Reference data for the BATA ISO/IEC 17065 dataset (data/bata-bosnia-17065): the accreditation body of
-- Bosnia and Herzegovina. Its product certification lines use no catalogue scheme.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('BATA', 'Institute for Accreditation of Bosnia and Herzegovina (BATA)', 'Bosnia and Herzegovina', 'http://bata.gov.ba')
ON CONFLICT DO NOTHING;
