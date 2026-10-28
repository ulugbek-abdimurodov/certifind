-- Backfill constraints for databases that already had the legacy tables.
-- New volumes already receive these constraints from 01-schema.sql.

ALTER TABLE ea_sector ADD COLUMN IF NOT EXISTS name_it VARCHAR(200);

UPDATE ea_sector SET name_it = CASE code
    WHEN 1 THEN 'Agricoltura e pesca'
    WHEN 2 THEN 'Attività estrattive'
    WHEN 3 THEN 'Prodotti alimentari, bevande e tabacco'
    WHEN 4 THEN 'Tessili e prodotti tessili'
    WHEN 5 THEN 'Pelli e prodotti in pelle'
    WHEN 6 THEN 'Legno e prodotti in legno'
    WHEN 7 THEN 'Pasta di legno, carta e prodotti di carta'
    WHEN 8 THEN 'Case editrici'
    WHEN 9 THEN 'Stampa'
    WHEN 10 THEN 'Prodotti petroliferi raffinati'
    WHEN 11 THEN 'Combustibile nucleare'
    WHEN 12 THEN 'Prodotti chimici'
    WHEN 13 THEN 'Prodotti farmaceutici'
    WHEN 14 THEN 'Gomma e materie plastiche'
    WHEN 15 THEN 'Prodotti minerali non metalliferi'
    WHEN 16 THEN 'Calcestruzzo, cemento, calce e gesso'
    WHEN 17 THEN 'Metalli di base e prodotti in metallo'
    WHEN 18 THEN 'Macchinari e apparecchiature'
    WHEN 19 THEN 'Apparecchiature elettriche e ottiche'
    WHEN 20 THEN 'Cantieristica navale'
    WHEN 21 THEN 'Aerospaziale'
    WHEN 22 THEN 'Altri mezzi di trasporto'
    WHEN 23 THEN 'Manifatturiero non classificato altrove'
    WHEN 24 THEN 'Riciclaggio'
    WHEN 25 THEN 'Fornitura di energia elettrica'
    WHEN 26 THEN 'Fornitura di gas'
    WHEN 27 THEN 'Fornitura di acqua'
    WHEN 28 THEN 'Costruzioni'
    WHEN 29 THEN 'Commercio all’ingrosso e al dettaglio'
    WHEN 30 THEN 'Alberghi e ristoranti'
    WHEN 31 THEN 'Trasporti, magazzinaggio e comunicazioni'
    WHEN 32 THEN 'Intermediazione finanziaria, immobili e noleggio'
    WHEN 33 THEN 'Tecnologie dell’informazione'
    WHEN 34 THEN 'Servizi di ingegneria'
    WHEN 35 THEN 'Altri servizi'
    WHEN 36 THEN 'Amministrazione pubblica'
    WHEN 37 THEN 'Istruzione'
    WHEN 38 THEN 'Sanità e assistenza sociale'
    WHEN 39 THEN 'Altri servizi sociali'
END;

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
