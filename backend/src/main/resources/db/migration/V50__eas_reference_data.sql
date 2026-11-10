-- Reference data for the EAS dataset (data/eas-ethiopia): Ethiopian Accreditation Service.
-- Deliberately not added: ISO 21001 (EOMS0001) and ISO/IEC 17065 product certification
-- (CPr0001, CPr0002); see data/eas-ethiopia/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('EAS', 'Ethiopian Accreditation Service', 'Ethiopia', 'https://eas-eth.org');
