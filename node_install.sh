#!/bin/bash
sudo su -
# variables
password="Cluster^123"

# mysql installation
sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/sysconfig/selinux 
setenforce 0 # I had problems on creation of cluster level because of SELinux

yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
yum update -y
yum install -y mysql-server mysql-shell
systemctl enable mysqld
systemctl start mysqld

# cluster configuration
mysql -e "create user 'mycluster' identified by '$password'"
mysql -e "grant all privileges on *.* to 'mycluster'@'%' with grant option"
mysql -e "reset master"
