-- Read-only login that OpenMetadata uses to scan this database
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'om_reader') THEN
    CREATE ROLE om_reader LOGIN PASSWORD 'om_reader';
  END IF;
END $$;

GRANT CONNECT ON DATABASE business TO om_reader;
GRANT pg_read_all_data TO om_reader;     -- read every table/view, including ones added by future migrations
GRANT pg_read_all_stats TO om_reader;    -- needed for usage/lineage from pg_stat_statements
