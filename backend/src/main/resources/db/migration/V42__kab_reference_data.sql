-- Reference data for the KAB dataset (data/kab-south-korea): the South Korean accreditation body.
-- Left out: TL 9000 (not in the standards table). KS Q 9100 is imported as AS 9100.
-- See data/kab-south-korea/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('KAB', 'Korea Accreditation Board', 'South Korea', 'https://eng.kab.or.kr');
