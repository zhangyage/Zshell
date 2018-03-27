#!/bin/bash
cd /root/sh
read -p "输入项目名称：" a

if [ -z $a ]
    then
        echo "项目名称不可为空"
        exit
else
     echo " "
fi
variable=`date +%a%H%M`
dk=`bash duankou.sh |grep -v 9999|tail -n 1`
dk2=`echo $dk + 5| bc`
dk1=`echo $dk2 - 1| bc`
dk3=`echo $dk2 + 1| bc`
cp -r  /home/tomcat/bak/tomcat-moban/  /home/tomcat/$a-$dk2
sed -i "s/sun1/$dk1/g" /home/tomcat/$a-$dk2/conf/server.xml
sed -i "s/sun2/$dk2/g" /home/tomcat/$a-$dk2/conf/server.xml
sed -i "s/sun3/$dk3/g" /home/tomcat/$a-$dk2/conf/server.xml

echo -e "\n \n" >> /etc/rsyncd/rsyncd.conf
echo "[$a]" >> /etc/rsyncd/rsyncd.conf
echo "path = /home/tomcat/$a-$dk2/webapps/" >> /etc/rsyncd/rsyncd.conf
echo -e "list = no\nread only = no\nignore errors\nauth users = $a\ncomment = ceshi ceshi\nsecrets file = /etc/rsyncd/rsyncd.secrets" >> /etc/rsyncd/rsyncd.conf
echo "$a:$a$variable" >> /etc/rsyncd/rsyncd.secrets
echo "$a:$a$variable" > /home/tomcat/$a-$dk2/bak/pass
echo "http://123.57.20.134:$dk2/$a-web/"
