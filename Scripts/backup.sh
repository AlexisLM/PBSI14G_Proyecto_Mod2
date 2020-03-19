#!/bin/bash

# Generate backups
echo "Generating backup for site1 ..."
su - postgres -c "pg_dump site1 > site1db.sql"
tar -czf site1.tar.gz -C /var/www site1 -C /var/lib/postgresql site1db.sql

echo "Generating backup for site2 ..."
su - postgres -c "pg_dump site2 > site2db.sql"
tar -czf site2.tar.gz -C /var/www site2 -C /var/lib/postgresql site2db.sql

# Delete db backups
rm /var/lib/postgresql/site1db.sql /var/lib/postgresql/site2db.sql

echo "Backups successfully generated!"

