is_Installed () {
  if [[ "$(whereis ${1})" != "${1}:" ]] && [[ $(which ${1} | wc -l) -ne 0 ]]
  then
    echo 1
  else
    echo 0
  fi
}

if [[ $(is_Installed 'git') -eq 0 ]]; then
    apt install -y git
fi

if [[ $(is_Installed 'drush') -eq 0 ]]; then
  # Download drush
  wget https://github.com/drush-ops/drush/releases/download/8.3.2/drush.phar

  # Add binary file
  chmod +x drush.phar
  sudo mv drush.phar /usr/local/bin/drush

  # Add drush autocomplete
  drush init
fi