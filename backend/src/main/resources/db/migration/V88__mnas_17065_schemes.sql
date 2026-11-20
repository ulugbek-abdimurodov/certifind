-- Scheme for the MNAS (Mongolia) ISO/IEC 17065 dataset (data/mnas-mongolia-17065).
-- SFA Cashmere Standard (Sustainable Fibre Alliance: herding, fibre collection and scouring codes of practice
-- C001-C003): cited by PC 10 (SFCS LLC) and PC 13 (Nexus Connect LLC).
-- Mongolian GAP (ХААЗД, MNS 6737), the national organic rules and the Bestgerl green building rules are national:
-- text only.
INSERT INTO schemes (code, owner, kind) VALUES
    ('SFA Cashmere Standard', 'Sustainable Fibre Alliance', 'PRIVATE')
ON CONFLICT (code) DO NOTHING;

INSERT INTO scheme_industries (scheme_code, industry_code) VALUES
    ('SFA Cashmere Standard', 'textiles'),
    ('SFA Cashmere Standard', 'agriculture')
ON CONFLICT DO NOTHING;
