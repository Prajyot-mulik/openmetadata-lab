"""
Registers business_db in OpenMetadata and imports its metadata.

Runs INSIDE the openmetadata_ingestion container (which already has the
`metadata` CLI and every connector installed):
    docker exec -i openmetadata_ingestion python - < business-db/register_in_openmetadata.py
"""
import base64
import json
import subprocess
import sys
import tempfile

import requests

OM = "http://openmetadata-server:8585/api"
SERVICE_NAME = "acme_business_db"
SCHEMAS = ["crm", "catalog", "sales", "inventory", "hr", "finance", "analytics"]


def get_token() -> str:
    login = requests.post(
        f"{OM}/v1/users/login",
        json={"email": "admin@open-metadata.org", "password": base64.b64encode(b"admin").decode()},
        timeout=30,
    )
    login.raise_for_status()
    admin_token = login.json()["accessToken"]
    headers = {"Authorization": f"Bearer {admin_token}"}

    # Prefer the long-lived ingestion-bot token; fall back to the admin session token
    try:
        bot = requests.get(f"{OM}/v1/bots/name/ingestion-bot?fields=botUser", headers=headers, timeout=30).json()
        auth = requests.get(f"{OM}/v1/users/auth-mechanism/{bot['botUser']['id']}", headers=headers, timeout=30).json()
        return auth["config"]["JWTToken"]
    except Exception as exc:  # noqa: BLE001
        print(f"ingestion-bot token unavailable ({exc}); using admin token")
        return admin_token


def run(kind: str, source_config: dict, processor: dict | None, token: str) -> bool:
    workflow = {
        "source": {
            "type": "postgres",
            "serviceName": SERVICE_NAME,
            "serviceConnection": {
                "config": {
                    "type": "Postgres",
                    "username": "om_reader",
                    "authType": {"password": "om_reader"},
                    "hostPort": "business-db:5432",
                    "database": "business",
                }
            },
            "sourceConfig": {"config": source_config},
        },
        "sink": {"type": "metadata-rest", "config": {}},
        "workflowConfig": {
            "loggerLevel": "INFO",
            "openMetadataServerConfig": {
                "hostPort": OM,
                "authProvider": "openmetadata",
                "securityConfig": {"jwtToken": token},
            },
        },
    }
    if processor:
        workflow["processor"] = processor

    with tempfile.NamedTemporaryFile("w", suffix=".yaml", delete=False) as f:
        json.dump(workflow, f)  # JSON is valid YAML
    print(f"--- metadata {kind} ---", flush=True)
    return subprocess.run(["metadata", kind, "-c", f.name]).returncode == 0


def main() -> int:
    token = get_token()
    schema_filter = {"includes": [f"^{s}$" for s in SCHEMAS]}

    ok = run(
        "ingest",
        {"type": "DatabaseMetadata", "includeViews": True, "includeTags": True, "schemaFilterPattern": schema_filter},
        None,
        token,
    )
    if not ok:
        print("❌ Metadata ingestion failed")
        return 1

    # Column statistics + sample rows (optional; failure here doesn't block anything)
    run(
        "profile",
        {"type": "Profiler", "generateSampleData": True, "schemaFilterPattern": schema_filter},
        {"type": "orm-profiler", "config": {}},
        token,
    )
    print(f"✅ '{SERVICE_NAME}' is in OpenMetadata: Explore -> Databases -> {SERVICE_NAME}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
