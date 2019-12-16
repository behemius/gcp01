#!/bin/bash

# variables
password="Cluster^123"

# mysql installation
sudo su -

sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/sysconfig/selinux 
setenforce 0 # I had problems on creation of cluster level because of SELinux
sysctl -w net.ipv6.conf.all.disable_ipv6=1 # for mysql replication test

yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
yum update -y
yum install -y mysql-server mysql-shell
echo "bind-address=0.0.0.0" >> /etc/my.cnf.d/mysql-server.cnf
echo "mysqlx_bind_address=0.0.0.0" >> /etc/my.cnf.d/mysql-server.cnf
systemctl start mysqld

# cluster configuration
mysql -e "create user 'mycluster' identified by '$password'"
mysql -e "grant all privileges on *.* to 'mycluster'@'%' with grant option"
mysql -e "set global group_replication_ip_whitelist = '10.156.0.0/16'"
mysql -e "reset master"
