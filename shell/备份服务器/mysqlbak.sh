#!/bin/bash
route=/home/backup/mysqlbak/
host=192.168.1.200
pass=fangbiandai
mysql -u root -p$pass -h$host -e "show databases;"|grep -v mysql|grep -v performance_schema|grep -v information_schema  > /tmp/sql.tmp
a=`cat /tmp/sql.tmp|grep -v Data`
b=`date "+%Y%m%d"`
mkdir $route$b
for i in $a
        do
                mysqldump -u root -p$pass -h $host $i > $route$b/$i.sql
        done
cd $route
tar zcfv /var/tmp/mysql-$b.tar.gz  $b
\rm -rf `find /var/tmp/* -ctime +7`
