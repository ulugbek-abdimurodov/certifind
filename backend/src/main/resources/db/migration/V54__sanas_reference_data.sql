-- Reference data for the SANAS dataset (data/sanas-south-africa): the South African accreditation body.
-- Deliberately not added: HACCP (SANS 10330), SANS 1395-1 RTMS (national schemes), RBI/RIMAP,
-- ISO 55001 (single facility, no sector schedule); ISO/IEC 17065, 17024 and 14065 accreditations are
-- out of scope. See data/sanas-south-africa/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('SANAS', 'South African National Accreditation System', 'South Africa', 'https://www.sanas.co.za');
