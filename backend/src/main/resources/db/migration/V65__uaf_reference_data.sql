-- Reference data for the UAF dataset (data/uaf-united-states): United Accreditation Foundation (United States).
-- Not imported: ISO 37001, ISO/IEC 42001, ISO 55001, ISO 20121 (listed on certificates without accreditation number
-- or dates, so no separate accreditation row can be built); "Safety Management Systems" (standard not named),
-- product certification and GHG verification (not ISO/IEC 17021-1). See data/uaf-united-states/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('UAF', 'United Accreditation Foundation', 'United States', 'https://www.uafaccreditation.org');
