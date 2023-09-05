#!/usr/bin/env bash

# Precompile assets
echo "$(date) - Checking for POSTGRES (host: $PGHOST, dbname: $PGDBNAME) connectivity"

# If the database exists, migrate. Otherwise setup (create and migrate)
bundle exec rake db:migrate 2>/dev/null || 
bundle exec rake db:create db:migrate 
echo "Database has been created & migrated!"

# # Wait for database to be ready
# while !</dev/tcp/db/5432; do 
#     echo 'Waiting for Postgres ...'
#     sleep 1 
# done
# echo "Postgres is up and running!"


# Remove a potentially pre-existing server.pid for Rails.
rm -f tmp/pids/server.pid

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"