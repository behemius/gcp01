#!/bin/bash
sudo yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
sudo yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
sudo yum update -y
sudo yum install -y mysql-server mysql-shell
sudo systemctl start mysqld


password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
mysqladmin --user=root --password="$password" password aaBB@@cc1122
mysql --user=root --password=aaBB@@cc1122 -e "UNINSTALL COMPONENT 'file://component_validate_password';"
mysqladmin --user=root --password="aaBB@@cc1122" password ""