-- Reference data for the JSM dataset (data/jsm-malaysia): Department of Standards Malaysia.
-- Every standard its schedules accredit is already in the reference data. Malaysian national
-- schemes (MSPO / MSPO supply chain, HACCP MS 1480, GMP MS 1514, forest management MC&I / MTCS,
-- PEFC chain of custody), ISO 21101 adventure tourism (ATSMS), FAMI-QS, product certification
-- (ISO/IEC 17065) and certification of persons (ISO/IEC 17024) are deliberately not added; the
-- dataset leaves them out. See database/malaysia/jsm_review.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('JSM', 'Department of Standards Malaysia (Jabatan Standard Malaysia)', 'Malaysia', 'https://www.jsm.gov.my');
