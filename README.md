# CertiFind

CertiFind helps Italian businesses find certification bodies with relevant accredited scopes. It runs on a seeded PostgreSQL database, a Spring Boot API and a Next.js frontend; it does not scrape accreditation directories and does not show estimated prices.

## Stack

| Layer | Technology |
| --- | --- |
| Frontend | Next.js 16, React 19, TypeScript (`app/`, `components/`) |
| Backend | Spring Boot 3.3, Java 21, Spring Data JPA (`backend/`) |
| Database | PostgreSQL 16 (`pgvector/pgvector:pg16` image) via Docker Compose |

## Interface

The Next.js interface (Italian) provides:

- An ISO standard dropdown and a sector field with EA-sector autocomplete, both
  filled from the database (`GET /api/v1/options`)
- Quick demo scenarios, replaced by your last five searches (stored in `localStorage`)
- A five-stage, 1.2-second progress animation that runs alongside the API request
- Result cards with country, accreditation body and relevant scopes, filterable
  by "Italia • ACCREDIA" or by each foreign accreditor (e.g. "Albania • DPA")
- "Vedi tutte le aziende": a directory of every certification body and its
  currently valid scopes
- A detail drawer with contacts, certificate expiry date, accredited scopes
  grouped by standard (filterable per standard), collaboration criteria and the
  accreditation source link
- A light/dark theme toggle; the saved or system theme is applied before first paint
- Clear error feedback when the API is unavailable or the sector cannot be resolved

Prices, rate assumptions, and savings are not part of the API contract or UI. Search results are sorted alphabetically by organization name.

## Start locally

Prerequisites: Docker, Java 21 and Node.js.

Start PostgreSQL:

```powershell
docker compose up -d postgres
```

Load the company data. Flyway creates the schema and reference data first, then
the importer loads the datasets in `data/`:

```powershell
cd backend
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=import" "-Dspring-boot.run.arguments=--certifind.import.paths=../data"
```

Alternatively, `.\start-dev.ps1` starts the database and checks that ports 8080
and 3000 are free.

Database credentials default to those in `.env.example` and
`backend/src/main/resources/application.yml` (`certifind_db`, user `postgres`,
port 5432).

Start the backend (Flyway applies any new migrations on startup):

```powershell
.\mvnw.cmd spring-boot:run
```

In a third terminal, install frontend dependencies and start Next.js:

```powershell
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000). The frontend calls `http://localhost:8080` by default. Set `NEXT_PUBLIC_API_URL` in `.env.local` to use a different API origin.

Other scripts: `npm run lint`, `npm run build`, `npm start`.

## API

All endpoints are under `/api/v1`.

| Method | Path | Purpose |
| --- | --- | --- |
| `GET` | `/health` | Returns `{"status": "UP"}` |
| `GET` | `/options` | Certification standards and EA sectors that have at least one valid right |
| `POST` | `/search` | Bodies that may issue a standard in a sector |
| `GET` | `/companies` | Every certification body with its currently valid scopes (`directory: true`) |

`POST /api/v1/search`

```json
{
  "isoStandard": "ISO 9001",
  "sectorActivity": "EA 12 - Prodotti chimici e fibre"
}
```

The sector is resolved from an explicit `EA nn` code (1–39) if present,
otherwise through the IT/EN keyword vocabulary (`sector_keywords`). An empty
`isoStandard` defaults to ISO 9001.

The response includes the resolved EA sector and matching bodies with declared accreditation, scope, contact, certificate expiry and source information. Each card lists all of the body's valid EA sectors for the requested standard. Unresolved sectors return HTTP 400; they are not silently mapped to a default sector.

## Data notes

Data lives in three places, each managed differently:

| What | Where | How it changes |
| --- | --- | --- |
| Schema | `backend/src/main/resources/db/migration/V1__schema.sql` | New Flyway migration (`V3__...sql`); never edit an applied one |
| Reference data (accreditation bodies, EA sectors, standards, scheme rules, sector keywords) | `V2__reference_data.sql` | New Flyway migration |
| Certification bodies, accreditations, scopes | `data/<dataset>/*.csv` | Edit the CSVs, run the importer |

Real datasets: `data/dpa-albania` (transcribed from DPA accreditation annexes) and
`data/renar-romania` (extracted from RENAR certificates and annexes). Each folder's
`SOURCES.md` records where the data came from and the transcription rules. Contact and accreditation details must be confirmed against current official records
before being represented as independently verified; `verified_at` records the last
recorded check of the contact details. The interface shows available sources and
the recorded date, but an accreditation label means that the right is present in
the imported dataset, not that CertiFind independently verified it.

### Entering company data

A dataset is one folder per source (usually one per accreditation body), with three
UTF-8 CSV files. They open in Excel; save them as "CSV UTF-8". Empty cells mean NULL.

`bodies.csv`, one row per certification body:

| Column | Required | Notes |
| --- | --- | --- |
| `name` | yes | Exactly as on the accreditation certificate |
| `country` | yes | `Albania`, `Romania`, ... |
| `registration_no` | no | National company ID (NIPT, CUI, ...). When set, it identifies the body, so a renamed body is updated instead of duplicated |
| `phone` | no | International format, e.g. `+355 692081842` |
| `email`, `website` | no | `website` starts with `http://` or `https://` |
| `address` | no | Quote it if it contains commas (Excel does this) |
| `source_url` | no | Page the contact details were taken from |
| `verified_at` | no | `YYYY-MM-DD`, the date a person checked the row against the official record |

`accreditations.csv`, one row per accreditation certificate:

| Column | Required | Notes |
| --- | --- | --- |
| `ab_code` | yes | `DPA`, `RENAR`, `ACCREDIA`, ... (must exist in `accreditation_bodies`) |
| `certificate_number` | yes | Unique per accreditation body |
| `body_name` | yes | Must match a `name` in this folder's `bodies.csv` |
| `accreditation_standard` | yes | `ISO/IEC 17021-1`, `ISO/IEC 27006`, `ISO 50003`, ... |
| `status` | no | `ACTIVE` (default), `SUSPENDED`, `WITHDRAWN` |
| `issue_date` / `expiry_date` | issue: yes | `YYYY-MM-DD` |
| `proof_url` | no | Link to the certificate or the accreditation body's page for it |

`scopes.csv`, one row per certification standard under an accreditation:

| Column | Required | Notes |
| --- | --- | --- |
| `certificate_number` | yes | Must match a row in `accreditations.csv` |
| `certification_standard` | yes | `ISO 9001`, `ISO/IEC 27001`, ...; must be allowed by the accreditation standard |
| `ea_codes` | yes | `ALL`, `17`, or ranges like `1-10;12-39` |
| `status` | no | `ACTIVE` (default), `SUSPENDED`, `WITHDRAWN`; split a row to give one EA code a different status |
| `scope_note` | no | Restrictions from the annex, e.g. "limited to paper products" |

Workflow for adding or changing data:

1. Edit the CSVs, or create a new `data/<source>/` folder with all three files and a `SOURCES.md`.
2. Dry run. This validates everything, reports what would change, and rolls back:

   ```powershell
   cd backend
   .\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=import" "-Dspring-boot.run.arguments=--certifind.import.paths=../data --certifind.import.dry-run=true"
   ```

3. Read the report (inserted / updated / withdrawn / unchanged per table). Then open a
   pull request so a second person can check the rows against the source PDFs.
4. After merging, run the same command without `--certifind.import.dry-run=true`.

How the importer behaves:

- It reports every problem with its `file:line` (bad dates, unknown EA codes, a standard
  the accreditation cannot cover, a body name with no matching row, and so on). If there
  is any problem, nothing is imported.
- All datasets load in one transaction: either everything lands or nothing does.
- It is idempotent. Rows are matched on natural keys (body: `registration_no`, or
  `name` within a country; accreditation: accreditation body + certificate number;
  scope: accreditation + standard + EA code), so a second run changes nothing.
- Nothing is deleted. An accreditation or EA scope that disappears from its dataset's
  CSVs is set to `WITHDRAWN`, which removes it from search and keeps the history.
  Each accreditation belongs to the dataset that loaded it (`accreditations.data_source`),
  so one dataset never withdraws another dataset's rows.
- A new accreditation body, standard or scheme rule is reference data: add it with a
  Flyway migration first, then the importer accepts it.

Accreditation bodies (real reference data): ACCREDIA (Italy), UKAS (United
Kingdom), DAkkS (Germany), RENAR (Romania), PCA (Poland), DPA (Albania).

Data model (`V1__schema.sql`):

- `certification_bodies` – the bodies a user is looking for (contacts, national
  registration number and where the details come from).
- `accreditations` – one accreditation certificate held by a body: which
  accreditation body granted it, against which accreditation standard
  (ISO/IEC 17021-1, ISO/IEC 27006, ISO 50003), certificate number, status and
  validity dates. A body can hold several, from different accreditation bodies.
- `accredited_scopes` – one issuing right per row: certification standard
  (ISO 9001, ISO/IEC 27001, ...) x EA sector under one accreditation.
- `accreditation_scheme_rules` – which certification standards each
  accreditation standard covers (17021-1 -> 9001/14001/45001, 27006 -> 27001,
  50003 -> 50001). Composite foreign keys enforce it, so a 27006 accreditation
  cannot carry an ISO 9001 scope.
- `standards`, `ea_sectors`, `accreditation_bodies` – reference data.
- `sector_keywords` – IT/EN words resolved to an EA code ("metallo" -> EA 17).
- `v_issuing_rights` – every currently valid right (scope and accreditation
  active, accreditation not expired); the API applies the same rule.

A body is returned for "standard S in EA n" when it has a valid right for S in
EA n.

### Datasets

All company data is real. `data/dpa-albania` contains the Albanian bodies accredited by
DPA (Legal Cert, AXE Register, AQScert, Career Cert Institute, EQSC, CERTIS, e-Cert,
R.C.A, M.G Bugatti Certification, MSC Certifications, Autenticert Albania, CERTI AL).
`data/renar-romania` contains the 22 Romanian bodies holding a RENAR ISO/IEC 17021-1
accreditation (SM certificates).

To rebuild the database from scratch (this deletes the volume's data; everything in
it is reloaded from the repository):

```powershell
docker compose down -v
docker compose up -d postgres
cd backend
.\mvnw.cmd spring-boot:run "-Dspring-boot.run.profiles=import" "-Dspring-boot.run.arguments=--certifind.import.paths=../data"
```

A database created by the old `init-db/` scripts has no Flyway history, so the
backend refuses to start on it. Rebuild it once with the commands above.

## Deploying to a server

The files in `deploy/` run CertiFind on a Linux server with nothing but Docker
installed: PostgreSQL, the backend API and the CSV importer are all containers.
The CSVs in git stay the source of truth; the server holds the live copy that the
API reads, filled by the importer.

| File | Purpose |
| --- | --- |
| `deploy/docker-compose.prod.yml` | `postgres` and `backend` services, plus a one-off `importer`; ports bound to `127.0.0.1`, passwords from `.env` |
| `backend/Dockerfile` | One image for both the API (`prod` profile) and the importer (`import` profile) |
| `deploy/.env.example` | Template for `deploy/.env` (git-ignored) |
| `deploy/postgres-init/01-roles.sh` | Creates the database roles on a new volume |
| `deploy/backup.sh` | Nightly `pg_dump`, pruning and optional off-site copy |
| `backend/src/main/resources/application-prod.yml` | Backend profile: credentials from environment, no migrations |

Three database roles, so the public API can never change data:

| Role | Used by | Rights |
| --- | --- | --- |
| `certifind_admin` | maintenance, backups | superuser |
| `certifind_import` | Flyway migrations and the CSV importer | owns the schema |
| `certifind_app` | the backend API | read-only (`SELECT`) |

### First setup (on the server)

```bash
git clone https://github.com/ulugbek-abdimurodov/certifind.git /opt/certifind
cd /opt/certifind/deploy
cp .env.example .env
nano .env    # replace every password, e.g. with: openssl rand -base64 24
chmod 600 .env
C="docker compose -f docker-compose.prod.yml"

$C up -d postgres                      # database first
$C build backend                       # builds the image the importer also uses
$C run --rm importer                   # creates the tables and loads data/
$C up -d backend                       # the API, on 127.0.0.1:8080
curl http://localhost:8080/api/v1/health
```

Order matters on a new server: the backend refuses to start until the importer has
created the tables (it keeps restarting until then).

Do not open ports 5432 or 8080 in the server's firewall; both are bound to
`127.0.0.1`. To serve the API publicly, put a reverse proxy with HTTPS (nginx,
Caddy) in front of port 8080.

### Production frontend hosting

The production Compose file intentionally runs PostgreSQL, the API and the
one-off importer; it does not run Next.js. Host the frontend on a managed
Next.js platform or on a separate web server. Set
`NEXT_PUBLIC_API_URL` to the public API origin when building it, for example
`https://api.example.com`. The API origin must be HTTPS in production.

The recommended arrangement is one HTTPS reverse proxy with separate routes:

```text
https://app.example.com        -> the Next.js frontend
https://api.example.com        -> 127.0.0.1:8080 (backend container)
```

Set `CERTIFIND_CORS_ALLOWED_ORIGINS=https://app.example.com` in
`deploy/.env` before starting the backend. Multiple frontend origins may be
listed as a comma-separated value. Origins must include the scheme and exact
host (and port when used); do not use a path, wildcard, or trailing slash.

For a same-origin reverse proxy, serve the Next.js frontend and API under one
origin and proxy `/api/` to the backend. Set `NEXT_PUBLIC_API_URL` to the same origin and leave
`CERTIFIND_CORS_ALLOWED_ORIGINS` empty; same-origin requests do not need CORS.
Never expose PostgreSQL publicly.

### Updating data or code (on the server)

After a pull request is merged:

```bash
cd /opt/certifind && git pull
cd deploy
C="docker compose -f docker-compose.prod.yml"
$C build backend
$C run --rm importer --certifind.import.dry-run=true   # read the report
$C run --rm importer                                   # load it
$C up -d backend                                       # restart on the new image
```

Import before restarting the
backend: the importer also applies new Flyway migrations, which the new backend
code may need. A dry run rolls back the data but not the migrations.

The importer can also run from your computer through an SSH tunnel
(`ssh -N -L 5433:localhost:5432 you@your-server`), with `--spring.datasource.url=
jdbc:postgresql://localhost:5433/certifind_db` and the `certifind_import` credentials.

### Backups

```bash
chmod +x /opt/certifind/deploy/backup.sh
crontab -e
# 15 3 * * * OFFSITE=backup@nas:/backups/certifind/ /opt/certifind/deploy/backup.sh >> /var/log/certifind-backup.log 2>&1
```

Dumps go to `/var/backups/certifind` and are kept 14 days (`BACKUP_DIR`, `KEEP_DAYS`).
Set `OFFSITE` so a copy survives losing the server. Restore a dump with:

```bash
docker exec -i certifind-postgres sh -c 'pg_restore -U "$POSTGRES_USER" -d "$POSTGRES_DB" --clean --if-exists' < certifind_db-YYYYMMDD-HHMMSS.dump
```

Try a restore once on a test machine, so you know the backups work.
