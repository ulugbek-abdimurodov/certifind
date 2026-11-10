-- Reference data for the GAC dataset (data/gac-saudi-arabia): GCC Accreditation Center, the accreditation body of the
-- Gulf Cooperation Council states (register hosted at gac.org.sa).
-- Deliberately not added: the GPCA plastic pellets/flakes/powders scheme (MSC 0015 DNV Dubai, MSC 0016 FAHSS), which is
-- not in the standards table; see data/gac-saudi-arabia/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('GAC', 'GCC Accreditation Center', 'Saudi Arabia', 'https://gac.org.sa');
