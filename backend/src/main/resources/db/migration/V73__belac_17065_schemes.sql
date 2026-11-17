-- EU directives for the BELAC ISO/IEC 17065 dataset (data/belac-belgium-17065), each held by two
-- BELAC notified bodies. TPED, Low Voltage, Batteries and Global Red Meat Standard appear at one body
-- only and stay as line text; Belgian national schemes (Vegaplan, BENOR, FASFC autocontrol guides,
-- Feed Chain Alliance, BePork, ...) are text with a sector.
INSERT INTO schemes (code, owner, kind) VALUES
    ('Recreational Craft Directive 2013/53/EU', 'European Union', 'EU_REGULATION'),
    ('Marine Equipment Directive 2014/90/EU',   'European Union', 'EU_REGULATION')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('Recreational Craft Directive 2013/53/EU', 'transport_equipment'),
    ('Marine Equipment Directive 2014/90/EU',   'transport_equipment'),
    ('Marine Equipment Directive 2014/90/EU',   'machinery')
ON CONFLICT DO NOTHING;
