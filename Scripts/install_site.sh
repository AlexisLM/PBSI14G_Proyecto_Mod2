#!/bin/bash

sitename="${1}"
dbrole="${2}"
dbname="${3}"

su - postgres -c "psql -c \"CREATE ROLE ${dbrole} WITH ENCRYPTED PASSWORD 'hola123.,' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""

su - postgres -c "psql -c \"CREATE DATABASE ${dbname} OWNER ${dbrole} ENCODING 'UTF8';\""

cd /var/www/
drush dl drupal-8.8.4
mv drupal-8.8.4 ${sitename}
cd ${sitename}
drush si --account-mail=alexis.lopez@seguridad.unam.mx --account-name=admin --account-pass=hola123., --db-url=pgsql://${dbrole}:hola123.,@localhost:5432/${dbname} --site-name="${sitename}"

