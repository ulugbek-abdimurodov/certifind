# CertiFind

CertiFind helps Italian businesses find certification bodies with relevant accredited scopes. The current demo uses a static seed dataset and a Spring Boot API; it does not scrape accreditation directories and does not show estimated prices.

## Next.js

The Next.js interface provides:

- Search inputs for ISO standard, sector activity, and ATECO code
- A five-stage, 1.2-second progress animation followed by the live API search
- Result cards with country, accreditation body, relevant scope, and partnership status
- A detail drawer with contact information, accreditation source, and four collaboration criteria
- Clear error feedback when the API is unavailable or the sector cannot be resolved

Prices, rate assumptions, and savings are not part of the API contract or UI. Search results are sorted alphabetically by organization name.

## Start locally

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

Open [http://localhost:3000](http://localhost:3000). The frontend calls `http://localhost:8080` by default. Set `NEXT_PUBLIC_API_URL` in `.env.local` to use a different API origin.

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

`backend/src/main/resources/data/seed_cabs.json` contains the static demo dataset. Contact and accreditation details are demo data and should be confirmed against current official records before being represented as independently verified. The interface links the scope source supplied with each seed record and includes that caveat.

The database schema uses `accreditation_bodies`, `ateco_ea_mapping`, `certification_bodies`, and `accredited_scopes`. The ATECO-to-EA relationship is stored separately from certification bodies; scope searches join through `accredited_scopes`.
