-- CertiFind database schema
-- PostgreSQL 16 + pgvector
-- Run automatically by Spring Boot (spring.sql.init.mode=always)
-- and on first Docker container start via docker-entrypoint-initdb.d

CREATE EXTENSION IF NOT EXISTS vector;


-- National/international accreditation authorities (e.g. ACCREDIA, RENAR, PCA).
CREATE TABLE IF NOT EXISTS accreditation_bodies (
    id                  SERIAL         PRIMARY KEY,
    code                VARCHAR(50)    UNIQUE NOT NULL,
    name                VARCHAR(255)   NOT NULL,
    country             VARCHAR(100)   NOT NULL,
    is_iaf_mla          BOOLEAN        NOT NULL DEFAULT TRUE,
    website             VARCHAR(255)
);

ALTER TABLE accreditation_bodies DROP COLUMN IF EXISTS avg_daily_rate_eur;

COMMENT ON COLUMN accreditation_bodies.code             IS 'Short identifier used throughout the app, e.g. ACCREDIA, RENAR, PCA.';
COMMENT ON COLUMN accreditation_bodies.is_iaf_mla       IS 'TRUE when the body is an IAF Multilateral Recognition Arrangement signatory.';


-- Cross-reference between Italian ATECO industry codes and EA sector codes.
-- Used to translate a company''s ATECO into the EA sectors it needs covered.
CREATE TABLE IF NOT EXISTS ateco_ea_mapping (
    id              SERIAL       PRIMARY KEY,
    ateco_code      VARCHAR(20)  NOT NULL,
    description     TEXT         NOT NULL,
    ea_code         INTEGER      NOT NULL,
    ea_description  VARCHAR(255) NOT NULL
);

COMMENT ON COLUMN ateco_ea_mapping.ateco_code IS 'Italian ATECO code, e.g. 88.91.00.';
COMMENT ON COLUMN ateco_ea_mapping.ea_code    IS 'Numeric EA sector code, e.g. 37 (Education).';

CREATE INDEX IF NOT EXISTS idx_ateco_ea_ateco_code ON ateco_ea_mapping (ateco_code);
CREATE INDEX IF NOT EXISTS idx_ateco_ea_ea_code    ON ateco_ea_mapping (ea_code);


-- Certification bodies accredited by one of the accreditation_bodies above.
CREATE TABLE IF NOT EXISTS certification_bodies (
    id                    SERIAL         PRIMARY KEY,
    name                  VARCHAR(255)   NOT NULL,
    country               VARCHAR(100)   NOT NULL,
    accreditation_body_id INT            REFERENCES accreditation_bodies (id) ON DELETE CASCADE,
    has_italian_auditors  BOOLEAN        NOT NULL DEFAULT TRUE,
    is_commercial_partner BOOLEAN        NOT NULL DEFAULT FALSE,
    phone                 VARCHAR(50),
    email                 VARCHAR(100),
    website               VARCHAR(255),
    address               TEXT
);

ALTER TABLE certification_bodies DROP COLUMN IF EXISTS custom_daily_rate_eur;

COMMENT ON COLUMN certification_bodies.is_commercial_partner IS 'TRUE when this CB has a commercial agreement with CertiFind.';

CREATE INDEX IF NOT EXISTS idx_cb_accreditation_body ON certification_bodies (accreditation_body_id);
CREATE INDEX IF NOT EXISTS idx_cb_commercial_partner ON certification_bodies (is_commercial_partner);


-- One row per (certification body, ISO standard, EA sector) accreditation scope.
-- status lifecycle: ACTIVE → SUSPENDED → WITHDRAWN
CREATE TABLE IF NOT EXISTS accredited_scopes (
    id                    SERIAL      PRIMARY KEY,
    certification_body_id INT         NOT NULL REFERENCES certification_bodies (id) ON DELETE CASCADE,
    iso_standard          VARCHAR(50) NOT NULL,
    ea_code               INTEGER     NOT NULL,
    status                VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    proof_url             TEXT
);

COMMENT ON COLUMN accredited_scopes.iso_standard IS 'ISO standard covered, e.g. ISO 9001, ISO 14001.';
COMMENT ON COLUMN accredited_scopes.ea_code      IS 'EA sector code covered by this scope.';
COMMENT ON COLUMN accredited_scopes.status       IS 'ACTIVE, SUSPENDED, or WITHDRAWN.';
COMMENT ON COLUMN accredited_scopes.proof_url    IS 'Link to the official accreditation certificate or directory entry.';

-- Hot query path: "find all CBs accredited for standard X in EA sector Y"
CREATE INDEX IF NOT EXISTS idx_scopes_standard_ea ON accredited_scopes (iso_standard, ea_code);
CREATE INDEX IF NOT EXISTS idx_scopes_cb_id       ON accredited_scopes (certification_body_id);
CREATE INDEX IF NOT EXISTS idx_scopes_status      ON accredited_scopes (status);
