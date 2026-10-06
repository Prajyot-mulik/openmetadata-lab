# openmetadata-lab

OpenMetadata 2.0.3 running in GitHub Codespaces (Docker-in-Docker + official compose file).

## Start

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/Prajyot-mulik/openmetadata-lab?machine=standardLinux32gb)

1. Click the badge above (or **Code → Codespaces → Create codespace on main**). Pick the **4-core / 16 GB** machine.
2. Wait. The container builds, then `.devcontainer/start-om.sh` runs automatically and starts
   Postgres, Elasticsearch, the OpenMetadata server and Airflow ingestion.
   The first start pulls ~5 GB of images and takes 5–10 minutes.
3. Open the **PORTS** tab and click the globe icon on port **8585**.
4. Login: `admin@open-metadata.org` / `admin`

## Sample business database (`business_db`)

A fictional "Acme Retail" Postgres database runs next to OpenMetadata and is imported automatically
on every start (OpenMetadata → **Explore → Databases → acme_business_db**).

| Schema      | Tables / views                                              |
|-------------|-------------------------------------------------------------|
| `hr`        | departments, employees                                      |
| `crm`       | customers, addresses                                        |
| `catalog`   | categories, suppliers, products                             |
| `sales`     | orders, order_items, payments                               |
| `inventory` | warehouses, stock_levels                                    |
| `finance`   | invoices                                                    |
| `analytics` | daily_revenue, customer_lifetime_value, low_stock (views)   |

Schema changes are versioned migrations in [business-db/migrations](business-db/migrations).
To change the schema, add the next file (e.g. `V010__add_returns.sql`), then:

```bash
bash business-db/migrate.sh                                                     # apply new migrations
docker exec -i openmetadata_ingestion python - < business-db/register_in_openmetadata.py   # re-import into OpenMetadata
docker exec -it business_db psql -U business_admin business                    # SQL shell
```

## Useful commands

```bash
docker compose -f docker-compose-postgres.yml -f docker-compose.business-db.yml ps   # status
docker compose -f docker-compose-postgres.yml logs -f openmetadata-server
bash .devcontainer/start-om.sh                          # (re)start everything
cat /tmp/openmetadata-start.log                         # startup log
```

Airflow (ingestion) is on port 8080 (`admin` / `admin`).

## Notes

- Stop the codespace when you're done to save your free Codespaces hours (4-core uses 4 core-hours per hour).
- If Docker isn't available, run **Codespaces: Full Rebuild Container** from the command palette.
