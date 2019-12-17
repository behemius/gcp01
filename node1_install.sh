#!/bin/bash

# variables
password="Cluster^123"

# mysql installation
sudo su -

sed -i "s/SELINUX=enforcing/SELINUX=permissive/" /etc/sysconfig/selinux 
setenforce 0 # I had problems on creation of cluster level because of SELinux

yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
yum update -y
yum install -y mysql-server mysql-shell
systemctl start mysqld

# cluster configuration
mysql -e "create user 'mycluster' identified by '$password'"
mysql -e "grant all privileges on *.* to 'mycluster'@'%' with grant option"
mysql -e "reset master"

sleep 30 # waiting for all instances

mysqlsh -e "dba.configureInstance('mycluster@mysql01',{password:'$password',interactive:false,restart:true})"
mysqlsh -e "dba.configureInstance('mycluster@mysql02',{password:'$password',interactive:false,restart:true})"
mysqlsh -e "dba.configureInstance('mycluster@mysql03',{password:'$password',interactive:false,restart:true})"

sleep 30 # waiting as all nodes will be ready 

mysqlsh mycluster@mysql01 --password=$password -e "dba.createCluster('mycluster',{ipWhitelist: '10.156.0.0/16'})"

sleep 30 # creation of cluster

mysqlsh mycluster@mysql01 --password=$password -e "var cluster = dba.getCluster();cluster.addInstance('mycluster@mysql02:3306',{password:'$password',ipWhitelist: '10.156.0.0/16',interactive:false,recoveryMethod:'clone'});"
mysqlsh mycluster@mysql01 --password=$password -e "var cluster = dba.getCluster();cluster.addInstance('mycluster@mysql03:3306',{password:'$password',ipWhitelist: '10.156.0.0/16',interactive:false,recoveryMethod:'clone'});"
