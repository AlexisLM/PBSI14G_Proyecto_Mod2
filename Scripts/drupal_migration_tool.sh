#!/bin/bash

echo -e "\nGenerating backups..."
./backup.sh

echo -e "\nChecking dependencies..."
./verify_install_git-drush.sh

echo -e "\nChecking if the sites exist..."
if [[ -d "/var/www/site1" ]]; then
  echo "Site1: OK"
else
  echo -e "Site1 doesn't exist.\nExiting..."
  exit 1
fi

if [[ -d "/var/www/site2" ]]; then
  echo "Site2: OK"
else
  echo -e "Site2 doesn't exist.\nExiting..."
  exit 1
fi

echo -e "\Disabling modules..."
./disable_modules.sh


