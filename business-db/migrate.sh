#!/usr/bin/env bash
# Applies business-db/migrations/V*.sql in order, each one exactly once.
# Applied versions are tracked in public.schema_migrations.
# To change the schema: add a new file (e.g. V010__add_returns.sql) and re-run this script.
set -euo pipefail
cd "$(dirname "$0")"

CONTAINER=business_db
PSQL=(docker exec -i "$CONTAINER" psql -v ON_ERROR_STOP=1 -q -U business_admin -d business)

echo "Waiting for business_db..."
for i in $(seq 1 60); do
  docker exec "$CONTAINER" pg_isready -h 127.0.0.1 -U business_admin -d business >/dev/null 2>&1 && break
  sleep 2
done

"${PSQL[@]}" -c "CREATE TABLE IF NOT EXISTS public.schema_migrations (
  version    TEXT PRIMARY KEY,
  applied_at TIMESTAMPTZ NOT NULL DEFAULT now())"

for f in migrations/V*.sql; do
  v="$(basename "$f" .sql)"
  done_already="$("${PSQL[@]}" -tAc "SELECT 1 FROM public.schema_migrations WHERE version = '$v'")"
  if [ "$done_already" = "1" ]; then
    continue
  fi
  echo "Applying $v"
  { cat "$f"; echo; echo "INSERT INTO public.schema_migrations (version) VALUES ('$v');"; } \
    | "${PSQL[@]}" --single-transaction
done
echo "✅ business_db migrations up to date"
