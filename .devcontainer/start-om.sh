#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/.."
VER=2.0.3
FILE=docker-compose-postgres.yml

# wait for Docker inside the codespace
until docker info >/dev/null 2>&1; do sleep 2; done

# download compose file once
[ -f "$FILE" ] || curl -sL -o "$FILE" \
  "https://github.com/open-metadata/OpenMetadata/releases/download/${VER}-release/${FILE}"

docker compose -f "$FILE" up -d

echo "Waiting for OpenMetadata to start (2-4 min)..."
for i in $(seq 1 60); do
  curl -s -o /dev/null http://localhost:8585 && { echo "✅ OpenMetadata is ready on port 8585"; exit 0; }
  sleep 5
done
echo "⚠️ Still starting - check: docker compose -f $FILE ps"
