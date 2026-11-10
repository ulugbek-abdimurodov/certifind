-- Reference data for the EMA dataset (data/ema-mexico): the Mexican accreditation body.
-- Not imported: EMA scheme codes with no published name that cannot be matched to a standard in the
-- standards table (SGAC, SGBG, SGCD, SGES, SGOS, SGPG, SGPI, SGRH, SMSC); non-17021-1 programmes.
-- FWC Certificación en la Industria de Alimentos (ISO 22000 only) has no ISO/IEC 17021-1 scope and is dropped.
-- See data/ema-mexico/SOURCES.md.

INSERT INTO accreditation_bodies (code, name, country, website) VALUES
('EMA', 'Entidad Mexicana de Acreditación, A.C.', 'Mexico', 'https://www.ema.org.mx');
