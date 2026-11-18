-- Reference data for the CYS-CYSAB ISO/IEC 17065 dataset (data/cysab-cyprus-17065).
-- The Cyprus accreditation body had no row yet. No new schemes: every code used by this dataset already exists in
-- V66-V72 (EU regulations, CEN Keymark, ISO 3834). Cyprus national schemes and single-body schemes stay as text.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('CYSAB', 'Cyprus Organization for the Promotion of Quality - Cyprus Accreditation Body (CYS-CYSAB)', 'Cyprus',
     'https://www.gov.cy/meci-cysab/')
ON CONFLICT DO NOTHING;
