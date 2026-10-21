-- ============================================================================
-- CertiFind Relational Schema (PostgreSQL 16 + pgvector)
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS vector;

-- 1. National/International Accreditation Authorities (IAF-MLA signatories)
CREATE TABLE IF NOT EXISTS accreditation_bodies (
    id          SERIAL       PRIMARY KEY,
    code        VARCHAR(50)  UNIQUE NOT NULL,
    name        VARCHAR(255) NOT NULL,
    country     VARCHAR(100) NOT NULL,
    is_iaf_mla  BOOLEAN      NOT NULL DEFAULT TRUE,
    website     VARCHAR(255)
);

ALTER TABLE accreditation_bodies DROP COLUMN IF EXISTS avg_daily_rate_eur;

COMMENT ON COLUMN accreditation_bodies.code       IS 'Short identifier, e.g. ACCREDIA, RENAR, PCA, DAkkS, UKAS.';
COMMENT ON COLUMN accreditation_bodies.is_iaf_mla IS 'TRUE when the body is an IAF/EA-MLA signatory.';

-- 2. Activity Sector & Optional ATECO Crosswalk
--    ea_code + ea_description + description (Activity Sector) are MANDATORY.
--    ateco_code is OPTIONAL (nullable) because searches and foreign CABs
--    can operate purely on ISO standard + Activity Sector (EA code).
CREATE TABLE IF NOT EXISTS ateco_ea_mapping (
    id              SERIAL       PRIMARY KEY,
    ateco_code      VARCHAR(20)  NULL,
    description     TEXT         NOT NULL,
    ea_code         INTEGER      NOT NULL,
    ea_description  VARCHAR(255) NOT NULL,
    CONSTRAINT uq_ateco_ea_desc UNIQUE (ateco_code, ea_code, description)
);

ALTER TABLE ateco_ea_mapping ALTER COLUMN ateco_code DROP NOT NULL;

CREATE INDEX IF NOT EXISTS idx_ateco_ea_ateco_code ON ateco_ea_mapping (ateco_code);
CREATE INDEX IF NOT EXISTS idx_ateco_ea_ea_code    ON ateco_ea_mapping (ea_code);

-- 3. Accredited Certification Bodies (CABs)
CREATE TABLE IF NOT EXISTS certification_bodies (
    id                    SERIAL       PRIMARY KEY,
    name                  VARCHAR(255) UNIQUE NOT NULL,
    country               VARCHAR(100) NOT NULL,
    accreditation_body_id INT          NOT NULL REFERENCES accreditation_bodies (id) ON DELETE CASCADE,
    has_italian_auditors  BOOLEAN      NOT NULL DEFAULT TRUE,
    is_commercial_partner BOOLEAN      NOT NULL DEFAULT FALSE,
    phone                 VARCHAR(50),
    email                 VARCHAR(100),
    website               VARCHAR(255),
    address               TEXT
);

ALTER TABLE certification_bodies DROP COLUMN IF EXISTS custom_daily_rate_eur;

CREATE INDEX IF NOT EXISTS idx_cb_accreditation_body ON certification_bodies (accreditation_body_id);
CREATE INDEX IF NOT EXISTS idx_cb_commercial_partner ON certification_bodies (is_commercial_partner);

-- 4. Accredited Scopes (Every CAB MUST have ISO Standard + EA Code + Activity Sector)
CREATE TABLE IF NOT EXISTS accredited_scopes (
    id                    SERIAL      PRIMARY KEY,
    certification_body_id INT         NOT NULL REFERENCES certification_bodies (id) ON DELETE CASCADE,
    iso_standard          VARCHAR(50) NOT NULL,
    ea_code               INTEGER     NOT NULL,
    scope_section         TEXT        NOT NULL,
    status                VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    proof_url             TEXT,
    CONSTRAINT uq_cb_standard_ea UNIQUE (certification_body_id, iso_standard, ea_code)
);

-- Ensure existing containers get the column and NOT NULL rule safely
ALTER TABLE accredited_scopes ADD COLUMN IF NOT EXISTS scope_section TEXT;

CREATE INDEX IF NOT EXISTS idx_scopes_standard_ea ON accredited_scopes (iso_standard, ea_code);
CREATE INDEX IF NOT EXISTS idx_scopes_cb_id       ON accredited_scopes (certification_body_id);
CREATE INDEX IF NOT EXISTS idx_scopes_status      ON accredited_scopes (status);