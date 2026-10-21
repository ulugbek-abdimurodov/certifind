# CertiFind

CertiFind helps Italian businesses find certification bodies with relevant accredited scopes. The Spring Boot API reads all searchable organizations, scopes, accreditation authorities, and ATECO mappings from one PostgreSQL database. It does not scrape accreditation directories and does not show estimated prices.

## Day 3 demo

The Next.js interface provides:

- Search inputs for ISO standard, sector activity, and ATECO code
- A five-stage, 1.2-second progress animation followed by the live API search
- Result cards with country, accreditation body, relevant scope, and partnership status
- A detail drawer with contact information, accreditation source, and four collaboration criteria
- Clear error feedback when the API is unavailable or the sector cannot be resolved

Prices, rate assumptions, and savings are not part of the API contract or UI. Search results are sorted alphabetically by organization name.

## Start locally

### Full Stack via Docker Compose & Caddy (Recommended for Demos)

Start the entire coordinated application stack behind Caddy on port 80:

```powershell
docker compose up -d
```

Once running:
- Web Application: [http://localhost](http://localhost) (proxied to Next.js)
- API Endpoints: [http://localhost/api/v1/health](http://localhost/api/v1/health) (proxied to Spring Boot)
- Backend and PostgreSQL are reachable only inside the Compose network.

To verify the entire Dockerized stack before an executive demo, run the automated smoke test suite:
```powershell
.\test-e2e-stack.ps1
```

To enable automatic Let's Encrypt TLS in production, provide a domain:
```powershell
DOMAIN=certifind.yourdomain.com docker compose up -d
```

### Manual Development (Multi-Terminal)

Start PostgreSQL and load the schema and demo data on first initialization:

```powershell
docker compose up -d postgres
```

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

Open [http://localhost](http://localhost). The frontend uses the same-origin `/api/v1` path by default. Set `NEXT_PUBLIC_API_URL` in `.env.local` only when running against a separately hosted API.

## API

`POST /api/v1/search`

```json
{
  "isoStandard": "ISO 9001",
  "sectorActivity": "Asilo nido",
  "atecoCode": "88.91.00"
}
```

The response includes the resolved ATECO/EA sector and matching bodies with accreditation, auditor, partnership, contact, and source information. Unresolved sectors return HTTP 400; they are not silently mapped to Education.

## Data notes

`init-db/02-seed.sql` and `init-db/03-expanded-seed.sql` provide the demo data loaded into PostgreSQL. The backend schema at `backend/src/main/resources/schema.sql` is mounted by Docker as the single schema source of truth. Contact and accreditation details are demo data and should be confirmed against current official records before being represented as independently verified.

The single database uses `accreditation_bodies`, `ateco_ea_mapping`, `certification_bodies`, and `accredited_scopes`. The ATECO-to-EA relationship is stored separately from certification bodies; scope searches join through `accredited_scopes`. Compose shares `POSTGRES_DB`, `POSTGRES_USER`, and `POSTGRES_PASSWORD` with Spring through `SPRING_DATASOURCE_*`; browser traffic is same-origin through Caddy, so no CORS setting is required.
