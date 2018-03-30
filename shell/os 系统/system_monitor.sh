#############################################################
#Filae Name:check_server.sh
#Author:zhang
#mail:
#create Time:
#check system info
############################################################
#!/bin/bash
clear
if [[ $# -eq 0 ]];then
#Define Variable reset_terminal
reset_terminal=$(tput sgr0)

#Check OS Type
	os=$(uname -o)
  	echo -e '\E[33m' "OS Type:" ${Resettem} $os
#Check OS Release Version and Name
	os_name=$(cat /etc/issue | head -n 1)
  	echo -e '\E[33m' "OS Release Version and Name:" ${Resettem} $os_name
#Check Architecture
	architecture=$(uname -m)
  	echo -e '\E[33m' "Architecture:" ${Resettem} $architecture
#Check Kernel Realese
        kernel=$(uname -r)
  	echo -e '\E[33m' "Kernel Realese:" ${Resettem} $kernel
#Check hostname
	hostname=$(hostname)
  	echo -e '\E[33m' "Hostname:" ${Resettem} $hostname
#Check Internal IP
	internalip=$(hostname -I)
  	echo -e '\E[33m' "Internal IP:" ${Resettem} $internalip
#Check External IP
	externalip=$(curl -s http://ipecho.net/plain)
  	echo -e '\E[33m' "External IP:" ${Resettem} $externalip
#Check DNS
	nameserver=$(cat /etc/resolv.conf | grep -E "\<nameserver[ ]+" |awk '{print $NF}')
  	echo -e '\E[33m' "DNS:" ${Resettem} $nameserver
#Check if connected to Internet or not
	echo -e '\E[33m' "Internet status:" $(ping -c 2 www.baidu.com &> /dev/null && echo "Internet:Connected" || echo"Internet:Disconnectd")
#Check Logged In Users
	who>/tmp/who
	echo -e '\E[33m' "Logged In Users" && cat /tmp/who
        rm -rf /tmp/who

######################################################################
#mem userages
	system_mem_userages=$(cat /proc/meminfo | awk '/MemTotal/{total=$2}/MemFree/{free=$2}END{print (total-free)/1024}')
	echo -e '\E[33m' "system memuserages:" ${Resettem} $system_mem_userages
	apps_mem_userages=$(cat /proc/meminfo | awk '/MemTotal/{total=$2}/MemFree/{free=$2}/^Buffers/{buffer=$2}/^Cached/{cache}END{print (total-free-buffer-cache)/1024}')
	echo -e '\E[33m' "apps memuserages:" ${Resettem} $apps_mem_userages

	loadaverge=$(top -n 1 -b | grep "load average" | awk '{print $10 $11 $12}')
	echo -e '\E[33m' "CPU load averge:"${Resettem} $loadaverge


	diskaveg=$(df -h | grep -vE 'Filesystem|tmpfs' | awk '{print $1 "     " $5}')
	echo -e '\E[33m' "Disk users averge:"${Resettem} $diskaveg
fi
