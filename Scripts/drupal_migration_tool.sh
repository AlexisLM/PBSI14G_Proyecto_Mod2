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

#echo -e "\nDisabling modules..."
#./disable_modules.sh

# Renaming sites
echo -e "\nRenaming site1 to site1_old"
mv /var/www/site1 /var/www/site1_old

echo -e "\nRenaming site2 to site2_old"
mv /var/www/site2 /var/www/site2_old

# Install new sites
echo -e "\nInstalling new sites"
echo -e "\nInstalling site1"
./install_site.sh "site1" "adminsite1" "databasesite1"

echo -e "\nInstalling site2"
./install_site.sh "site2" "adminsite2" "databasesite2"

