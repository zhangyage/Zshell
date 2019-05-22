#!/bin/bash
#author zhangyage2015@163.com
ps -elf | grep rsync | grep -v grep

if  [ $? == 0 ];then
    echo 'running'
else
    if [ -f "/var/run/rsyncd.pid" ];then
	rm -rf /var/run/rsyncd.pid
    fi
    ip=`ip a s dev eno1 | grep '/24' | awk '{print $2}' | awk -F '/' '{print $1}'`
    rsync --address=$ip --port=10873 --daemon  
fi
