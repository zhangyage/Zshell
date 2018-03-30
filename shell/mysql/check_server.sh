#############################################################
#Filae Name:check_server.sh
#Author:zhang
#mail:
#create Time:
#check nginx server
############################################################
#!/bin/bash
Resettem=$(tput sgr0)
#监控的从节点地址
Mysql_Slave_Server='192.168.75.16'
Mysql_User='rep'
Mysql_Pass='123456'
Check_Mysql_server()
{
	nc -z -w2 ${Mysql_Slave_Server} 3306 &> /dev/null
	if [ $? -eq 0 ]; then
	    echo "Connect ${Mysql_Slave_Server} Ok!"
	    mysql -u${Mysql_User} -h${Mysql_Slave_Server} -p${Mysql_Pass} -e "show slave status\G;" | grep "Slave_IO_Running" | awk '{if($2!="Yes"){print "Slave thread not running!";exit 1}}'
	    if [ $? -eq 0 ];then
	        mysql -u${Mysql_User} -h${Mysql_Slave_Server} -p${Mysql_Pass} -e "show slave status\G;" | grep "Seconds_Behind_Master" 
	    fi	
	else
	   echo "Connect ${Mysql_Slave_Server} error!"
	fi
}
Check_Mysql_server

