# gcp01
Google Cloud Terraform project.

It's project which will create Google Cloud MySQL innodb cluster based on Compute Engine.
I will use the smallest possible machines and MySQL community version.
It's just for self development and training purposes. 

As result you may connect to InnoDB cluster using public IP of MySQL router and port 3306 (R/W access) or 3307 (R/O access)

 
Requirements:
-------------
- Cloud - Google Cloud Platform
- Compute Engine VM - There is no possibility to use f1-micro without database tuning (maybe it will be next version), as there is not enough memory to run MySQL 8.0 on default settings. Recommended g1-small (1.7 GB RAM)
- OS - Project is written with using CentOS 8, but it may be modified to any other OS
- MySQL - MySQL 8.0 modules. In my opinion there may be also version 5.7 used. 



Future improvements:
-------
1. Project may be extended for using containers for MySQL 8.0
2. Securing all ports
3. Elimination 'sleep' commands in scripts
4. Putting passwords into terraform vault
5. Support more nodes than 9 
6. More clean terraform code
7. Logging and tracing errors


Additional notes:
-----------------
In case you need change temporary MySQL password after installation, I found nice bash example:

password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
mysqladmin --user=root --password="$password" password aaBB@@cc1122
mysql --user=root --password=aaBB@@cc1122 -e "UNINSTALL COMPONENT 'file://component_validate_password';"
mysqladmin --user=root --password="aaBB@@cc1122" password ""

Useful commands:
----------------

mysqlsh mycluster@mysql01

MySQL Shell:
var cluster = dba.getCluster();
cluster.status();
dba.dropMetadataSchema();
cluster.dissolve({force:true});

MySQL SQL:
select @@port
select @@hostname
