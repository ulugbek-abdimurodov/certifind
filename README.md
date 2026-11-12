# CertiFind

CertiFind helps Italian businesses find certification bodies (CBs), in Italy and abroad, that hold an accredited scope for the ISO standard and EA sector they need. It runs on a PostgreSQL database, a Spring Boot API and a Next.js frontend. The database is loaded from CSV datasets built from the accreditation bodies' public registers. The app never scrapes at runtime and does not show estimated prices.

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
| Schema | `backend/src/main/resources/db/migration/V1__schema.sql` | New Flyway migration; never edit an applied one |
| Reference data (accreditation bodies, EA sectors, standards, scheme rules, sector keywords) | `V2__reference_data.sql` and one `V<n>__<ab>_reference_data.sql` per accreditation body (currently up to `V65`) | New Flyway migration. Find the next number with `ls \| sort -V`, because plain `ls` sorts `V9` after `V28` |
| Certification bodies, accreditations, scopes | `data/<dataset>/*.csv` | Edit the CSVs, run the importer |

Each folder in `data/` is one accreditation body's dataset (see [Datasets](#datasets)). Its
`SOURCES.md` records where the data came from, the conversion rules and any schemes left out. Contact and accreditation details must be confirmed against current official records
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
| `proof_url` | no | Link to the accreditation certificate or scope annex (preferably the PDF itself), else the body's register entry, else the register's home page. The detail drawer shows it as "Consulta la fonte dell'accreditamento". CertiFind only links to these documents; it never stores copies |

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

Accreditation bodies: 69 are loaded (one per dataset, see [Datasets](#datasets)). Each one is
added by its own `V<n>__<ab>_reference_data.sql` migration.

Data model (`V1__schema.sql`):

- `certification_bodies` – the bodies a user is looking for (contacts, national
  registration number and where the details come from).
- `accreditations` – one accreditation certificate held by a body: which
  accreditation body granted it, against which accreditation standard
  (ISO/IEC 17021-1, or a sector-specific one such as ISO/IEC 27006, ISO 50003,
  ISO 22003-1, ISO/IEC 20000-6, ISO/IEC 42006, ISO/IEC 17021-6/-7/-9 or AS 9104-1),
  certificate number, status, validity dates and `proof_url`. A body can hold several, from different accreditation bodies.
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

All company data is real. `data/` holds 69 datasets, one per accreditation body, named
`<ab-code>-<ab home country>` (for example `rva-netherlands`, `na-norway`, `uaf-united-states`).
Together they hold about 1,975 certification bodies in 109 countries, with about 4,770
active accreditations. A dataset belongs to its accreditation body, not to a country: each
body's `country` comes from its own address, so `data/ukas-united-kingdom` also contains
bodies based outside the UK.

Datasets are not edited by hand. They are produced by scripts kept outside this repository,
in `../database/<country>/`:

- the scraper for the register, and its raw output;
- `prepare_certifind.py`, which converts the scrape into the three CSVs and writes
  `<ab>_review.md` with every judgement call and skipped scheme;
- shared helpers in `../database/`: `prune_inactive.py` (drops expired rows and bodies
  without an ISO/IEC 17021-1 accreditation) and the ESYD sector tables in
  `../database/greece/prepare_certifind.py`.

To refresh a dataset, re-run its scraper and `prepare_certifind.py`, then import (dry run
first). `.claude/CLAUDE.md` and the `/add-country` skill document the full procedure and data
rules for adding a new accreditation body: national schemes are skipped, sector-specific
accreditation rows get suffixed certificate numbers, and phone numbers use international
format.

**Certificate links (`proof_url`).** Most datasets link each accreditation to its own
certificate or register entry. Some AB sites only allow a link to the register's home or
search page:

| Dataset | Link |
| --- | --- |
| `snas-slovakia` | Annex PDF per certificate (`ais.snas.sk/api/web/download/<file id>`) |
| `dpa-albania` | Certificate PDF per body, refreshed with `python ../database/albania/update_proof_urls.py data/dpa-albania/accreditations.csv`. CS 009, 018 and 019 have no usable link on the DPA page |
| `ema-mexico`, `jasanz-australia`, `tisi-thailand`, `pnac-pakistan`, `haa-croatia`, `moldac-moldova`, `soac-cote-divoire` | Register home or search page only (the sites are built in JavaScript, or the PDFs can only be fetched with a POST request) |

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

The files in `deploy/` run the whole of CertiFind on a Linux server with only
Docker installed: PostgreSQL, the backend API, the Next.js frontend and the CSV
importer are containers, with nginx in front for HTTPS. You never run `mvn`,
`npm` or `spring-boot:run` on the server; the image builds do that. The CSVs in
git stay the source of truth; the server holds the live copy that the API reads,
filled by the importer.

```text
browser ──HTTPS──> nginx :443 ──/api/──> backend  127.0.0.1:8080 ──> postgres 127.0.0.1:5432
                               └─ /  ──> frontend 127.0.0.1:3100
```

The frontend and the API share one origin (`https://<API_DOMAIN>`), so the
browser calls `/api/...` relatively and no CORS is needed.

| File | Purpose |
| --- | --- |
| `deploy/docker-compose.prod.yml` | `postgres`, `backend`, `frontend`, `proxy` and `certbot` services, plus a one-off `importer`; passwords from `.env` |
| `Dockerfile` (root) | The frontend image (Next.js standalone server) |
| `backend/Dockerfile` | One image for both the API (`prod` profile) and the importer (`import` profile) |
| `deploy/.env.example` | Template for `deploy/.env` (git-ignored) |
| `deploy/postgres-init/01-roles.sh` | Creates the database roles on a new volume |
| `deploy/nginx/templates/certifind.conf.template` | nginx config of the `proxy` container (option A below) |
| `deploy/nginx/host-certifind.conf.template` + `deploy/install-host-nginx.sh` | The same config for the host's own nginx (option B below) |
| `deploy/backup.sh` | Nightly `pg_dump`, pruning and optional off-site copy |
| `backend/src/main/resources/application-prod.yml` | Backend profile: credentials from environment, no migrations |

Three database roles, so the public API can never change data:

| Role | Used by | Rights |
| --- | --- | --- |
| `certifind_admin` | maintenance, backups | superuser |
| `certifind_import` | Flyway migrations and the CSV importer | owns the schema |
| `certifind_app` | the backend API | read-only (`SELECT`) |

### Requirements

- Linux with Docker Engine and the Compose plugin (`docker compose version`),
  and a user in the `docker` group.
- About 2 GB of free RAM to build the images on the server (or build them on
  your computer; see "Building on your computer" below), and ~3 GB of disk.
- A host name pointing at the server, for the HTTPS certificate. Without a
  domain, `<server-ip>.nip.io` works (e.g. `46.16.94.186.nip.io`).
- Ports 80 and 443 open in the firewall. Never open 5432, 8080 or 3100: they
  are bound to `127.0.0.1`.

Check first whether something on the server already uses ports 80/443:

```bash
sudo ss -ltnp | grep -E ':(80|443|8080|3100|5432) '
```

- **Nothing on 80/443**: use option A (the `proxy` container).
- **The host's nginx already serves other sites on 80/443**: use option B (a
  site in the host's nginx). Do not stop or edit the other sites. If 8080 or
  3100 are taken, set `BACKEND_PORT` / `FRONTEND_PORT` in `.env`.

### 1. Put the code on the server

From git (normal case):

```bash
sudo mkdir -p /opt/certifind && sudo chown $USER /opt/certifind
git clone https://github.com/ulugbek-abdimurodov/certifind.git /opt/certifind
```

Or, to test uncommitted changes, copy your working folder from your computer:

```bash
rsync -az --exclude .git --exclude node_modules --exclude .next --exclude backend/target \
  ./ you@your-server:/opt/certifind/
```

(`rsync` also copies your `deploy/.env` when it exists.)

### 2. Configure `deploy/.env`

```bash
cd /opt/certifind/deploy
cp .env.example .env
nano .env
chmod 600 .env
```

| Variable | Value |
| --- | --- |
| `POSTGRES_PASSWORD`, `CERTIFIND_IMPORT_PASSWORD`, `CERTIFIND_APP_PASSWORD` | Different random passwords: `openssl rand -base64 24 \| tr -d '/+='` |
| `API_DOMAIN` | Public host name, e.g. `46.16.94.186.nip.io` |
| `LETSENCRYPT_EMAIL` | Address for certificate expiry warnings |
| `CERTIFIND_CORS_ALLOWED_ORIGINS` | Empty (same origin). The prod profile refuses `http://` and `localhost` origins |
| `BACKEND_PORT`, `FRONTEND_PORT` | `8080` and `3100` unless those ports are taken |

The passwords only take effect when the database volume is created. Changing
them later needs `ALTER ROLE ... PASSWORD` in the database, or (test servers
only, it deletes all data) `docker compose -f docker-compose.prod.yml down -v`.

### 3. Build, create the database, start the app

```bash
cd /opt/certifind/deploy
C="docker compose -f docker-compose.prod.yml"

$C up -d postgres                    # database first
$C build backend frontend            # Maven and npm builds run inside Docker (several minutes)
$C run --rm importer                 # creates the tables and loads data/
$C up -d backend frontend

curl http://localhost:8080/api/v1/health      # {"status":"UP"}
curl -I http://localhost:3100/                # HTTP/1.1 200 OK
```

Order matters on a new server: the backend refuses to start until the importer has
created the tables (it keeps restarting until then).

### 4a. HTTPS with the proxy container (ports 80/443 free)

```bash
cd /opt/certifind/deploy && set -a && . ./.env && set +a
C="docker compose -f docker-compose.prod.yml"

# First certificate (certbot answers the challenge itself on port 80).
$C run --rm -p 80:80 --entrypoint certbot certbot certonly --standalone \
  -d "$API_DOMAIN" --email "$LETSENCRYPT_EMAIL" --agree-tos --no-eff-email

$C up -d proxy certbot
```

`certbot` then renews the certificate on its own (it checks twice a day) and
`proxy` reloads every 6 hours to use it. After editing the config template, run
`$C up -d --force-recreate proxy`.

### 4b. HTTPS with the host's nginx (80/443 used by other sites)

Do not start the `proxy` and `certbot` services: they would fight the host's nginx
for ports 80/443. Instead, with nginx and certbot installed on the host:

```bash
sudo sh /opt/certifind/deploy/install-host-nginx.sh
```

The script:

1. writes `/etc/nginx/sites-enabled/certifind.conf` from
   `deploy/nginx/host-certifind.conf.template`, with `API_DOMAIN`,
   `BACKEND_PORT` and `FRONTEND_PORT` from `.env`;
2. if there is no certificate yet, serves HTTP only, gets one with
   `certbot certonly --webroot -w /var/www/certbot`, and adds a renewal hook that
   reloads nginx (the host's certbot timer renews it);
3. runs `nginx -t` before every reload; if the test fails it restores the previous
   file, so the other sites never go down.

It only adds its own file; the other sites' configs are not touched. Run it again
after editing the template.

### 5. Check it

```bash
curl https://$API_DOMAIN/api/v1/health        # {"status":"UP"}
```

Then open `https://<API_DOMAIN>/` in a browser and run a search.

### Rate limits

Both nginx configs apply the same limits per client IP:

| Path | Limit per client IP |
| --- | --- |
| `POST /api/v1/search` | 2 requests/s, bursts of 10 |
| `GET /api/v1/companies` (whole directory) | 12 requests/min, bursts of 3 |
| other `/api/` | 10 requests/s, bursts of 40 |
| `/` (frontend pages and assets) | 20 requests/s, bursts of 80 |
| any path | 20 open connections, request body up to 16 KB |

Over a limit, nginx answers `429` with the API's error format and `Retry-After`.

### Updating data or code (on the server)

```bash
cd /opt/certifind && git pull          # or rsync from your computer, as in step 1
cd deploy
C="docker compose -f docker-compose.prod.yml"

# Backend code or data/ changed:
$C build backend
$C run --rm importer --certifind.import.dry-run=true   # read the report
$C run --rm importer                                   # load it
$C up -d backend                                       # restart on the new image

# Frontend changed (app/, components/, package.json):
$C build frontend
$C up -d frontend
```

Import before restarting the backend: the importer also applies new Flyway
migrations, which the new backend code may need. A dry run rolls back the data
but not the migrations.

Text in the frontend (links, labels, the help e-mail) is compiled into the
image, so a change only shows after `build frontend` and `up -d frontend`; then
reload the page with Ctrl+Shift+R. Changing `NEXT_PUBLIC_API_URL` also needs a
rebuild.

The importer can also run from your computer through an SSH tunnel
(`ssh -N -L 5433:localhost:5432 you@your-server`), with `--spring.datasource.url=
jdbc:postgresql://localhost:5433/certifind_db` and the `certifind_import` credentials.

### Building on your computer

On a small server, the Maven and Next.js builds can compete for memory with the
running sites. Build the images on your computer and copy them over instead:

```bash
cd deploy
docker compose -f docker-compose.prod.yml build backend frontend
docker save certifind-backend certifind-frontend | gzip -1 | ssh you@your-server 'gunzip | docker load'
```

Then on the server use `up -d --no-build ...` (and skip `build`), e.g.
`$C run --rm importer` and `$C up -d --no-build backend frontend`.

### Troubleshooting

```bash
$C ps                                  # state of each container
$C logs -f backend                     # or frontend, postgres, proxy
sudo nginx -t && sudo tail -f /var/log/nginx/error.log   # option B
```

| Symptom | Cause |
| --- | --- |
| `backend` keeps restarting | The importer has not run yet, or the database passwords in `.env` do not match the volume |
| Backend log: CORS origin refused | `CERTIFIND_CORS_ALLOWED_ORIGINS` has an `http://` or `localhost` origin; leave it empty |
| `502 Bad Gateway` | `backend` or `frontend` is not running, or `BACKEND_PORT` / `FRONTEND_PORT` differ from the nginx config (re-run the install script) |
| Old text on the site | The frontend image was not rebuilt and restarted, or the browser cache (Ctrl+Shift+R) |
| `proxy` exits: address already in use | Something else holds 80/443; use option B |
| Certificate request fails | DNS does not point at the server, port 80 is closed, or Let's Encrypt rate limits (`nip.io` is shared by many users) |

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
