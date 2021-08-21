#!/bin/bash
set -ex

cd /home/isucon/webapp/go
make build

if [ -f /var/lib/mysql/slow.log ]; then
    sudo mv /var/lib/mysql/slow.log /var/lib/mysql/slow.log.$(date "+%Y%m%d_%H%M%S")
fi
if [ -f /var/log/nginx/access.log ]; then
    sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$(date "+%Y%m%d_%H%M%S")
fi

cd /home/isucon
source ./env.sh
sudo systemctl restart mysql
sudo systemctl restart isucondition.go.service
sudo systemctl restart nginx
