# CertiFind

CertiFind helps Italian businesses find certification bodies with relevant accredited scopes. The current demo uses a static seed dataset and a Spring Boot API; it does not scrape accreditation directories and does not show estimated prices.

## Next.js

The Next.js interface provides:

- Search inputs for ISO standard, sector activity, and ATECO code
- A five-stage, 1.2-second progress animation followed by the live API search
- Result cards with country, accreditation body, and relevant scopes, filterable by accreditor
- A detail drawer with contact information, accreditation source, and collaboration criteria
- Clear error feedback when the API is unavailable or the sector cannot be resolved

Prices, rate assumptions, and savings are not part of the API contract or UI. Search results are sorted alphabetically by organization name.

## Start locally

Start PostgreSQL. On a new database volume, Docker runs the canonical schema
and seed exactly once, in filename order:

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

The response includes the resolved ATECO/EA sector and matching bodies with accreditation, scope, contact, and source information. Unresolved sectors return HTTP 400; they are not silently mapped to Education.

## Data notes

The SQL seed contains demonstration organization and accreditation data. Contact
and accreditation details must be confirmed against current official records
before being represented as independently verified. The interface links the
scope source supplied with each seed record and includes that caveat.

The database has one shared company structure for every accreditation body:
`certification_bodies` stores the organization and `accredited_scopes` stores
one row per standard and EA sector, including status, dates, source URL, and
scope text. `accreditation_bodies`, `iso_standard`, and `ea_sector` are shared
reference tables; ATECO mappings point to the EA sector table.

Example EA assignments in the demonstration data follow the organization's
field, regardless of its accreditor:

| Accreditor | Example field | EA code |
| --- | --- | --- |
| ACCREDIA | Education, IT, construction, engineering | EA 37, 33, 28, 34 |
| DAkkS | IT, construction, engineering | EA 33, 28, 34 |
| PCA | Education, IT, construction, engineering | EA 37, 33, 28, 34 |
| RENAR | Education, IT, construction, engineering | EA 37, 33, 28, 34 |
| UKAS | Education, IT, construction | EA 37, 33, 28 |

These assignments are examples, not claims about current accreditation
schedules. Real EA assignments must be checked against each organization's
official schedule. EA codes describe the certified organization's field; they
are not determined by its national accreditor. The schema allows `ea_code` to
be null for schemes whose scope is not classified with EA sectors; the source
scope text remains stored.

`init-db/01-schema.sql`, `init-db/02-seed.sql`, and
`init-db/03-upgrade-existing.sql` are the only database scripts. The seed is
transactional and safe to rerun. Docker's entrypoint runs them in order for an
empty volume; existing volumes are preserved and are not reset automatically.
For an existing database, back it up and apply the three scripts in order with
`psql`. This applies the reference data before adding the new foreign keys and
checks, without dropping the database volume.
