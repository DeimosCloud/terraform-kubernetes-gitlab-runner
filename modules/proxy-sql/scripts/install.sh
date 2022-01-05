#!/bin/bash

#script only works for debian flavour


INTERFACE=$(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}' | head -n 1)
IP=$(ip a s $INTERFACE | egrep -o 'inet [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d' ' -f2)

apt-get update

apt-get install wget curl -y  

wget -O proxysql.deb "${url}"

dpkg -i proxysql.deb

rm proxysql.deb

apt-get install default-mysql-client -y

apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

 curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

 apt-get update

 apt-get install docker-ce docker-ce-cli containerd.io -y

systemctl restart docker

docker pull gcr.io/cloudsql-docker/gce-proxy:latest

docker run \
  -d \
  -p 127.0.0.1:3306:3306 \
  --restart=always \
  gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy \
    --ip_address_types=PRIVATE \
    -instances=${db_instance_master_name}=tcp:0.0.0.0:3306

docker run \
  -d \
  -p 127.0.0.1:3307:3306 \
  --restart=always \
  gcr.io/cloudsql-docker/gce-proxy:latest /cloud_sql_proxy \
    -ip_address_types=PRIVATE \
    -instances=${db_instance_slave_name}=tcp:0.0.0.0:3306



systemctl start proxysql

systemctl enable proxysql

mkdir /var/start-scripts

cat > /var/start-scripts/setup.sql << EOF 
INSERT INTO mysql_group_replication_hostgroups (writer_hostgroup, reader_hostgroup, backup_writer_hostgroup, offline_hostgroup, active, max_writers, writer_is_also_reader, max_transactions_behind ) VALUES (1, 2, 3, 4, 1, 1, 1, 100);
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (1, '127.0.0.1', 3306);
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (2, '127.0.0.1', 3307);
INSERT INTO mysql_servers (hostgroup_id, hostname, port) VALUES (3, '127.0.0.1', 3307);
UPDATE global_variables SET variable_value="${mysql_user}" WHERE variable_name='mysql-monitor_username';
UPDATE global_variables SET variable_value="${mysql_password}" WHERE variable_name='mysql-monitor_password';
LOAD MYSQL SERVERS TO RUNTIME; SAVE MYSQL SERVERS TO DISK;

UPDATE global_variables SET variable_value="admin:${proxysql_admin_password}" WHERE variable_name='admin-admin_credentials';
update global_variables set variable_value="$IP:6032" where variable_name="mysql-interfaces";
LOAD ADMIN VARIABLES TO RUNTIME; SAVE ADMIN VARIABLES TO DISK;
EOF

#Run this on the server after creation, for some reason this doesn't run on start up

#mysql -u admin --password="admin" -h 127.0.0.1 -P 6032 < /var/start-scripts/setup.sql

systemctl restart proxysql
