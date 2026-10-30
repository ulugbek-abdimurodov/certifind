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

Start PostgreSQL. On a new database volume, Docker runs the canonical schema
and seed exactly once, in filename order:

```powershell
docker compose up -d postgres
```

Alternatively, `.\start-dev.ps1` starts the database and checks that ports 8080
and 3000 are free.

Database credentials default to those in `.env.example` and
`backend/src/main/resources/application.yml` (`certifind_db`, user `postgres`,
port 5432).

In a second terminal, start the backend:

```powershell
cd backend
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

The response includes the resolved EA sector and matching bodies with accreditation, scope, contact, certificate expiry and source information. Each card lists all of the body's valid EA sectors for the requested standard. Unresolved sectors return HTTP 400; they are not silently mapped to a default sector.

## Data notes

The SQL seed mixes fictional demonstration bodies with real Albanian bodies
transcribed from DPA accreditation annexes. Contact and accreditation details
must be confirmed against current official records before being represented as
independently verified. The interface links the scope source supplied with each
seed record and includes that caveat.

Accreditation bodies (real reference data): ACCREDIA (Italy), UKAS (United
Kingdom), DAkkS (Germany), RENAR (Romania), PCA (Poland), DPA (Albania).

Data model (`init-db/01-schema.sql`):

- `certification_bodies` – the bodies a user is looking for (contacts only).
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
EA n. The seed (`init-db/02-seed.sql`) covers these cases, for example with
ISO 9001 + "metallo":

| Body | Rights | Result |
| --- | --- | --- |
| Qualitas Certificazioni | 17021-1: 9001 in EA 1, 2, 5, 23, 25, 26; 27006: 27001 in all EA | not in EA 17 |
| Nord Est, Metalcert, Sigma, Albion, Mainfranken, Polcert, Adriatik | 17021-1: 9001 incl. EA 17 | returned |
| Lombardia Safety Cert | 14001/45001 in EA 17, 9001 elsewhere | not for 9001 |
| InfoSec Assurance | 27006 only | not for 9001 |
| Energia Certa | 9001 EA 17 scope withdrawn | excluded |
| CertRom Audit | whole accreditation suspended | excluded |
| Polcert | 50003 expired 2026-06-30 | excluded for 50001 |
| Tecno Audit | 9001 EA 38 scope suspended | excluded for EA 38 only |

The bodies in the table above, with their certificate numbers, contacts and URLs,
are fictional. The seed also contains real Albanian bodies accredited by DPA
(Legal Cert, AXE Register, AQScert, Career Cert Institute, EQSC, CERTIS, e-Cert,
R.C.A, M.G Bugatti Certification, MSC Certifications, Autenticert Albania,
CERTI AL). Their sector lists are taken from the annexes; lettered categories
(ISO 50001 A–H, ISO 22000 A–K, ISO 22301, ISO 13485 device categories) are
mapped to EA codes by sector, and annexes that cover "all IAF codes" or give no
sector list are recorded for all 39 EA sectors.

`init-db/01-schema.sql` and `init-db/02-seed.sql` are the only database scripts.
Docker's entrypoint runs them once, on an empty volume. To rebuild an existing
volume from scratch (this deletes its data):

```powershell
docker compose down -v
docker compose up -d postgres
```
