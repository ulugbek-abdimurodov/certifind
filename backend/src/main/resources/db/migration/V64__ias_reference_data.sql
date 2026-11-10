-- Reference data for the IAS dataset (data/ias-usa): International Accreditation Service (United States).
-- Not imported: ISO/IEC TS 17021-10 (not in the standards table). Suspended bodies and bodies without an
-- ISO/IEC 17021-1 scope (mostly ISO/IEC 27001-only CBs) are dropped. See data/ias-usa/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('IAS', 'International Accreditation Service', 'United States', 'https://www.iasonline.org');
