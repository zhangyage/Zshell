#!/bin/bash
#切至目标工作目录
cd /home/lingbugsit/
#遍历文件夹中是否有压缩包上传
find ./* -name "*.zip" > /tmp/linshi
if [ -s /tmp/linshi ]
   then
        echo "开始更新。。。"
else
	echo "`date` , 未检测到文件变动"
        exit
fi

a1=`ps -ef|grep bash|grep update01.sh|grep -v grep|awk '{print $2}'`
a2=`ps -ef|grep bash|grep update02.sh|grep -v grep|awk '{print $2}'`
a3=`ps -ef|grep bash|grep update03.sh|grep -v grep|awk '{print $2}'`

#定义反馈文件名
a="检测压缩包完整性。。。"
aa="压缩包不完整-稍后再试。。。"
b="正在打包上传至测试服务器。。。"
ba="关闭tomcat备份文件。。。"
c="正在重启tomcat中。。。"
d="启动成功。。。"
da="啊哦,更新失败-请联系孙国帅。。。"
e="正在排队中。。。"

cd /home/lingbugsit/.sh/
if [ -z $a1 ]
    then
	echo "使用update01进行更新"
	bash -x update01.sh &> /home/lingbugsit/.sh/logs/update1.log &
#	bash -x update01.sh
elif [ -z $a2 ]
    then
	echo "使用update02进行更新"
	bash -x update02.sh &> /home/lingbugsit/.sh/logs/update2.log &
elif [ -z $a3 ]
    then
	echo "使用update03进行更新"
	bash -x update03.sh &> /home/lingbugsit/.sh/logs/update3.log &
else
	echo "正在排队中。。。"
	lujing=`cat /tmp/linshi`
	for i in $lujing
	    do
	        xmname=`echo $i|cut -d "/" -f 2`
	        qhname=`echo $i|cut -d "/" -f 3`
		ysname=`echo $i|cut -d "/" -f 4`
		xmbdlj=/home/lingbugsit/$xmname/$qhname/
		cd $xmbdlj/ && \rm -rf $a $aa $b $ba $c $d $da $e
		touch $e
	    done
fi
