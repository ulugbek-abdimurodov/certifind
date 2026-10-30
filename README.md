# CertiFind

CertiFind helps Italian businesses find certification bodies with relevant accredited scopes. The current demo uses a static seed dataset and a Spring Boot API; it does not scrape accreditation directories and does not show estimated prices.

## Next.js

The Next.js interface provides:

- Search inputs for ISO standard and sector activity
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
  "sectorActivity": "Asilo nido"
}
```

The response includes the resolved EA sector and matching bodies with accreditation, scope, contact, and source information. Unresolved sectors return HTTP 400; they are not silently mapped to Education.

## Data notes

The SQL seed contains demonstration organization and accreditation data. Contact
and accreditation details must be confirmed against current official records
before being represented as independently verified. The interface links the
scope source supplied with each seed record and includes that caveat.

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

All certification bodies, certificate numbers, contacts and URLs are fictional.

`init-db/01-schema.sql` and `init-db/02-seed.sql` are the only database scripts.
Docker's entrypoint runs them once, on an empty volume. To rebuild an existing
volume from scratch (this deletes its data):

```powershell
docker compose down -v
docker compose up -d postgres
```
