-- Reference data for the JASANZ dataset (data/jasanz-australia): Joint Accreditation System of Australia and New Zealand.
-- Deliberately not added: national schemes (NDIS, HSQF, CodeMark, WaterMark, ANZEx, Toitu, Recognised Agency, organics, halal...),
-- product, personnel and private food/farm schemes (SQF, GLOBALG.A.P., BRCGS, IFS, Freshcare, FAMI-QS, PEFC/Responsible Wood CoC, SERI R2);
-- see data/jasanz-australia/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('JASANZ', 'Joint Accreditation System of Australia and New Zealand', 'Australia', 'https://www.jasanz.org');
