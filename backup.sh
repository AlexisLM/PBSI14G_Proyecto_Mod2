#!/bin/bash

site1path="${1}"
site2path="${2}"
site1dir="$(echo -n ${site1path##*/})"
site2dir="$(echo -n ${site2path##*/})"
basepath1="${site1path::-${#site1dir}}"
basepath2="${site2path::-${#site2dir}}"

# Generate backups
echo "Generating backup for site1 (${site1path})..."
#su - postgres -c "pg_dump site1 > site1db.sql"
#tar -czf site1.tar.gz -C "${basepath1}" "${site1dir}" -C /var/lib/postgresql site1db.sql
tar -czf site1.tar.gz -C "${basepath1}" "${site1dir}" 

echo "Generating backup for site2 (${site2path})..."
#su - postgres -c "pg_dump site2 > site2db.sql"
#tar -czf site2.tar.gz -C /var/www site2 -C /var/lib/postgresql site2db.sql
tar -czf site2.tar.gz -C "${basepath2}" "${site2dir}" 

# Delete db backups
#rm /var/lib/postgresql/site1db.sql /var/lib/postgresql/site2db.sql

echo "Backups successfully generated!"

