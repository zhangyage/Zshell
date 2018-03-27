#!/bin/bash
cd /home/lingbugsit/
find ./* -name "*.*" -print|grep -v ".zip" > /tmp/linshi2

#判断有没有rar文件
f="只接受zip文件。。。"
ifrar=`cat /tmp/linshi2|grep .rar`
if [ -z $ifrar ]
   then
        echo "还好没有rar文件，否则。。。"
else
	for i in $ifrar
	    do
		xmname=`echo $i|cut -d "/" -f 2`
	        qhname=`echo $i|cut -d "/" -f 3`
		xmbdlj=/home/lingbugsit/$xmname/$qhname/
		touch $xmbdlj/$f
		\rm -rf $i
	    done
fi

#开始更新文件
cat /tmp/linshi2|grep -v ".rar"|grep -v for.sh > /tmp/linshi3
if [ -s /tmp/linshi3 ]
   then
        echo "更新开始。。。"
else
	echo "没有检测到文件`date`"
        exit
fi

wjlj=`cat /tmp/linshi3`
for i in $wjlj
    do	
	echo ==================================================
	echo ==================================================
	echo ==================================================
	echo "开始更新 $i"
	xmname=`echo $i|cut -d "/" -f 2`
	qhname=`echo $i|cut -d "/" -f 3`
	wjname=`echo $i|sed 's#/.*/#/#'|cut -d "/" -f 2`
	csxmname=`ssh root@ceshi.lingbug "ls /home/tomcat/$xmname/webapps/|grep admin|grep -v .zip|cut -d '-' -f 1"`
	cswjlj=`ssh ceshi.lingbug "find /home/tomcat/$xmname/webapps/$csxmname-$qhname/* -name '$wjname'"`
	sun=3
		echo "判断文件唯一性"
		cswj01=`echo $cswjlj|cut -d " " -f 1`
		cswj02=`echo $cswjlj|cut -d " " -f 2`
		cswj03=`echo $cswjlj|cut -d " " -f 3`
		if [ $cswj01 = $cswj02 ]
		    then
			echo "文件唯一。。。。。。"
		else
			rm -rf /home/lingbugsit/.sh/compare/server/01/*
			rm -rf /home/lingbugsit/.sh/compare/server/02/*
			rm -rf /home/lingbugsit/.sh/compare/server/03/*
			rm -rf /home/lingbugsit/.sh/compare/local/*
			if [ -z $cswj03 ]
    			    then
				cd /home/lingbugsit/.sh/compare/
				scp ceshi.lingbug:$cswj01 /home/lingbugsit/.sh/compare/server/01/
				scp ceshi.lingbug:$cswj02 /home/lingbugsit/.sh/compare/server/02/
				cp /home/lingbugsit/$i local/
				cswjname01=`echo $cswj01|sed 's#/.*/#/#'|cut -d "/" -f 2`
				cswjname02=`echo $cswj02|sed 's#/.*/#/#'|cut -d "/" -f 2`
				cswjdx01=`ls -l server/01/$cswjname01|awk '{print $5}'`
				cswjdx02=`ls -l server/02/$cswjname02|awk '{print $5}'`
				bdwjdx=`ls -l local/$wjname|awk '{print $5}'`
				bj01=`echo $bdwjdx-$cswjdx01|bc|cut -d "-" -f 2`
				bj02=`echo $bdwjdx-$cswjdx02|bc|cut -d "-" -f 2`
					if [ $bj01 -lt $bj02 ]
					    then
						echo "正在上传 $wjname 到测试服务器的 $cswj01 "
						scp /home/lingbugsit/$i ceshi.lingbug:$cswj01
						sun=5
					elif [ $bj01 -gt $bj02 ]
					    then
						echo "正在上传 $wjname 到测试服务器的 $cswj02 "
						scp /home/lingbugsit/$i ceshi.lingbug:$cswj02
						sun=5
					else
						echo "遇到重名且大小相等文件，无法判断退出脚本"
						exit
					fi
			elif [ -n $cswj03 ]
			    then
				cd /home/lingbugsit/.sh/compare/
                                scp ceshi.lingbug:$cswj01 /home/lingbugsit/.sh/compare/server/01/
                                scp ceshi.lingbug:$cswj02 /home/lingbugsit/.sh/compare/server/02/
                                scp ceshi.lingbug:$cswj03 /home/lingbugsit/.sh/compare/server/03/
                                cp /home/lingbugsit/$i local/
                                cswjname01=`echo $cswj01|sed 's#/.*/#/#'|cut -d "/" -f 2`
                                cswjname02=`echo $cswj02|sed 's#/.*/#/#'|cut -d "/" -f 2`
                                cswjname03=`echo $cswj03|sed 's#/.*/#/#'|cut -d "/" -f 2`
                                cswjdx01=`ls -l server/01/$cswjname01|awk '{print $5}'`
                                cswjdx02=`ls -l server/02/$cswjname02|awk '{print $5}'`
                                cswjdx03=`ls -l server/03/$cswjname03|awk '{print $5}'`
                                bdwjdx=`ls -l local/$wjname|awk '{print $5}'`
                                bj01=`echo $bdwjdx-$cswjdx01|bc|cut -d "-" -f 2`
                                bj02=`echo $bdwjdx-$cswjdx02|bc|cut -d "-" -f 2`
                                bj03=`echo $bdwjdx-$cswjdx03|bc|cut -d "-" -f 2`
				bjzx=`echo -e "$bj01\n$bj02\n$bj03"|sort|head -n 1`
					if [ $bjzx -eq $bj01 -a $bjzx -ne $bj02 ]
					    then
						echo "正在上传 $wjname 到测试服务器的 $cswj01 "
						scp /home/lingbugsit/$i ceshi.lingbug:$cswj01
						sun=5
					elif [ $bjzx -eq $bj02 -a $bjzx -ne $bj03 ]
					    then
						echo "正在上传 $wjname 到测试服务器的 $cswj02 "
						scp /home/lingbugsit/$i ceshi.lingbug:$cswj02
						sun=5
					elif [ $bjzx -eq $bj03 -a $bjzx -ne $bj01 ]
					    then
						echo "正在上传 $wjname 到测试服务器的 $cswj03 "
						scp /home/lingbugsit/$i ceshi.lingbug:$cswj03
						sun=5
					else
					    echo "遇到重名且大小相等文件，无法判断退出脚本"
					fi
			else
				echo "我都写懵逼啦。。。。。。。。"
			fi
		fi


	echo "正在上传文件 $xmname"
		if [ $sun -eq 3 ]
			then
			    echo "正在上传文件 $wjname 到测试服务器的 $cswjlj "
			    scp $i ceshi.lingbug:$cswjlj
		elif [ $sun -eq 5 ]
			then
			    echo "我都写懵逼啦。。。 "
		else
			    echo "我都写懵逼啦。。。 "
		fi
	cd /home/lingbugsit/
	rm -rf $i $f
    done
sun=`cat /tmp/linshi2 |grep -v .js|grep -v .css|grep -v .jsp|grep -v .png|grep -v .jpg|grep -v .PNG|grep -v .JPG|cut -d "/" -f 2|sort -u`
if [ -z $sun ]
   then
	echo "没有检测到静态文件"
	exit
else
	echo "检测到文件有改动，执行重启"
fi
for i in $sun
    do
	echo "关闭 $i 项目"
	ssh root@ceshi.lingbug "/home/tomcat/$i/bin/shutdown.sh"
	echo "启动 $i 项目"
	sleep 5
	ssh root@ceshi.lingbug "/home/tomcat/$i/bin/one-startup.sh"
    done
