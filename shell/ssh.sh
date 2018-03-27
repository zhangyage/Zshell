#!/bin/bash
clear 
cd /root/ssh_key/
read -p "请输入项目名称：" xianmu_name
read -p "情输入服务器信息（如,web,admin...）：" web_admin
if [ -z $xianmu_name ]
    then
        echo "项目名称不可为空,请重新运行此脚本"
	exit
elif [ -z $web_admin ]
    then
        echo "服务器信息不可为空"
        exit
else
        echo "--------------------------"
fi
xi=`ls /root/ssh_key/project/|grep $xianmu_name`
if [ -z $xi ]
    then
        mkdir /root/ssh_key/project/$xianmu_name
        mkdir /root/ssh_key/project/$xianmu_name/$web_admin
else
    if [ $xi = $xianmu_name ]
        then
            echo "已存在项目"
            xiao=`ls /root/ssh_key/project/$xianmu_name/|grep $web_admin`
            if [ -z $xiao ]
                then
                    mkdir /root/ssh_key/project/$xianmu_name/$web_admin
            else
                    if [ $xiao = $web_admin ]
                        then
                            echo "服务器信息不允许相同"
                            exit
                    else
                        mkdir /root/ssh_key/project/$xianmu_name/$web_admin
                    fi
            fi
    else
        mkdir /root/ssh_key/project/$xianmu_name
        mkdir /root/ssh_key/project/$xianmu_name/$web_admin
    fi
fi
number_01=`date +%s%N`
number_02=`date +%H`
pass_01=$number_01$xianmu_name$number_02$web_admin
echo $pass_01 >> /root/ssh_key/project/$xianmu_name/$web_admin/pass
pass_02=`cat /root/ssh_key/project/$xianmu_name/$web_admin/pass`
ssh-keygen -t rsa -f ~/ssh_key/project/$xianmu_name/$web_admin/id_rsa -N "$pass_02"
down_name=`date +%s`
cd /root/ssh_key/project/$xianmu_name/$web_admin/
cat pass









