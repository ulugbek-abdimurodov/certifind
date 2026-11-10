-- Reference data for the ECA dataset (data/eca-costa-rica): Ente Costarricense de Acreditación.
-- Left out: INTE G38-3:2021 (national gender-equality scheme, not in standards) and
-- ISO 22000 / FSSC 22000 (voluntarily reduced from INTECO's scope). See data/eca-costa-rica/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('ECA', 'Ente Costarricense de Acreditación', 'Costa Rica', 'https://eca.or.cr');
