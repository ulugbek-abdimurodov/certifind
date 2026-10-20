# CertiFind — Database Layer

CertiFind is a matchmaking platform that helps Italian SMEs find the right ISO certification body for their industry. This repository contains the **Day-1 static database** for the executive demo scheduled for 2026-10-24.

---

## What we built today

### Infrastructure

- **PostgreSQL 16 + pgvector** running in Docker (`pgvector/pgvector:pg16`)
- `docker-compose.yml` wired up with a named volume, a healthcheck, and an `init-db/` bind-mount so the schema and seed data load automatically on first start
- Environment variables managed via `.env` / `.env.example`

### Database schema (`init-db/01-init.sql`)

Four tables that model the certification lifecycle:

| Table | Purpose |
|---|---|
| `accreditation_bodies` | National/international accreditation authorities (ACCREDIA, RENAR, PCA …) |
| `ateco_ea_mapping` | Cross-reference between Italian ATECO industry codes and EA sector codes |
| `certification_bodies` | The actual CBs that issue ISO certificates, each linked to an accreditor |
| `accredited_scopes` | Individual (CB, ISO standard, EA sector) accreditation scope records |

Key design decisions:
- `custom_daily_rate_eur` on `certification_bodies` is nullable — `NULL` falls back to `accreditation_bodies.avg_daily_rate_eur` at query time via `COALESCE`, so we never duplicate rate data
- All tables use `CREATE … IF NOT EXISTS` and idempotent indexes, so the schema file is safe to re-run
- Composite index on `accredited_scopes(iso_standard, ea_code)` covers the hot matchmaking query path

### Seed data (`init-db/02-seed.sql`)

3 accreditation bodies · 5 ATECO→EA mappings · 12 certification bodies · 31 accredited scopes

| Country | Bodies | Accreditor | Rate range |
|---|---|---|---|
| Italy | SGS Italia, Bureau Veritas, TÜV Rheinland, DNV, RINA, Kiwa Cermet | ACCREDIA | €920–1,100/day |
| Romania | CertRom, SRAC CERT, Certind | RENAR | €620–640/day |
| Poland | TUV Nord, PRS, URS Polska | PCA | €680–720/day |

All 12 bodies have `has_italian_auditors = TRUE`. The three Romanian bodies are the demo's cost-leaders.

### QA verification (`test-eod-queries.sql`)

Covers four areas:

1. ATECO resolution — `88.91.00` → EA 37 (Education)
2. Core matchmaking query — returns 7 CBs for ISO 9001 / EA 37 sorted by effective day-rate
3. Eight spot-checks (specific bodies present, rate threshold, auditor availability)
4. Data integrity (no orphaned FK rows, expected row counts)

All checks pass in under 2 ms total.

---

## Demo scenario

A user enters their company's ATECO code (`88.91.00` — Asilo nido) and the target standard (ISO 9001). The platform resolves ATECO → EA 37, queries `accredited_scopes`, and returns:

```
 CertRom S.R.L.               | Romania | RENAR    | €620/day  ← cheapest, commercial partner
 Certind S.A.                 | Romania | RENAR    | €630/day  ← commercial partner
 SRAC CERT S.R.L.             | Romania | RENAR    | €640/day
 RINA Services S.p.A.         | Italy   | ACCREDIA | €990/day  ← commercial partner
 TUV Rheinland Italia S.r.l.  | Italy   | ACCREDIA | €1,050/day
 SGS Italia S.p.A.            | Italy   | ACCREDIA | €1,100/day ← commercial partner
 Bureau Veritas Italia S.p.A. | Italy   | ACCREDIA | €1,100/day ← commercial partner
```

---

## Running locally

```powershell
# Start Postgres (schema + seed applied automatically on first start)
docker compose up -d postgres

# Run ad-hoc queries
docker exec -it certifind-postgres psql -U postgres -d certifind_db

# Re-apply seed manually (idempotent)
Get-Content init-db\02-seed.sql | docker exec -i certifind-postgres psql -U postgres -d certifind_db

# Run the verification suite
Get-Content test-eod-queries.sql | docker exec -i certifind-postgres psql -U postgres -d certifind_db

# Full reset (drops the volume, re-runs init-db/ from scratch)
docker compose down -v; docker compose up -d postgres
```

> **PowerShell note:** Use `;` to chain commands, not `&&` (that requires PowerShell 7+).

---

## File layout

```
certifind/
├── docker-compose.yml
├── .env                         # local secrets (gitignored)
├── .env.example
├── test-eod-queries.sql         # QA verification script
├── init-db/
│   ├── 01-init.sql              # schema — runs on first container start
│   └── 02-seed.sql              # demo seed data — runs after schema
└── backend/
    └── src/main/resources/
        ├── schema.sql           # mirror of 01-init.sql for Spring Boot
        └── data/
            └── seed_cabs.json   # same seed data in JSON (for the data loader)
```

---

## What's next

- [ ] Spring Boot project scaffold (`backend/`) with JPA entities mapping to these tables
- [ ] `MatchController` — REST endpoint that runs the core matchmaking query
- [ ] Rate estimation service — wraps the `COALESCE(custom, avg)` logic
- [ ] Frontend — search form (ATECO input + ISO standard selector) + results table
