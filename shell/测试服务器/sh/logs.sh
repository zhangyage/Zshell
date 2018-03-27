#!/bin/bash
#清理tomcat日志
mulu=`ls /home/tomcat|grep -v bak|grep -v lost`
lujing=/home/tomcat
for i in $mulu
        do
                echo " " > $lujing/$i/logs/catalina.out
		\rm -rf `find $lujing/$i/logs/* -ctime +2|grep -v catalina.out`
        done
