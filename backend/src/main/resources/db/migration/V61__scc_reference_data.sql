-- Reference data for the SCC dataset (data/scc-canada): the Canadian accreditation body.
-- Not imported: CyberSecure Canada (CAN/CIOSC 104, CAN/DGSI 104), the forestry schemes
-- (SFI 2022, PEFC Canada, ATFS) - national schemes; AS9120 - not in the standards table.
-- Five bodies have no ISO/IEC 17021-1 scope left and are dropped. See data/scc-canada/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('SCC', 'Standards Council of Canada', 'Canada', 'https://scc-ccn.ca');
