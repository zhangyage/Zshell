#!/bin/bash 
#auto backup mysql db
#by author zhangyage

BAK_DIR=/data/backup/`date +%Y%m%d`
MYSQLDB=NBA
MYSQLUSR=root
MYSQLPW=Yxhy1234
MYSQLCMD=mysqldump


if [ $UID -ne 0 ];then
	echo "Must to be use root for exec shell."
	exit
fi

if [ ! -d $BAK_DIR ];then
	mkdir -p $BAK_DIR
        echo -e "\033[32mThe $BAK_DIR Create Successful!"
else
	echo "This $BAK_DIR is exits..."
fi

$MYSQLCMD -R -u$MYSQLUSR -p$MYSQLPW  $MYSQLDB > $BAK_DIR/$MYSQLDB.sql

if [ $? -eq 0 ];then
	echo -e "\033[32mThe Mysql backup $MYSQLDB Successfully!" 
else
	echo -e "\033[32mThe Mysql backup $MYSQLDB Failed,please check."
fi
