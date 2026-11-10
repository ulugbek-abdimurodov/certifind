-- Reference data for the SLAB dataset (data/slab-sri-lanka): the Sri Lanka Accreditation Board for
-- Conformity Assessment, ISO/IEC 17021-1 management system certification bodies.
-- All accredited standards (ISO 9001, 14001, 45001, 22000, 50001, ISO/IEC 27001) are already in the
-- standards table. Left out: HACCP against the national standard SLS 1266; see SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('SLAB', 'Sri Lanka Accreditation Board for Conformity Assessment', 'Sri Lanka', 'https://www.slab.lk');
