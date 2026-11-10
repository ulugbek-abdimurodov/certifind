-- Reference data for the INN dataset (data/inn-chile): Chile's national accreditation body.
-- Deliberately not added: NCh 2728 (training providers), NCh 3262 (gender equality), CERTFOR-Chile
-- forestry - Chilean national schemes; HACCP (not in standards table); ICONTEC, IRAM and LSQA
-- (only those schemes). See data/inn-chile/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('INN', 'Instituto Nacional de Normalización', 'Chile', 'https://www.inn.cl');
