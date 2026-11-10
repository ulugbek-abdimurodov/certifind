-- Reference data for the SAE dataset (data/sae-ecuador): the Ecuadorian accreditation body.
-- Not imported: HACCP (Codex) - not in the standards table; persons (ISO/IEC 17024) and product
-- (ISO/IEC 17065) certification. AENOR CONFÍA and LENOR (Argentina) hold only ISO 37001 with SAE
-- and have no ISO/IEC 17021-1 row, so they are dropped. See data/sae-ecuador/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('SAE', 'Ecuadorian Accreditation Service (Servicio de Acreditación Ecuatoriano)', 'Ecuador', 'https://www.acreditacion.gob.ec');
