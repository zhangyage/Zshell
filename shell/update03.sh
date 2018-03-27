#!/bin/bash
#切至目标工作目录
cd /home/lingbugsit/

#删除上次更新残余文件
\rm -rf /tmp/upload3/*
#定义反馈文件名
a="检测压缩包完整性。。。"
aa="压缩包不完整-稍后再试。。。"
b="正在打包上传至测试服务器。。。"
ba="关闭tomcat备份文件。。。"
c="正在重启tomcat中。。。"
d="启动成功。。。"
da="啊哦,更新失败啦。。。"
e="正在排队中。。。"
f="只接受zip文件。。。"


#开始更新
echo `date`
cat /tmp/linshi > /tmp/linshi03
lujing=`cat /tmp/linshi03`
for i in $lujing
    do
        if [ -f $i ]
            then
                echo "-----------"
        else
            continue
        fi

        xmname=`echo $i|cut -d "/" -f 2`
        qhname=`echo $i|cut -d "/" -f 3`
	ysname=`echo $i|cut -d "/" -f 4`
	xmbdlj=/home/lingbugsit/$xmname/$qhname/

	if [ -f $xmbdlj/lock ]
            then
                continue
        else
            touch $xmbdlj/lock
        fi


	#删除上次更新残余文件
	cd /tmp/upload3/ && \rm -rf ./* && cd -
	
	cd $xmbdlj && \rm -rf $a $aa $b $ba $c $d $da $e $f
	touch $xmbdlj/$a


	#判断压缩包的完好性
	cd /home/lingbugsit/
	sun=5
	unzip -tq $i || sleep 3
	unzip -tq $i || sleep 8
	unzip -tq $i || sun=3
		if [ 3 -eq $sun ]
		    then
			mv $xmbdlj/$a $xmbdlj/$aa
			exit
		else
			echo "压缩包完整。。。"
		fi

        mv $i /tmp/upload3/ && cd /tmp/upload3/
        unzip -q $ysname
	wjname=`ls | grep -v .zip`
	mv $xmbdlj/$a $xmbdlj/$b
	cd $wjname
	\rm -rf WEB-INF/classes/config/config.properties  WEB-INF/classes/huifubao/*  WEB-INF/classes/fundpool/*  WEB-INF/classes/huichao/*  WEB-INF/classes/yeepay/*  WEB-INF/classes/sina/* WEB-INF/classes/cpcnpay/*  js/common/ueditor/jsp/* WEB-INF/classes/SIMSUN.TTC
	cd .. && \rm -rf $ysname && zip -rmq $ysname $wjname
	ssh root@ceshi.lingbug "mkdir /home/.tomcat/.zip/upload1/{web,admin}"
	scp $ysname ceshi.lingbug:/home/.tomcat/.zip/upload3/$qhname/
	csxmname=`ssh root@ceshi.lingbug "ls /home/tomcat/$xmname/webapps/|grep admin|grep -v .zip|cut -d '-' -f 1"`

	ssh root@ceshi.lingbug "/home/tomcat/$xmname/bin/shutdown.sh"
	#备份原始文件
	mv $xmbdlj/$b $xmbdlj/$ba
	ssh root@ceshi.lingbug "\rm -rf  /home/tomcat/$xmname/webapps/*.zip"
	ssh root@ceshi.lingbug "cd /home/tomcat/$xmname/bak/ && tar zcf beifen-$qhname.tar.gz ../webapps/$csxmname-$qhname/ "

	#覆盖更新文件
	ssh root@ceshi.lingbug "unzip -d /home/.tomcat/.zip/upload3/$qhname -oq /home/.tomcat/.zip/upload3/$qhname/$ysname"
	ssh root@ceshi.lingbug "echo `date` > /home/.tomcat/.zip/upload3/$qhname/$wjname/update"
	mv $xmbdlj/$ba $xmbdlj/$c
	ssh root@ceshi.lingbug "\cp -r /home/.tomcat/.zip/upload3/$qhname/$wjname/* /home/tomcat/$xmname/webapps/$csxmname-$qhname/"
	ssh root@ceshi.lingbug "/home/tomcat/$xmname/bin/one-startup.sh"
	sleep 5
	ssh root@ceshi.lingbug "\rm -rf /home/.tomcat/.zip/upload3/$qhname/*"
		#判断tomcat是否启动成功
		xmdk=`echo $xmname|cut -d "-" -f 2`
		pdwj=`curl -o /dev/null --retry 3 --retry-max-time 8 -s -w %{http_code} ceshi.lingbug:$xmdk/$csxmname-$qhname/`
		if [ 200 -eq $pdwj ]
		    then
			mv $xmbdlj/$c $xmbdlj/$d
		        echo "更新完成。。。"
		elif [ 302 -eq $pdwj ]
		    then
			mv $xmbdlj/$c $xmbdlj/$d
		        echo "更新完成。。。"
		else
			mv $xmbdlj/$c $xmbdlj/$da
		    echo "启动失败-请联系。。。"
		fi	
	echo "-------------------------------------------------------"
	echo "-------------------------------------------------------"
	echo "-------------------------------------------------------"
	rm -rf $xmbdlj/lock
    done
