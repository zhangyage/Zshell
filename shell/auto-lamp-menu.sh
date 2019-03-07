#!/bin/bash
#auto install lamp
#by author zhangyage
#输入对应的编号 会执行对应的安装命令

PS3="select your will exec Menu:"

select i in "Apache" "Mysql" "PHP"

do

case $i in
	Apache)
	echo "Wait install httpd server...."
	echo "安装中。。。"
	;;

	Mysql)
	echo "Wait install mysql server...."
	echo "安装中。。。"
        ;;

	PHP)
	echo "Wait install php server...."
        echo "安装中。。。"
        ;;
esac

done


