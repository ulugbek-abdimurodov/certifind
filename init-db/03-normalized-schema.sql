-- =====================================================================
-- V1__init_schema.sql  |  PostgreSQL 15+  |  Flyway migration
-- Accredited Certification Body Finder
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS pg_trgm;     -- fuzzy search on CB names
CREATE EXTENSION IF NOT EXISTS unaccent;    -- accent-insensitive search

-- ---------------------------------------------------------------------
-- 1. REFERENCE DATA
-- ---------------------------------------------------------------------

-- National Accreditation Bodies (one per country)
CREATE TABLE country (
    id            SMALLSERIAL PRIMARY KEY,
    iso_code      CHAR(2)      NOT NULL UNIQUE,          -- 'IT', 'AL', 'DE'
    name          VARCHAR(100) NOT NULL,
    nab_name      VARCHAR(200) NOT NULL,                 -- e.g. 'ACCREDIA'
    nab_website   VARCHAR(300),
    is_ea_member  BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- All standards live here, split by role:
--   ACCREDITATION = standard the CB is accredited AGAINST (ISO/IEC 17021-1, 17065, 17024, 17025...)
--   CERTIFICATION = standard the CB certifies TO (ISO 9001, 14001, 45001, 27001...)
CREATE TABLE standard (
    id          SMALLSERIAL PRIMARY KEY,
    code        VARCHAR(50)  NOT NULL UNIQUE,            -- 'ISO 9001', 'ISO/IEC 17021-1'
    title       VARCHAR(300),
    kind        VARCHAR(20)  NOT NULL CHECK (kind IN ('ACCREDITATION', 'CERTIFICATION')),
    scheme      VARCHAR(30)  NOT NULL CHECK (scheme IN
                  ('MANAGEMENT_SYSTEM', 'PRODUCT', 'PERSONNEL', 'LABORATORY',
                   'MEDICAL_LABORATORY', 'INSPECTION')),
    uses_ea_codes BOOLEAN    NOT NULL DEFAULT FALSE,     -- TRUE only for management-system scopes
    active      BOOLEAN      NOT NULL DEFAULT TRUE
);

-- Which accreditation standard covers which certification standard
-- e.g. ISO 9001 / 14001 / 45001 / 27001  ->  ISO/IEC 17021-1
CREATE TABLE standard_link (
    certification_standard_id SMALLINT NOT NULL REFERENCES standard(id),
    accreditation_standard_id SMALLINT NOT NULL REFERENCES standard(id),
    PRIMARY KEY (certification_standard_id, accreditation_standard_id)
);

-- EA / IAF sector codes (1..39)
CREATE TABLE ea_sector (
    code     SMALLINT PRIMARY KEY,
    name_en  VARCHAR(200) NOT NULL,
    name_it  VARCHAR(200)
);

-- MLA coverage: which NAB holds the EA MLA for which accreditation standard.
-- This is what makes a foreign certificate recognised in Italy.
-- MUST be filled and verified from the official EA / IAF signatory lists.
CREATE TABLE nab_mla (
    id                        SERIAL PRIMARY KEY,
    country_id                SMALLINT NOT NULL REFERENCES country(id),
    accreditation_standard_id SMALLINT NOT NULL REFERENCES standard(id),
    signed_date               DATE,
    source_url                VARCHAR(500),
    verified_at               DATE,
    verified_by               VARCHAR(100),
    UNIQUE (country_id, accreditation_standard_id)
);

-- ---------------------------------------------------------------------
-- 2. CERTIFICATION BODIES / ACCREDITATIONS / SCOPES
-- ---------------------------------------------------------------------

CREATE TABLE certification_body (
    id               BIGSERIAL PRIMARY KEY,
    legal_name       VARCHAR(300) NOT NULL,
    normalized_name  VARCHAR(300) NOT NULL,              -- lower, unaccented, no legal suffixes (set by app)
    country_id       SMALLINT     NOT NULL REFERENCES country(id),
    registration_no  VARCHAR(100),                       -- VAT / company reg. no. (dedup key if present)
    address          VARCHAR(400),
    city             VARCHAR(150),
    postal_code      VARCHAR(30),
    phone            VARCHAR(60),
    email            VARCHAR(200),
    website          VARCHAR(300),
    notes            TEXT,                               -- internal consultant notes
    active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at       TIMESTAMPTZ  NOT NULL DEFAULT now(),
    UNIQUE (country_id, normalized_name)
);

-- Original PDFs / exports (Accredia, Albanian DA, ...). Keeps provenance + prevents duplicate uploads.
CREATE TABLE source_document (
    id             BIGSERIAL PRIMARY KEY,
    country_id     SMALLINT     NOT NULL REFERENCES country(id),
    doc_type       VARCHAR(30)  NOT NULL CHECK (doc_type IN
                     ('ACCREDITATION_CERTIFICATE', 'ACCREDITATION_SCHEDULE',
                      'DIRECTORY_EXPORT', 'OTHER')),
    file_name      VARCHAR(300) NOT NULL,
    storage_path   VARCHAR(500) NOT NULL,                -- path on our server
    sha256         CHAR(64)     NOT NULL UNIQUE,
    page_count     INT,
    is_scanned     BOOLEAN      NOT NULL DEFAULT FALSE,  -- TRUE = needs OCR
    issued_date    DATE,
    source_url     VARCHAR(500),
    uploaded_by    BIGINT,                               -- FK added after app_user
    uploaded_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- One row = one CB accredited against one accreditation standard (e.g. 17021-1)
CREATE TABLE accreditation (
    id                        BIGSERIAL PRIMARY KEY,
    cb_id                     BIGINT   NOT NULL REFERENCES certification_body(id),
    accreditation_standard_id SMALLINT NOT NULL REFERENCES standard(id),
    nab_certificate_no        VARCHAR(100),              -- NAB's own accreditation number
    accredited_since          DATE,                      -- first accreditation date
    valid_from                DATE,                      -- current certificate issue date
    valid_until               DATE,                      -- expiration date
    status                    VARCHAR(15) NOT NULL DEFAULT 'ACTIVE'
                                CHECK (status IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN', 'EXPIRED')),
    source_document_id        BIGINT REFERENCES source_document(id),
    source_url                VARCHAR(500),
    last_verified_at          DATE,
    created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (valid_until IS NULL OR valid_from IS NULL OR valid_until >= valid_from)
);
CREATE UNIQUE INDEX uq_accreditation
    ON accreditation (cb_id, accreditation_standard_id, COALESCE(nab_certificate_no, ''));

-- What the CB is actually allowed to certify:
--   Management systems: certification standard + EA code      (ISO 9001 + EA 28)
--   Personnel / labs / products: scope_text (no EA code)      ('Welders', 'Chemical testing: water')
CREATE TABLE accreditation_scope (
    id                        BIGSERIAL PRIMARY KEY,
    accreditation_id          BIGINT   NOT NULL REFERENCES accreditation(id) ON DELETE CASCADE,
    certification_standard_id SMALLINT REFERENCES standard(id),
    ea_sector_code            SMALLINT REFERENCES ea_sector(code),
    scope_text                TEXT,
    restrictions              TEXT,                      -- e.g. 'excluding design', 'limited scope'
    CHECK (certification_standard_id IS NOT NULL OR scope_text IS NOT NULL)
);
CREATE UNIQUE INDEX uq_scope
    ON accreditation_scope (accreditation_id,
                            COALESCE(certification_standard_id, 0),
                            COALESCE(ea_sector_code, 0),
                            md5(COALESCE(scope_text, '')));

-- ---------------------------------------------------------------------
-- 3. IMPORT PIPELINE (PDF -> staging -> human review -> production)
-- ---------------------------------------------------------------------

CREATE TABLE import_batch (
    id                 BIGSERIAL PRIMARY KEY,
    source_document_id BIGINT      NOT NULL REFERENCES source_document(id),
    parser_name        VARCHAR(100) NOT NULL,            -- 'AccrediaPdfParser', 'AlbaniaPdfParser'
    status             VARCHAR(20) NOT NULL DEFAULT 'PARSING'
                         CHECK (status IN ('PARSING', 'REVIEW', 'COMPLETED', 'FAILED')),
    rows_total         INT NOT NULL DEFAULT 0,
    rows_promoted      INT NOT NULL DEFAULT 0,
    rows_rejected      INT NOT NULL DEFAULT 0,
    error_message      TEXT,
    started_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    finished_at        TIMESTAMPTZ
);

CREATE TABLE import_staging_row (
    id               BIGSERIAL PRIMARY KEY,
    batch_id         BIGINT      NOT NULL REFERENCES import_batch(id) ON DELETE CASCADE,
    row_no           INT         NOT NULL,
    page_no          INT,
    raw_text         TEXT,                               -- exact text extracted from the PDF
    parsed           JSONB       NOT NULL DEFAULT '{}',  -- normalised fields, editable in review UI
    status           VARCHAR(15) NOT NULL DEFAULT 'PENDING'
                       CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'PROMOTED', 'ERROR')),
    confidence       NUMERIC(3,2),                       -- parser confidence 0.00-1.00
    matched_cb_id    BIGINT REFERENCES certification_body(id),
    error_message    TEXT,
    reviewed_by      BIGINT,                             -- FK added after app_user
    reviewed_at      TIMESTAMPTZ,
    UNIQUE (batch_id, row_no)
);

-- Automated refresh jobs from NAB web directories (phase 2+)
CREATE TABLE ingestion_run (
    id            BIGSERIAL PRIMARY KEY,
    connector     VARCHAR(100) NOT NULL,                 -- 'DAkkSConnector', ...
    country_id    SMALLINT REFERENCES country(id),
    status        VARCHAR(15) NOT NULL CHECK (status IN ('RUNNING', 'SUCCESS', 'PARTIAL', 'FAILED')),
    rows_added    INT NOT NULL DEFAULT 0,
    rows_updated  INT NOT NULL DEFAULT 0,
    rows_failed   INT NOT NULL DEFAULT 0,
    log           TEXT,
    started_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    finished_at   TIMESTAMPTZ
);

-- ---------------------------------------------------------------------
-- 4. INTERNAL USERS + AUDIT
-- ---------------------------------------------------------------------

CREATE TABLE app_user (
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(200) NOT NULL UNIQUE,
    display_name  VARCHAR(150) NOT NULL,
    password_hash VARCHAR(100),                          -- NULL if SSO / LDAP is used
    role          VARCHAR(10)  NOT NULL DEFAULT 'VIEWER'
                    CHECK (role IN ('VIEWER', 'EDITOR', 'ADMIN')),
    enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    last_login_at TIMESTAMPTZ
);

ALTER TABLE source_document
    ADD CONSTRAINT fk_source_document_user FOREIGN KEY (uploaded_by) REFERENCES app_user(id);
ALTER TABLE import_staging_row
    ADD CONSTRAINT fk_staging_reviewer FOREIGN KEY (reviewed_by) REFERENCES app_user(id);

CREATE TABLE audit_log (
    id          BIGSERIAL PRIMARY KEY,
    user_id     BIGINT REFERENCES app_user(id),
    action      VARCHAR(50)  NOT NULL,                   -- 'CB_UPDATE', 'IMPORT_PROMOTE', 'LOGIN'
    entity      VARCHAR(50),
    entity_id   BIGINT,
    details     JSONB,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------------
-- 5. INDEXES
-- ---------------------------------------------------------------------

CREATE INDEX idx_cb_country            ON certification_body (country_id);
CREATE INDEX idx_cb_name_trgm          ON certification_body USING gin (normalized_name gin_trgm_ops);
CREATE INDEX idx_acc_cb                ON accreditation (cb_id);
CREATE INDEX idx_acc_std_status        ON accreditation (accreditation_standard_id, status, valid_until);
CREATE INDEX idx_scope_acc             ON accreditation_scope (accreditation_id);
CREATE INDEX idx_scope_search          ON accreditation_scope (certification_standard_id, ea_sector_code);
CREATE INDEX idx_scope_text_trgm       ON accreditation_scope USING gin (scope_text gin_trgm_ops);
CREATE INDEX idx_staging_batch_status  ON import_staging_row (batch_id, status);
CREATE INDEX idx_audit_entity          ON audit_log (entity, entity_id);

-- ---------------------------------------------------------------------
-- 6. SEARCH VIEW
--    Effective status is computed from valid_until, so an expired
--    accreditation never shows as ACTIVE even if the row was not refreshed.
--    mla_covered = the CB's NAB holds MLA for that accreditation standard.
-- ---------------------------------------------------------------------

CREATE VIEW v_scope_search AS
SELECT
    sc.id                      AS scope_id,
    cb.id                      AS cb_id,
    cb.legal_name              AS cb_name,
    c.iso_code                 AS country_code,
    c.name                     AS country_name,
    a.id                       AS accreditation_id,
    ast.code                   AS accreditation_standard,
    ast.scheme                 AS scheme,
    cst.id                     AS certification_standard_id,
    cst.code                   AS certification_standard,
    sc.ea_sector_code,
    es.name_en                 AS ea_sector_name,
    sc.scope_text,
    sc.restrictions,
    a.accredited_since,
    a.valid_until,
    CASE
        WHEN a.status = 'ACTIVE'
         AND a.valid_until IS NOT NULL
         AND a.valid_until < CURRENT_DATE THEN 'EXPIRED'
        ELSE a.status
    END                        AS effective_status,
    EXISTS (
        SELECT 1 FROM nab_mla m
        WHERE m.country_id = cb.country_id
          AND m.accreditation_standard_id = a.accreditation_standard_id
    )                          AS mla_covered
FROM accreditation_scope sc
JOIN accreditation       a   ON a.id  = sc.accreditation_id
JOIN certification_body  cb  ON cb.id = a.cb_id AND cb.active
JOIN country             c   ON c.id  = cb.country_id
JOIN standard            ast ON ast.id = a.accreditation_standard_id
LEFT JOIN standard       cst ON cst.id = sc.certification_standard_id
LEFT JOIN ea_sector      es  ON es.code = sc.ea_sector_code;
