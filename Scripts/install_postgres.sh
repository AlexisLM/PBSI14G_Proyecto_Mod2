#!/bin/bash

sudo apt -y install postgresql-11
sudo pg_ctlcluster 11 main start
sudo mv pg_hba.conf /etc/postgresql/11/main/
sudo chown postgres:postgres /etc/postgresql/11/main/pg_hba.conf
sudo systemctl restart postgresql
