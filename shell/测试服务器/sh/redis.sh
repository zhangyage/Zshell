#!/bin/bash
#此脚本作用是重启（10.172.7.64）服务器上的redis
host=10.172.7.64

action=$1

if [ -z $1 ]
    then
	echo 'Please enter a reference"start|stop|restart"'
	exit
else
if [ start = $1 ]
    then
	ssh root@$host "service redis start"
elif [ stop = $1 ]
    then
	ssh root@$host "service redis stop"
elif [ restart = $1 ]
    then
	ssh root@$host "service redis restart"
else
	echo 'Support parameters"start|stop|restart"'
fi
fi
