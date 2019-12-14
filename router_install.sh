#!/bin/bash
sudo yum install -y wget
wget https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
sudo yum localinstall -y mysql80-community-release-el8-1.noarch.rpm
sudo yum update -y
sudo yum install -y mysql-router



