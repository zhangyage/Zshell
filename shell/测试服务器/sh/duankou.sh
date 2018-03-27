#/bin/bash
#查看项目端口占用情况
ls /home/tomcat|grep -|cut -d "-" -f 2|sort
