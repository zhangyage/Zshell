#!/bin/bash

for i in `cat list.txt`
do
	#关闭tomcat
	ssh root@$i "/home/tomcat/bin/shutdown.sh"
	#删除缓存文件
	ssh root@$i "cd /home/tomcat/work/ && rm -rf ./*"
	#启动tomcat
	ssh root@$i "/home/tomcat/$xmname/bin/one-startup.sh"
done

sleep 5

#检查服务器的启动情况
for j in `cat list.txt`
do
	pdwj=`curl -o /dev/null --retry 3 --retry-max-time 8 -s -w %{http_code} $j`
		if [ 200 -eq $pdwj ]
		    then
		        echo $j:"启动成功。。。"
		elif [ 302 -eq $pdwj ]
		    then
			    echo $j:"启动成功。。。"
		else
		    echo "启动失败-请联系。。。"
		fi	
done



