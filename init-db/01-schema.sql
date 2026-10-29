-- CertiFind canonical PostgreSQL schema.
-- Organizations from every accreditation body share the same company and
-- accredited_scopes tables. A scope row represents one standard and one EA
-- sector; ea_code is nullable for schemes that do not use EA sectors.

CREATE TABLE IF NOT EXISTS accreditation_bodies (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(50) NOT NULL UNIQUE,
    name        VARCHAR(255) NOT NULL,
    country     VARCHAR(100) NOT NULL,
    is_iaf_mla  BOOLEAN NOT NULL DEFAULT TRUE,
    website     VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS ea_sector (
    code     INTEGER PRIMARY KEY CHECK (code BETWEEN 1 AND 39),
    name_en  VARCHAR(200) NOT NULL,
    name_it  VARCHAR(200)
);
-- Legacy volumes predate name_it; add it before 02-seed.sql upserts the names.
ALTER TABLE ea_sector ADD COLUMN IF NOT EXISTS name_it VARCHAR(200);

CREATE TABLE IF NOT EXISTS iso_standard (
    code        VARCHAR(50) PRIMARY KEY,
    kind        VARCHAR(20) NOT NULL CHECK (kind IN ('ACCREDITATION', 'CERTIFICATION')),
    scheme      VARCHAR(30) NOT NULL CHECK (scheme IN (
                    'MANAGEMENT_SYSTEM', 'PRODUCT', 'PERSONNEL', 'LABORATORY',
                    'MEDICAL_LABORATORY', 'INSPECTION'
                ))
);

CREATE TABLE IF NOT EXISTS ateco_ea_mapping (
    id              SERIAL PRIMARY KEY,
    ateco_code      VARCHAR(20),
    description     TEXT NOT NULL,
    ea_code         INTEGER NOT NULL,
    ea_description  VARCHAR(255) NOT NULL,
    CONSTRAINT fk_ateco_ea_sector FOREIGN KEY (ea_code) REFERENCES ea_sector(code)
);

CREATE UNIQUE INDEX IF NOT EXISTS uq_ateco_ea_description
    ON ateco_ea_mapping (COALESCE(ateco_code, ''), ea_code, description);

CREATE TABLE IF NOT EXISTS certification_bodies (
    id                    SERIAL PRIMARY KEY,
    name                  VARCHAR(255) NOT NULL UNIQUE,
    country               VARCHAR(100) NOT NULL,
    accreditation_body_id INTEGER NOT NULL REFERENCES accreditation_bodies(id) ON DELETE RESTRICT,
    phone                 VARCHAR(50),
    email                 VARCHAR(100),
    website               VARCHAR(255),
    address               TEXT
);

CREATE INDEX IF NOT EXISTS idx_cb_accreditation_body
    ON certification_bodies (accreditation_body_id);

CREATE TABLE IF NOT EXISTS accredited_scopes (
    id                    SERIAL PRIMARY KEY,
    certification_body_id INTEGER NOT NULL REFERENCES certification_bodies(id) ON DELETE CASCADE,
    iso_standard          VARCHAR(50) NOT NULL,
    ea_code               INTEGER,
    scope_section         TEXT,
    status                VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    accreditation_date    DATE,
    expiration_date       DATE,
    proof_url             TEXT,
    CONSTRAINT fk_scope_standard FOREIGN KEY (iso_standard) REFERENCES iso_standard(code) ON DELETE RESTRICT,
    CONSTRAINT fk_scope_ea_sector FOREIGN KEY (ea_code) REFERENCES ea_sector(code) ON DELETE RESTRICT,
    CONSTRAINT ck_scope_status CHECK (status IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN', 'EXPIRED')),
    CONSTRAINT uq_cb_standard_ea UNIQUE (certification_body_id, iso_standard, ea_code),
    CONSTRAINT ck_scope_dates CHECK (
        accreditation_date IS NULL OR expiration_date IS NULL OR expiration_date >= accreditation_date
    )
);

ALTER TABLE accredited_scopes ADD COLUMN IF NOT EXISTS accreditation_date DATE;
ALTER TABLE accredited_scopes ADD COLUMN IF NOT EXISTS expiration_date DATE;

-- PostgreSQL UNIQUE constraints treat NULL values as distinct, so product or
-- other non-EA scopes use a separate uniqueness rule.
CREATE UNIQUE INDEX IF NOT EXISTS uq_product_scopes_body_standard
    ON accredited_scopes (certification_body_id, iso_standard)
    WHERE ea_code IS NULL;

-- Match the backend's ISO + EA + status search and company detail lookups.
CREATE INDEX IF NOT EXISTS idx_scopes_search
    ON accredited_scopes (iso_standard, status, ea_code);
CREATE INDEX IF NOT EXISTS idx_scopes_by_company
    ON accredited_scopes (certification_body_id, ea_code, iso_standard);
CREATE INDEX IF NOT EXISTS idx_ateco_mapping_code
    ON ateco_ea_mapping (ateco_code)
    WHERE ateco_code IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_ateco_mapping_ea
    ON ateco_ea_mapping (ea_code);
