#!/bin/bash
#查看内存剩余量
a=`vmstat |grep 0|awk -F " " '{print $4}'`
b=`vmstat |grep 0|awk -F " " '{print $5}'`
c=`vmstat |grep 0|awk -F " " '{print $6}'`
d=`echo $a + $b + $c|bc`
e=`echo $d / 1024|bc`
echo $e M
