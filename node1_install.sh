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

sleep 30 # waiting for all instances

mysqlsh -e "dba.configureInstance('mycluster@mysql01',{password:'$password',interactive:false,restart:true})"
mysqlsh -e "dba.configureInstance('mycluster@mysql02',{password:'$password',interactive:false,restart:true})"
mysqlsh -e "dba.configureInstance('mycluster@mysql03',{password:'$password',interactive:false,restart:true})"

<<<<<<< HEAD
sleep 60 # waiting for nodes reconfiguration 

mysqlsh mycluster@mysql01 --password=$password -e "dba.createCluster('mycluster')"
mysqlsh mycluster@mysql01 --password=$password -e "cluster.addInstance('mycluster@mysql02:3306',{password:'$password'})"
mysqlsh mycluster@mysql01 --password=$password -e "cluster.addInstance('mycluster@mysql03:3306',{password:'$password'})"
=======
sleep 30 # waiting as all nodes will be ready 

mysqlsh mycluster@mysql01 --password=$password -e "dba.createCluster('mycluster',{ipWhitelist: '10.156.0.0/16'})"

sleep 30 # creation of cluster

mysqlsh mycluster@mysql01 --password=$password -e "var cluster = dba.getCluster();cluster.addInstance('mycluster@mysql02:3306',{password:'$password',ipWhitelist: '10.156.0.0/16',interactive:false,recoveryMethod:'clone'});"
mysqlsh mycluster@mysql01 --password=$password -e "var cluster = dba.getCluster();cluster.addInstance('mycluster@mysql03:3306',{password:'$password',ipWhitelist: '10.156.0.0/16',interactive:false,recoveryMethod:'clone'});"
>>>>>>> 4002e3e037db5e4a75498094aefec6e17fe02f5a
