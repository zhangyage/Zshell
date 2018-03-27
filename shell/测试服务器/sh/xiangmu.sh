#!/bin/bash
#查看运行中的项目
ps -ef|grep tomcat|cut -d "=" -f 2|grep -v "root"|cut -d "/" -f 4
a=`ps -ef|grep tomcat|wc -l`
b=`echo "当前总共运行$a个项目"`
echo -e "\e[1;31m$b\e[0m"
