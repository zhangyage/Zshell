#bin/bash
#--------------------------------------------------------
# 监控系统资源运行主文件
# 使用keepalived监控脚本
# 功能：通过监控系统VIP和运行端口及系统资源切换服务器。
#--------------------------------------------------------
#获取上级目录
VIP="10.3.20.190"
PORT="17001"
SER_BIN_PATH="/home/weblogic/startsh/dxpt"
DOWN_BIN_PATH="/app/weblogic/Oracle/Middleware/user_projects/domains/dxpt_domain/bin"
UNAME="zbdxptwg2"
WL_LOG=/app/logs/dxpt/start_dxpt_domain.log
bash_path="/app/source_program/keep_check_script"
#加载函数信息
function getPid(){
	pid=$(/usr/sbin/lsof -i:17001 |awk '{print $2}' | tail -n 2)  
	echo $pid	
}
#启动服务程序
function start(){
	pid=`getPid`
	#进入服务项目录
	cd $DOWN_BIN_PATH
	if [ "$pid" == "" ]
	then
		log "启动服务进程开始..."
		nohup $DOWN_BIN_PATH/startWebLogic.sh > $WL_LOG &
		log "启动服务进程中,并休眠10秒..."
		sleep 10
	fi
	log "启动服务进程结束..."
}
#停止服务程序
function stop(){
	pid=`getPid`
	#进入服务项目录
        cd $DOWN_BIN_PATH
	if [ "$pid" != "" ]
	then 
		log "停止服务进程开始..."
		nohup $DOWN_BIN_PATH/stopWebLogic.sh > $WL_LOG &
		log "停止服务进程中,并休眠5秒..."
		sleep 5
		pid=`getPid`
		if [ "$pid" != "" ]
		then 
			log "服务进程未被正常结束，删除服务进程..."
			kill -9 $pid
		fi
	fi
	log "停止服务进程结束..."
}
#简易日志记录文件
function log(){
	_logInfo=$1
	_logFile=$bash_path/log/script.log
	echo `date +20'%y-%m-%d %H:%M:%S'`" --> ${_logInfo} " >> ${_logFile} 2>&1
}
log "-=========================================-"
log "检查脚本运行开始..."
#获取本机IP
#ip=$(ifconfig -a | grep "inet addr" | grep -v '127.0.0.1' | awk -F " " '{print $2}' | awk -F: '{print $2}')
#获取是否设定虚拟IP
testVip=$(/sbin/ip a | /bin/grep $VIP)
#获取监控程序线程号
pid=`getPid`
log "获取虚拟IP=${testVip}"
log "获取服务进程号=${pid}"
#虚拟IP空服务进程不为空时关闭监控服务
if [ "$testVip" == "" -a "$pid" != "" ]
then
	log "无虚拟IP时服务进程启动，关闭服务进程..."
	stop
#虚拟IP不为空服务进程空时启动监控服务
elif [ "$testVip" != ""  -a "$pid" == ""  ]
then
	log "有虚拟IP时服务进程未启动，启动服务进程..."
	start
#虚拟IP空服务进程空时备用服务器正常
elif [ "$testVip" == "" -a "$pid" == "" ]
then		
	log "备用服务器正常..."
#虚拟IP不为空服务进程不为空时备用服务器正常
elif [ "$testVip" != "" -a "$pid" != "" ]
then		
	log "主服务器正常..."
fi
log "检查脚本运行结束..."	
log "-=========================================-"
exit 0
