-- Reference data for the JAB dataset (data/jab-japan): Japan Accreditation Board.
-- Deliberately not added: AS 9120, TL 9000, JFS-C and J-OHSMS (national or not in the standards table),
-- and AMS (no codes listed); see data/jab-japan/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('JAB', 'Japan Accreditation Board', 'Japan', 'https://www.jab.or.jp');
