# Product certification demo data (fictitious)

Four made-up ISO/IEC 17065 bodies, accredited by the made-up accreditation body `DEMO`,
for trying the "Prodotti e processi" search during development. Every name starts with
"DEMO"; none of these bodies, certificates or scopes exist.

This folder is outside `data/`, so the normal import (`--certifind.import.paths=../data`)
never loads it. Do not load it into the production database.

Load it locally, from the repository root:

```powershell
Get-Content examples\product-demo\demo_accreditation_body.sql | docker exec -i certifind-postgres psql -U postgres -d certifind_db
cd backend
.\mvnw.cmd -q spring-boot:run "-Dspring-boot.run.profiles=import" "-Dspring-boot.run.arguments=--certifind.import.paths=../examples/product-demo"
```

What it covers:

- Schemes from the catalogue (IFS Food, BRCGS, GLOBALG.A.P., GMP+, ISCC, PEFC, eIDAS, ...).
- Lines with no catalogued scheme but an industry (EN 13432 compostable packaging,
  EN 1090-1 steel structures).
- Scope text in German, Spanish, Dutch and Greek, each with an English translation.
- One withdrawn line (Spanish olive oil), which must not appear in any search.

Remove it again:

```powershell
docker exec certifind-postgres psql -U postgres -d certifind_db -c "DELETE FROM certification_bodies WHERE name LIKE 'DEMO %'; DELETE FROM accreditation_bodies WHERE code = 'DEMO';"
```
