-- Reference data for the KENAS dataset (data/kenas-kenya): the Kenya Accreditation Service.
-- Left out: SANS 10330 HACCP (South African national scheme), SafeCare health facility
-- standards (PharmAccess Foundation), and product (ISO/IEC 17065) and personnel
-- (ISO/IEC 17024) certification. See data/kenas-kenya/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('KENAS', 'Kenya Accreditation Service', 'Kenya', 'https://kenas.go.ke');
