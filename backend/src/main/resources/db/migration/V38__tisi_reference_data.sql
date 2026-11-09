-- Reference data for the TISI dataset (data/tisi-thailand): the Thai Industrial Standards Institute,
-- Office of the National Standardization Council, ISO/IEC 17021-1 management system certification bodies.
-- All accredited standards (ISO 9001, 14001, 45001, 50001) are already in the standards table.
-- Left out: SFMS (not in the standards table), GHG, Thai Labour Standard TLS 8001 (national scheme),
-- product, personnel and tourism schemes; see SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('TISI', 'Thai Industrial Standards Institute (Office of the National Standardization Council)', 'Thailand', 'https://www.tisi.go.th');
