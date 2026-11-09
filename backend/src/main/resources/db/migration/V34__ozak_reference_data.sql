-- Reference data for the O'ZAK dataset (data/ozak-uzbekistan): the Uzbek national accreditation body
-- (register akkred.uz, ISO/IEC 17021-1 management system certification bodies).
-- All accredited standards (ISO 9001, 14001, 45001, 22000, 50001, 13485, 37001, ISO/IEC 27001) are
-- already in the standards table. Left out: register entries without a scope annex (O'ZAK.MT.0025,
-- 0037, 0043, 0044), and withdrawn, expired or suspended bodies; see data/ozak-uzbekistan/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('OZAK', 'Uzbekistan Accreditation Centre (O''zbekiston akkreditatsiya markazi, O''ZAK)', 'Uzbekistan', 'https://akkred.uz');
