#!/usr/bin/env bash
set -euxo pipefail



## Install Logrotate
#---------- On CentOS, RHEL and Fedora ----------
# sudo yum update && yum install logrotate

#---------- On Debian and Ubuntu ----------
sudo apt-get update -y && sudo apt-get install --upgrade logrotate -y

bin_logrotate=$(which logrotate);
echo "bin_logrotate: "$bin_logrotate;

## Configure Logrotate logrotate.d
LOGROTATE_CONF="my_logrotate";

touch /etc/logrotate.d/${LOGROTATE_CONF}

cat << EOF > /etc/logrotate.d/${LOGROTATE_CONF}
/var/log/*/*.log {
    su root docker sopka
    create
    daily
    missingok
    size 10M
    rotate 12
    compress
    notifempty
}
EOF

logrotate -v -f /etc/logrotate.d/${LOGROTATE_CONF}

## logsrotate for PostgreSQL

## Configure Logrotate logrotate.d
PGLOGROTATE_CONF="postgresql-common"
echo "PGLOGROTATE_CONF: "${PGLOGROTATE_CONF};
touch /etc/logrotate.d/${PGLOGROTATE_CONF}

cat << PGEOF > /etc/logrotate.d/${PGLOGROTATE_CONF}
/var/log/postgresql/*.log {
    daily
    rotate 12
    size 50M
    copytruncate
    compress
    delaycompress
    notifempty
    missingok
    su root docker sopka
}
PGEOF

$bin_logrotate -v -f /etc/logrotate.d/${PGLOGROTATE_CONF}




