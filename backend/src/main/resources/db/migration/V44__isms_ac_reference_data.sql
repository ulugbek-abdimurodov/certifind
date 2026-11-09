-- Reference data for the ISMS-AC dataset (data/isms-ac-japan): Information Management System Accreditation Center.
-- Deliberately not added: ISO/IEC 27017 cloud add-on registrations and persons certification (ISO/IEC 17024).
-- Bodies without an ISO/IEC 17021-1 accreditation from JAB were left out; see data/isms-ac-japan/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('ISMS-AC', 'Information Management System Accreditation Center', 'Japan', 'https://isms.jp/english/');
