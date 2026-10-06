#!/usr/bin/env bash
# Starts OpenMetadata inside the Codespace. Safe to re-run any time:
#   bash .devcontainer/start-om.sh
set -uo pipefail
cd "$(dirname "$0")/.."

VER=2.0.3
FILE=docker-compose-postgres.yml
LOG=/tmp/openmetadata-start.log
exec > >(tee -a "$LOG") 2>&1

# Wait for the Docker daemon (docker-in-docker can take a few seconds after start)
echo "Waiting for Docker..."
for i in $(seq 1 60); do docker info >/dev/null 2>&1 && break; sleep 2; done
if ! docker info >/dev/null 2>&1; then
  echo "❌ Docker is not running. Run 'Codespaces: Rebuild Container' from the command palette."
  exit 1
fi

# Elasticsearch wants a higher mmap limit; ignore if the host doesn't allow it
sudo sysctl -w vm.max_map_count=262144 >/dev/null 2>&1 || true

# Download the official compose file once
if [ ! -s "$FILE" ]; then
  echo "Downloading OpenMetadata ${VER} compose file..."
  curl -fsSL -o "$FILE" \
    "https://github.com/open-metadata/OpenMetadata/releases/download/${VER}-release/${FILE}" \
    || { echo "❌ Download failed"; rm -f "$FILE"; exit 1; }
fi

echo "Starting containers (first run pulls ~5 GB of images, takes 5-10 min)..."
docker compose -f "$FILE" up -d || { echo "❌ docker compose failed"; exit 1; }

echo "Waiting for OpenMetadata UI on port 8585..."
for i in $(seq 1 120); do
  if curl -fs -o /dev/null http://localhost:8585; then
    echo "✅ OpenMetadata is ready: open the PORTS tab -> 8585 (login: admin@open-metadata.org / admin)"
    exit 0
  fi
  sleep 5
done
echo "⚠️ Still starting. Check with: docker compose -f $FILE ps   (log: $LOG)"
