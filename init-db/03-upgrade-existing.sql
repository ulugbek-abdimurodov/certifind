-- Backfill constraints for databases that already had the legacy tables.
-- New volumes already receive these constraints from 01-schema.sql.

CREATE UNIQUE INDEX IF NOT EXISTS uq_ateco_ea_description
    ON ateco_ea_mapping (COALESCE(ateco_code, ''), ea_code, description);

ALTER TABLE ateco_ea_mapping
    DROP CONSTRAINT IF EXISTS uq_ateco_ea_desc;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'ateco_ea_mapping'::regclass AND conname = 'fk_ateco_ea_sector'
    ) THEN
        ALTER TABLE ateco_ea_mapping
            ADD CONSTRAINT fk_ateco_ea_sector
            FOREIGN KEY (ea_code) REFERENCES ea_sector(code);
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'accredited_scopes'::regclass AND conname = 'fk_scope_standard'
    ) THEN
        ALTER TABLE accredited_scopes
            ADD CONSTRAINT fk_scope_standard
            FOREIGN KEY (iso_standard) REFERENCES iso_standard(code) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'accredited_scopes'::regclass AND conname = 'fk_scope_ea_sector'
    ) THEN
        ALTER TABLE accredited_scopes
            ADD CONSTRAINT fk_scope_ea_sector
            FOREIGN KEY (ea_code) REFERENCES ea_sector(code) ON DELETE RESTRICT;
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'accredited_scopes'::regclass AND conname = 'ck_scope_status'
    ) THEN
        ALTER TABLE accredited_scopes
            ADD CONSTRAINT ck_scope_status
            CHECK (status IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN', 'EXPIRED'));
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conrelid = 'accredited_scopes'::regclass AND conname = 'ck_scope_dates'
    ) THEN
        ALTER TABLE accredited_scopes
            ADD CONSTRAINT ck_scope_dates CHECK (
                accreditation_date IS NULL OR expiration_date IS NULL
                OR expiration_date >= accreditation_date
            );
    END IF;
END
$$;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM certification_bodies WHERE accreditation_body_id IS NULL
    ) THEN
        ALTER TABLE certification_bodies
            ALTER COLUMN accreditation_body_id SET NOT NULL;
    ELSE
        RAISE NOTICE 'Some companies have no accreditation body; nullable legacy rows were preserved.';
    END IF;
END
$$;

-- Replace legacy single-column indexes with indexes aligned to the search path.
DROP INDEX IF EXISTS idx_scopes_standard_ea;
DROP INDEX IF EXISTS idx_scopes_status;
DROP INDEX IF EXISTS idx_scopes_cb_id;
