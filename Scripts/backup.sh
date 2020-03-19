# Generate db backups
su - postgres -c "pg_dump site1 > site1db.sql"
su - postgres -c "pg_dump site2 > site2db.sql"

# Generate tar
tar -czvf site1.tar.gz -C /var/www site1 -C /var/lib/postgresql site1db.sql
tar -czvf site2.tar.gz -C /var/www site2 -C /var/lib/postgresql site2db.sql

# Delete db backups
rm /var/lib/postgresql/site1db.sql /var/lib/postgresql/site2db.sql
