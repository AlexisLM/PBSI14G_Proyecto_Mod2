#!/bin/bash

is_Installed () {
  if [[ "$(whereis ${1})" != "${1}:" ]] && [[ $(which ${1} | wc -l) -ne 0 ]]
  then
    echo 1
  else
    echo 0
  fi
}

echo "Checking if git is installed..."

if [[ $(is_Installed 'git') -eq 0 ]]; then
  echo "Installing git..."

  apt install -y git
else
  echo "Git is installed."
fi

echo "Checking if git is installed..."

if [[ $(is_Installed 'drush') -eq 0 ]]; then
  echo "Installing drush..."

  # Download drush
  wget https://github.com/drush-ops/drush/releases/download/8.3.2/drush.phar

  # Add binary file
  chmod +x drush.phar
  sudo mv drush.phar /usr/local/bin/drush

  # Add drush autocomplete
  drush init
else
  echo "Drush is installed."
fi

