#!/bin/bash

# Check sites
echo -e "\nChecking if the sites exist..."
read -p "Directory Path for Drupal 7 site1 (remove last '/'): " site1path

if [[ -d "${site1path}" ]]; then
  echo "Site1: OK"
else
  echo -e "Site1 (${site1path}) doesn't exist.\nExiting..."
  exit 1
fi

read -p "Directory Path for Drupal 7 site2 (remove last '/'): " site2path
if [[ -d "${site2path}" ]]; then
  echo "Site2: OK"
else
  echo -e "Site2 $(site2path) doesn't exist.\nExiting..."
  exit 1
fi

# Generate backups
echo -e "\nGenerating backups..."
./backup.sh "${site1path}" "${site2path}"

# Check dependencies
echo -e "\nChecking dependencies..."
./verify_install_git-drush.sh

# Disable modules
#echo -e "\nDisabling modules..."
#./disable_modules.sh

# Install new sites
echo -e "\nInstalling new sites..."
echo -e "\nInstalling site1..."
./installnewdrupal8.sh "${site1path}"

echo -e "\nInstalling site2..."
./installnewdrupal8.sh "${site2path}"

# Rename sites
echo -e "\nRenaming sites..."
echo -e "Renaming ${site1path} to ${site1path}_old..."
mv ${site1path} ${site1path}_old

echo -e "Renaming ${site2path} to ${site2path}_old..."
mv ${site2path} ${site2path}_old

