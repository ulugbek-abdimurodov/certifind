-- Reference data for the SAAC dataset (data/saac-saudi-arabia): Saudi Accreditation Center, the national
-- accreditation body of Saudi Arabia (register at saac.gov.sa).
-- Deliberately not added: nothing; the "Management Systems Certificates" service lists only schemes already in the
-- standards table (ISO 9001, 14001, 45001, 22000, 50001, 13485, ISO/IEC 27001, ISO 22301). Cancelled and expired
-- registrations are not imported; see data/saac-saudi-arabia/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('SAAC', 'Saudi Accreditation Center', 'Saudi Arabia', 'https://saac.gov.sa');
