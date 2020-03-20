#!/bin/bash
sitepath="${1}"

echo "Information for new Drupal 8 site..."
#read -p "Directory Path for Drupal 7 site (remove last '/'): " sitepath
read -p "Database username (new): " dbuser
read -s -p "Database password(new): " dbpass
echo
read -p "Database ip/host(new): " dbhost
read -p "Database name(new): " dbname
sitedir="$(echo -n ${sitepath##*/})"
basepath="${sitepath::-${#sitedir}}"
echo "Creating new Drupal 8.8.4 site..."
cd "${basepath}"
drush dl drupal-8.8.4
mv drupal-8.8.4 "new_${sitedir}"
cd "new_${sitedir}"
drush si --db-url="pgsql://${dbuser}:${dbpass}@${dbhost}/${dbname}" --account-pass="${dbpass}" --notify -y
echo "Drupal 8 site created..."
echo "Installing migration modules"
drush en migrate_upgrade migrate_tools migrate_plus -y
echo "Information of old Drupal 7 site..."
read -p "Database username (old): " legacydbuser
read -s -p "Database password(old): " legacydbpass
echo
read -p "Database ip/host(old): " legacydbhost
read -p "Database name(old): " legacydbname
echo "Retrieving Drupal 7 site enabled modules... ${sitepath}"
cd "${sitepath}"
echo "$(pwd)"
oldmodules="$(drush pml --type=module --status=enabled --pipe)"
echo "Enabling modules (Drupal 8)..."
cd "${basepath}"
cd "new_${sitedir}"
for module in $oldmodules; do
    drush en "${module}" -y
done
echo "Preparing Migration..."
drush migrate-upgrade --legacy-db-url="pgsql://${legacydbuser}:${legacydbpass}@${legacydbhost}/${legacydbname}" \
    --legacy-root="${sitepath}" --configure-only
echo "Migration status..."
drush migrate-status
echo "Trying Migration..."
drush migrate-import --all
echo "Success...?"
echo "Transfering old .htaccess file."
cp "${sitepath}/.htaccess" .htaccess
echo "Information of Apache Configuration (VirtualHosts)..."
read -p "Absolute Path for Drupal 7 site .conf file: " apachehost
apachefile="$(echo -n ${apachehost##*/})"
echo "Preparing .tar file transfer to new server..."
read -p "Site url (www.example.com): " siteurl
read -p "Absolute Path for Drupal 7 ssl certificate: " sslcertificate
read -p "Absolute Path for Drupal 7 ssl private key: " sslkey
certificatefile="$(echo -n ${sslcertificate##*/})"
keyfile="$(echo -n ${sslkey##*/})"
echo "Creating .tar file..."
cd ..
tar -pczf "new_${sitedir}.tar.gz" "new_${sitedir}/." --checkpoint=.100
echo
echo "Information for ssh comunication..."
read -p "New Web Server ip/hostname: " webhost
read -p "New Web server privileged user (sudoer?): " webuser
read -s -p "New Web Server privileged user password: " webpass
echo
echo "Preparing Web Server..."
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'apt-get update && apt-get install php7.3 php7.3-dom php7.3-zip unzip \
    php7.3-gd php7.3-mbstring php7.3-xml php7.3-curl php7.3-pgsql php7.3-ldap -y'"
echo "Transfering .tar file..."
sshpass -p "${webpass}" scp -o StrictHostKeyChecking=no "new_${sitedir}.tar.gz" "${webuser}@${webhost}:~/"
echo "Transfering .conf file (VirtualHost)..."
sshpass -p "${webpass}" scp -o StrictHostKeyChecking=no "${apachehost}" "${webuser}@${webhost}:~/"
echo "Transfering certificate file..."
sshpass -p "${webpass}" scp -o StrictHostKeyChecking=no "${sslcertificate}" "${webuser}@${webhost}:~/"
echo "Transfering private key file..."
sshpass -p "${webpass}" scp -o StrictHostKeyChecking=no "${sslkey}" "${webuser}@${webhost}:~/"
echo "Extracting Drupal 8 site..."
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'tar -xf new_${sitedir}.tar.gz --checkpoint=.100'"
echo
echo "Moving Drupal 8 site to new location and changing ownership of sites/default/files..."
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'mv new_${sitedir} /var/www && mv /var/www/new_${sitedir} /var/www/${sitedir} && \
    chown -R www-data /var/www/${sitedir}/sites/default/files'"
echo "Moving/Enabling .conf file to sites-available"
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'mv ${apachefile} /etc/apache2/sites-available && a2ensite ${apachefile} && \
    echo "127.0.0.1 ${siteurl}" >> /etc/hosts'"
echo "Moving Certificate/Key to ssl directory..."
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'mv ${certificatefile} /etc/ssl/certs && mv ${keyfile} /etc/ssl/private'"
echo "Modding/Restarting Apache..."
sshpass -p "${webpass}" ssh -o StrictHostKeyChecking=no -t "${webuser}@${webhost}" \
    "echo ${webpass} | sudo -S sh -c 'a2enmod rewrite headers ssl && systemctl restart apache2'"
