-- Reference data for the ANAB dataset (data/anab-usa): the US accreditation body.
-- Not imported: AS9110, AS9120, AS6081, TL 9000, SN 9001, FAMI-QS (not in the standards table);
-- RC14001, BA 9000, SFI, ATFS, Leading Harvest (US / North American national schemes); R2, RIOS (recycling sector schemes).
-- Bodies without an ISO/IEC 17021-1 scope (ISO/IEC 27001 / 42001 / food-only CBs) are dropped. See data/anab-usa/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('ANAB', 'ANSI National Accreditation Board', 'United States', 'https://anab.ansi.org');
