#!/bin/bash
################################################################
# this script function is :                		       #		
#                                                              #
# USER         YYYY-MM-DD - ACTION      mail                   #
# zhangyage    2018-07-25 - CREATED     zhangyage2015@163.com  # 
#                                                              #  
################################################################

parasnum=0
# function
help_msg()
{
cat << help
+----------------------------------------------------+
+ Error Cause:
+ you enter $# parameters
+ the total paramenter number must be $parasnum
+ 1st :DOCKER_NAME
+ 2nd :PROJECT_NAME
+ 3rd :PROJECT_VERSION
+ 4th :SOURCE_PORT
+ 5th :DESTINATION_PORT
+----------------------------------------------------+
help
}

# ----------------------------------------------------
# Check parameter number
# ----------------------------------------------------
if [ $# -ne ${parasnum} ]
then
        help_msg 
        exit
fi

# ----------------------------------------------------
# Initialize the parameter.
# ----------------------------------------------------
#PROJECT_NAME=$1


export JAVA_HOME=/usr/local/java/jdk1.8.0_111
TOMCAT_PID=`ps -aux | grep yxhy-9090 | grep -v grep | awk '{print $2}'`
TOMCAT_DIR="/opt/yxhy-9090"
FILE="diich-web-biz-1.0-SNAPSHOT.war"
SOURCE_DIR="/data/war"


echo "解压war包"
cd $SOURCE_DIR
jar -xvf $FILE

echo "备份原有项目"
cd $TOMCAT_DIR/bak
shijian=`date +%Y%m%d-%H%M`
echo "进行备份文件操作"
tar zcfP $shijian.tar.gz ../webapps/ROOT
echo "备份完成"

echo "stop tomcat"
[ -n "$TOMCAT_PID" ] && kill -9 $TOMCAT_PID

echo "sync dirs"
rsync -arvzP --exclude-from=/data/script/nofile.list /data/war/ /opt/yxhy-9090/webapps/ROOT
echo "sync successful"

echo "清空仓库"
cd $SOURCE_DIR
rm -rf *

echo "start tomcat"
cd $TOMCAT_DIR;rm -rf work
/bin/sh $TOMCAT_DIR/bin/startup.sh
sleep 15
tail -n 50 $TOMCAT_DIR/logs/catalina.out


