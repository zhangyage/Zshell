#!/bin/bash
a=`ssh ceshi.lingbug "ls /home/tomcat/|grep -"`
for i in $a
    do
	mkdir -p /home/lingbugsit/$i/web
	mkdir -p /home/lingbugsit/$i/admin
done
