-- Reference data for the A2LA (data/a2la-usa-17065) and IOAS (data/ioas-usa-17065) ISO/IEC 17065 datasets.
-- Neither AB has a 17021-1 dataset, so the AB rows are inserted here (ON CONFLICT DO NOTHING in case
-- one is added elsewhere). Every scheme both datasets cite is already in the schemes table.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('A2LA', 'American Association for Laboratory Accreditation', 'United States', 'https://a2la.org'),
    ('IOAS', 'International Organic and Sustainable Accreditation', 'United States', 'https://ioas.org')
ON CONFLICT DO NOTHING;
