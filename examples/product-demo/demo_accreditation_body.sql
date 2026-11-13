-- Fictitious accreditation body for the product certification demo dataset.
-- Development only: never run this against the production database.
INSERT INTO accreditation_bodies (code, name, country, website)
VALUES ('DEMO', 'Dati dimostrativi (non reali)', 'Italy', NULL)
ON CONFLICT (code) DO NOTHING;
