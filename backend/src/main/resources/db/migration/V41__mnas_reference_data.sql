-- Reference data for the MNAS dataset (data/mnas-mongolia): the Mongolian accreditation body.
-- Left out: MSC 02 SFCS LLC (invalid/expired), mnas.gov.mn national product-certification list,
-- an ISO 50001 accreditation not shown on any certificate. See data/mnas-mongolia/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('MNAS', 'National Accreditation Center of Mongolia', 'Mongolia', 'https://www.mnas.gov.mn');
