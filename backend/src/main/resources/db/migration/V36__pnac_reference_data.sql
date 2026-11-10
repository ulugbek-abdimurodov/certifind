-- Reference data for the PNAC dataset (data/pnac-pakistan): the Pakistan National Accreditation
-- Council, ISO/IEC 17021-1 management system certification bodies (scope documents CB 001 ... CB 014).
-- All accredited standards (ISO 9001, 14001, 45001, 22000, 13485) are already in the standards table.
-- Left out: the national GDPMD scheme (Good Distribution Practice for Medical Devices, Drug Regulatory
-- Authority of Pakistan) on CB 005's scope; see data/pnac-pakistan/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('PNAC', 'Pakistan National Accreditation Council (PNAC)', 'Pakistan', 'https://www.pnac.gov.pk');
