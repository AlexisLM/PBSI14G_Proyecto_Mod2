#!/bin/bash

# Install PHP and Apache2(automatic)

sudo apt -y install php php-common libapache2-mod-php php-pgsql php-gd php-xml

# Uncrompress config
tar xzf sites_conf.tar.gz

# Move config
sudo mv ${1} ${2} /etc/apache2/sites-available/

# Move cert and key
sudo mv drupal7certificate.pem /etc/ssl/certs/
sudo mv drupal7key.pem /etc/ssl/private/

# Append security conf
#sudo echo "ServerSignature Off
#ServerTokens Prod
#
#Header set X-Content-Type-Options: 'nosniff'
#Header set X-Frame-Options: 'deny'
#Header set X-XSS-Protection: '1; mode=block'
#" >> /etc/apache2/conf-available/security.conf

