-- Reference data for the NiNAS dataset (data/ninas-nigeria): the Nigerian national accreditation system.
-- Guarded: branches that already created NINAS (17065 work) must not fail on a duplicate.
-- Schedules list only ISO 9001/14001/45001, ISO/IEC 27001 and ISO 22000; no schemes were left out.

INSERT INTO accreditation_bodies (code, name, country, website)
SELECT 'NINAS', 'Nigerian National Accreditation System', 'Nigeria', 'https://ninas.ng'
WHERE NOT EXISTS (SELECT 1 FROM accreditation_bodies WHERE code = 'NINAS');
