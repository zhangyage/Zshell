#!/bin/bash
#Please use UTF-8 encoding to run
source /etc/profile
#本地tomcat安装路径
tomcat=/home/tomcat-web/
#本地工程路径
targetfile=$tomcat/webapps/ROOT/
#sync服务器模块名称
sync_user=louyiyingshi
#sync文件夹名称
sync_file=louyiyingshi-web

read -p "是否进行备份操作（Y/N）: " beifen
shijian=`date +%Y%m%d-%H%M`
cd $tomcat/bak/
if [[ $beifen = Y ]] || [[ $beifen = y ]]
     then
        echo "进行备份文件操作"
        tar zcfP $shijian.tar.gz ../webapps/ROOT
elif [[ $beifen = N ]] || [[ $beifen = n ]]
     then
        echo "此次更新将不会进行备份.Good luck to you!!!"
else
        echo "您的输入有误，请重新运行此脚本.Thank you!!!"
        exit
fi
rsync -arvzP --password-file=$tomcat/bin/pass --exclude-from=$tomcat/bin/nofile.list $sync_user@sync.lingbug.com::$sync_user/$sync_file/ $targetfile
echo $shijian >> $tomcat/bin/update

#test
