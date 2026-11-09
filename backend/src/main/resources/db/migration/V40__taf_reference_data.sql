-- Reference data for the TAF dataset (data/taf-taiwan): Taiwan Accreditation Foundation.
-- Every standard imported is already in the reference data. Deliberately left out: Taiwan national
-- schemes TOSHMS (Taiwan occupational safety and health MS) and the Cyber Security Management Act
-- scheme. See database/taiwan/taf_review.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('TAF', 'Taiwan Accreditation Foundation', 'Taiwan', 'https://www.taftw.org.tw');
