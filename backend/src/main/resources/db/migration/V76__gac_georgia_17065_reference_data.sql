-- Reference data for the GAC Georgia ISO/IEC 17065 dataset (data/gac-georgia-17065).
-- Georgia's accreditation body (Unified National Body of Accreditation - Accreditation Center, "GAC") gets the code
-- GAC-GE because GAC is already the GCC Accreditation Center (Saudi Arabia, data/gac-saudi-arabia).
-- No schemes added: the Georgian scopes are product groups under national technical regulations (text + industry).
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('GAC-GE', 'Unified National Body of Accreditation - Accreditation Center (GAC)', 'Georgia', 'https://gac.gov.ge')
ON CONFLICT DO NOTHING;
