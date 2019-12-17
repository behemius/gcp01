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
mysqlsh -e "dba.configureInstance('mycluster@mysql01',{password:'$password',interactive:false,restart:true})"

sleep 30 # waiting for first instance

for i in $(seq 2 ${nodes})
    do 
        mysqlsh -e "dba.configureInstance('mycluster@mysql0$i',{password:'$password',interactive:false,restart:true})"
    done

sleep 30 # waiting as all nodes will be ready 

mysqlsh mycluster@mysql01 --password=$password -e "dba.createCluster('mycluster',{ipWhitelist: '10.156.0.0/16'})"

sleep 30 # creation of cluster

for i in $(seq 2 ${nodes})
    do
        mysqlsh mycluster@mysql01 --password=$password -e "var cluster = dba.getCluster();cluster.addInstance('mycluster@mysql0$i:3306',{password:'$password',ipWhitelist: '10.156.0.0/16',interactive:false,recoveryMethod:'clone'});"
    done
