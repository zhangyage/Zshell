#############################################################
#Filae Name:check_server.sh
#Author:zhang
#mail:
#create Time:
#check system info
############################################################
#!/bin/bash
Resettem=$(tput sgr0)
declare -S ssharray
i=0
numbers=""


for script_file in `ls -I "monitor_man.sh" ./`
do
	echo -e "\e[1;35m" "The Script:" ${i} '==>' ${Resettem} $script_file
	ssharray[$i]=$script_file
	#将文件名的值赋给关联数组的键
	#echo ${ssharray[$i]}
	numbers="${numbers} | ${i}"
	i=$((i+1))
done

while true
do 
	read -p "Please input a number [ ${numbers} ]:" execshell
	if [[ ! ${execshell} =~ ^[0-9]+ ]];then
	    exit 0
	fi
	/bin/sh ./${ssharray[$execshell]}
done
