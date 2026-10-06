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

## Useful commands

```bash
docker compose -f docker-compose-postgres.yml ps        # status
docker compose -f docker-compose-postgres.yml logs -f openmetadata-server
bash .devcontainer/start-om.sh                          # (re)start everything
cat /tmp/openmetadata-start.log                         # startup log
```

Airflow (ingestion) is on port 8080 (`admin` / `admin`).

## Notes

- Stop the codespace when you're done to save your free Codespaces hours (4-core uses 4 core-hours per hour).
- If Docker isn't available, run **Codespaces: Full Rebuild Container** from the command palette.
