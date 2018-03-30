#############################################################
#Filae Name:check_server.sh
#Author:zhang
#mail:
#create Time:
#check nginx server
############################################################
#!/bin/bash
Resettem=$(tput sgr0)
Nginxserver='http://app.izycp.com'
Check_Nginx_server()
{
	Status_code=$(curl -m 5 -s -w %{http_code} ${Nginxserver} -o /dev/null)
	if [ $Status_code -eq 000 -o $Status_code -ge 500 ];then
	    echo -e '\E[32m' "check http server error! Respone Status_code is" $Resettem $Status_code
	else
	    http_content=$(curl -s ${Nginxserver})
	    echo -e '\E[32m' "check http server ok! \n" $Resettem $http_content
	fi
}

Check_Nginx_server
