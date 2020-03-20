#!/bin/bash

echo "Disabling modules in site1."
cd /var/www/site1
drush pml --no-core --type=module --status=enabled --pipe | xargs drush -y dis

echo "Disabling modules in site2."
cd /var/www/site2
drush pml --no-core --type=module --status=enabled --pipe | xargs drush -y dis

