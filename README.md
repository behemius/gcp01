# gcp01
Google Cloud Terraform project.

It's project which will create Google Cloud MySQL innodb cluster based on Compute Engine.
I will use the smallest possible machines and MySQL community version.
It's just for self development and training purposes. 

Requirements:
-------------
- Cloud - Google Cloud Platform
- Compute Engine VM - There is no possibility to use f1-micro without database tuning (maybe it will be next version), as there is not enough memory to run MySQL 8.0 on default settings. Recommended g1-small (1.7 GB RAM)
- OS - Project is written with using CentOS 8, but it may be modified to any other OS
- MySQL - MySQL 8.0 modules. In my opinion there may be also version 5.7 used. 



Future:
-------
1. Project may be extended for using containers for MySQL 8.0
