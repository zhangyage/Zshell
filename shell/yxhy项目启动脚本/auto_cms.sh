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

#启动命令所在目录  
HOME='/opt/diich-cms'
#端口号，根据此端口号确定PID
PORT=9000

#查询出监听了PORT端口TCP协议的程序  
pid=`netstat -anp|grep $PORT|awk '{printf $7}'|cut -d/ -f1`

#时间
shijian=`date +%Y%m%d-%H%M`


#备份
mv $HOME/diich-cms-1.0-SNAPSHOT.jar /data/bak/diich-cms-1.0-SNAPSHOT.jar-$shijian

#停止服务
kill -9 $pid
rm -rf $pid
echo "kill program use signal 2,pid:$pid"
sleep 10

#启动服务
mv /data/jar/diich-cms-1.0-SNAPSHOT.jar $HOME
cd $HOME
echo "开始启动程式。。。。"
nohup  /usr/local/java/jdk1.8.0_111/bin/java -jar -Dspring.profiles.active=test -Dlog.level.default=error /opt/diich-cms/diich-cms-1.0-SNAPSHOT.jar > myout 2>&1 &
sleep 35
     
npid=`netstat -anp|grep $PORT|awk '{printf $7}'|cut -d/ -f1`
if [ -z "$npid" ]; then
    echo "not find program on port:$PORT"  
    return 0
else
    echo "启动完成。。"
fi
