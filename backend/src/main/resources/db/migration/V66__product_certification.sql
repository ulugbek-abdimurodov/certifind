-- Product, process and service certification (ISO/IEC 17065).
--
-- Unlike management systems there is no shared sector code: each accreditation body
-- describes these scopes in free text, in its own language. The only thing comparable
-- across countries is the certification scheme, so the model is
--   product_scopes  one verbatim line of a scope annex, optionally matched to
--   schemes         a canonical scheme (IFS Food, ISCC EU, ...), which belongs to
--   industries      one or more of our own short list of industries.
-- A line with no recognised scheme can carry an industry of its own.
--
-- Scheme and industry on a line are assigned by the dataset converter, not here: the
-- mapping can be improved and re-imported without scraping again.
-- National schemes and EU notified-body modules are not catalogued (same rule as the
-- management system datasets).

INSERT INTO standards (code, title, kind) VALUES
    ('ISO/IEC 17065', 'Requirements for bodies certifying products, processes and services', 'ACCREDITATION');

CREATE TABLE industries (
    code        VARCHAR(30)  PRIMARY KEY,
    name_it     VARCHAR(100) NOT NULL,
    name_en     VARCHAR(100) NOT NULL,
    sort_order  INTEGER      NOT NULL
);

INSERT INTO industries (code, name_it, name_en, sort_order) VALUES
    ('agriculture',  'Agricoltura e acquacoltura',             'Agriculture and aquaculture',            1),
    ('food',         'Alimenti e mangimi',                     'Food and feed',                          2),
    ('forestry',     'Foreste, legno e carta',                 'Forestry, wood and paper',               3),
    ('packaging',    'Imballaggi',                             'Packaging',                              4),
    ('construction', 'Prodotti da costruzione',                'Construction products',                  5),
    ('electrical',   'Elettrico ed elettronico',               'Electrical and electronics',             6),
    ('machinery',    'Macchine e attrezzature a pressione',    'Machinery and pressure equipment',       7),
    ('energy',       'Biocarburanti e sostenibilità',          'Biofuels and sustainability',            8),
    ('ict',          'ICT, cybersicurezza e servizi fiduciari','ICT, cybersecurity and trust services',  9),
    ('chemicals',    'Chimica e cosmetici',                    'Chemicals and cosmetics',               10),
    ('textiles',     'Tessile',                                'Textiles',                              11),
    ('transport',    'Trasporti e logistica',                  'Transport and logistics',               12),
    ('services',     'Servizi',                                'Services',                              13);

-- code is the canonical name shown to users and written in product_scopes.csv.
CREATE TABLE schemes (
    code   VARCHAR(80)  PRIMARY KEY,
    owner  VARCHAR(150),
    kind   VARCHAR(20)  NOT NULL
           CHECK (kind IN ('PRIVATE', 'EU_REGULATION', 'STANDARD'))
);

CREATE TABLE scheme_industries (
    scheme_code    VARCHAR(80) NOT NULL REFERENCES schemes(code) ON UPDATE CASCADE ON DELETE CASCADE,
    industry_code  VARCHAR(30) NOT NULL REFERENCES industries(code),
    PRIMARY KEY (scheme_code, industry_code)
);

-- Starter catalogue of international schemes; extend it in later migrations as the
-- datasets bring in schemes that are not listed yet.
INSERT INTO schemes (code, owner, kind) VALUES
    ('GLOBALG.A.P. IFA',              'FoodPLUS GmbH',           'PRIVATE'),
    ('BRCGS Food Safety',             'BRCGS',                   'PRIVATE'),
    ('BRCGS Packaging Materials',     'BRCGS',                   'PRIVATE'),
    ('BRCGS Storage and Distribution','BRCGS',                   'PRIVATE'),
    ('BRCGS Agents and Brokers',      'BRCGS',                   'PRIVATE'),
    ('IFS Food',                      'IFS Management GmbH',     'PRIVATE'),
    ('IFS Logistics',                 'IFS Management GmbH',     'PRIVATE'),
    ('IFS Broker',                    'IFS Management GmbH',     'PRIVATE'),
    ('IFS HPC',                       'IFS Management GmbH',     'PRIVATE'),
    ('IFS PACsecure',                 'IFS Management GmbH',     'PRIVATE'),
    ('SQF',                           'SQF Institute',           'PRIVATE'),
    ('GMP+ FSA',                      'GMP+ International',      'PRIVATE'),
    ('ISCC EU',                       'ISCC System GmbH',        'PRIVATE'),
    ('ISCC PLUS',                     'ISCC System GmbH',        'PRIVATE'),
    ('2BSvs',                         NULL,                      'PRIVATE'),
    ('PEFC Chain of Custody',         'PEFC Council',            'PRIVATE'),
    ('eIDAS',                         'European Union',          'EU_REGULATION'),
    ('Europrivacy',                   NULL,                      'PRIVATE');

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('GLOBALG.A.P. IFA',               'agriculture'),
    ('BRCGS Food Safety',              'food'),
    ('BRCGS Packaging Materials',      'packaging'),
    ('BRCGS Storage and Distribution', 'food'),
    ('BRCGS Storage and Distribution', 'transport'),
    ('BRCGS Agents and Brokers',       'food'),
    ('IFS Food',                       'food'),
    ('IFS Logistics',                  'food'),
    ('IFS Logistics',                  'transport'),
    ('IFS Broker',                     'food'),
    ('IFS HPC',                        'chemicals'),
    ('IFS PACsecure',                  'packaging'),
    ('SQF',                            'food'),
    ('GMP+ FSA',                       'food'),
    ('ISCC EU',                        'energy'),
    ('ISCC PLUS',                      'energy'),
    ('2BSvs',                          'energy'),
    ('PEFC Chain of Custody',          'forestry'),
    ('PEFC Chain of Custody',          'packaging'),
    ('eIDAS',                          'ict'),
    ('Europrivacy',                    'ict');

-- One line of an ISO/IEC 17065 scope annex, kept verbatim. line_no is the line's
-- position in the source and identifies it across imports.
-- accreditation_standard is repeated only so the composite FK can guarantee the
-- line hangs off a 17065 accreditation (same technique as accredited_scopes).
CREATE TABLE product_scopes (
    id                      SERIAL PRIMARY KEY,
    accreditation_id        INTEGER     NOT NULL,
    accreditation_standard  VARCHAR(50) NOT NULL DEFAULT 'ISO/IEC 17065'
                            CHECK (accreditation_standard = 'ISO/IEC 17065'),
    line_no                 INTEGER     NOT NULL CHECK (line_no > 0),
    scheme_code             VARCHAR(80) REFERENCES schemes(code) ON UPDATE CASCADE,
    industry_code           VARCHAR(30) REFERENCES industries(code),
    product_text            TEXT,   -- product, process or service, original language
    product_text_en         TEXT,   -- English translation, when the converter adds one
    scheme_text             TEXT,   -- scheme as printed in the annex
    normative_docs          TEXT,   -- standards and regulations as printed in the annex
    standard_refs           TEXT,   -- identifiers extracted from the line: "EN 13432;ISO 22716"
    status                  VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
                            CHECK (status IN ('ACTIVE', 'SUSPENDED', 'WITHDRAWN')),
    CONSTRAINT fk_product_scope_accreditation FOREIGN KEY (accreditation_id, accreditation_standard)
        REFERENCES accreditations (id, accreditation_standard) ON DELETE CASCADE,
    CONSTRAINT uq_product_scope_line UNIQUE (accreditation_id, line_no),
    CONSTRAINT ck_product_scope_content
        CHECK (COALESCE(scheme_code, product_text, scheme_text, normative_docs) IS NOT NULL)
);

CREATE INDEX idx_product_scopes_scheme   ON product_scopes (scheme_code);
CREATE INDEX idx_product_scopes_industry ON product_scopes (industry_code);
