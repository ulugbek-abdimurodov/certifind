-- Reference data for the OUA dataset (data/oua-uruguay): the Uruguayan accreditation body.
-- Deliberately not added: forestry schemes (PEFC Uruguay / UNIT 1152, IRAM 39801 - national schemes),
-- LSQA S.A. (accreditation suspended). See data/oua-uruguay/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('OUA', 'Organismo Uruguayo de Acreditación', 'Uruguay', 'https://www.organismouruguayodeacreditacion.org');
