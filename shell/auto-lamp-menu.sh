#!/bin/bash
#auto install lamp
#by author zhangyage
#输入对应的编号 会执行对应的安装命令


#函数定义，使用的时候填写命令
function apache_install()
{
	echo "apache正在安装"
}
function mysql_install()
{
	echo "mysql正在安装"
}
function php_install()
{
	echo "php正在安装"
}

#菜单定义
PS3="select your will exec Menu:"

select i in "Apache" "Mysql" "PHP"

do

case $i in
	Apache)
	echo "Wait install httpd server...."
	apache_install
	;;

	Mysql)
	echo "Wait install mysql server...."
	mysql_install
        ;;

	PHP)
	echo "Wait install php server...."
        php_install
        ;;
esac

done
