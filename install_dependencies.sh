#!/bin/bash

#user_apache="basic-account"
#user_postgres="basic-account"

#pwd_apache="hola123.,"
#pwd_postgres="hola123.,"

#ip_apache="192.168.145.129"
#ip_postgres="192.168.145.133"

# Generate tar
#tar -czf sites_conf.tar.gz \
#	-C /etc/ssl/certs drupal7certificate.pem \
#	-C /etc/ssl/private drupal7key.pem \
#	-C /etc/apache2/sites-available ${1} ${2}

# Send configuration to servers
#sshpass -p ${pwd_apache} scp sites_conf.tar.gz \
#	${user_apache}@${ip_apache}:/home/${user_apache}
sshpass -p ${pwd_postgres} scp /etc/postgresql/11/main/pg_hba.conf \
	${user_postgres}@${ip_postgres}:/home/${user_postgres}

# Install and configure Apache
#echo -e "\nInstalling apache..."
#sshpass -p ${pwd_apache} ssh ${user_apache}@${ip_apache} \
#	"echo ${pwd_apache} | sudo -Sv && bash -s" < install_apache.sh ${1} ${2}

# Install and configure Postgres
echo -e "\nInstalling PostgreSql..."
sshpass -p ${pwd_postgres} ssh ${user_postgres}@${ip_postgres} \
	"echo ${pwd_postgres} | sudo -Sv && bash -s" < install_postgres.sh

# Delete tar
#rm sites_conf.tar.gz
