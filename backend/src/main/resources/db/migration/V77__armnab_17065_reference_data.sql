-- Reference data for the ARMNAB ISO/IEC 17065 dataset (data/armnab-armenia-17065): the Armenian
-- accreditation body. No new schemes: the Armenian scopes cite national documents (government decisions,
-- laws, GOST / AST standards), which the dataset keeps as text with an industry.
INSERT INTO accreditation_bodies (code, name, country, website) VALUES
    ('ARMNAB', 'Accreditation Body of the Republic of Armenia (ARMNAB)', 'Armenia', 'https://armnab.am')
ON CONFLICT DO NOTHING;
