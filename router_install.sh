#!/bin/bash
sudo su -

# variables
password="Cluster^123"

yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
yum update -y
yum install -y mysql-router mysql-shell

# waiting for all configuration is done
sleep 240

echo $password | mysqlrouter --bootstrap mycluster@mysql01 --conf-base-port 3306 --user=mysqlrouter
systemctl enable mysqlrouter
systemctl start mysqlrouter


