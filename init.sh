#!/bin/bash
set -ex

cd /home/isucon/webapp/go
make build

if [ -f /var/lib/mysql/mysqld-slow.log ]; then
    sudo mv /var/lib/mysql/mysqld-slow.log /var/lib/mysql/mysqld-slow.log.$(date "+%Y%m%d_%H%M%S")
fi
if [ -f /var/log/nginx/access.log]; then
    sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$(date "+%Y%m%d_%H%M%S")
fi

cd /home/isucon
sudo systemctl restart mysql
sudo systemctl restart isucondition.go.service
sudo systemctl restart nginx
