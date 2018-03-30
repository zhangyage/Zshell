#############################################################
#Filae Name:check_server.sh
#Author:zhang
#mail:
#create Time:
#check nginx logs
############################################################
#!/bin/bash
Resettem=$(tput sgr0)
Logfile_path='/root/access.log'
Check_http_status()
{
	Http_status_codes=(`cat access.log  | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}" | awk '{
	if($2>=100&&$2<200)
	    {i++}
        else if($2>=200&&$2<300)
	    {j++}
	else if($2>=300&&$2<400)
            {k++}
	else if($2>=400&&$2<500)
	    {n++}
	else if($2>=500)
	    {p++}}END{
		print i?i:0,j?j:0,k?k:0,n?n:0,p?p:0,n+p+k+j+i
		     }'
			`)
echo -e '\E[33m' "The number of http status [100+]:" ${Resettem} ${Http_status_codes[0]}
echo -e '\E[33m' "The number of http status [200+]:" ${Resettem} ${Http_status_codes[1]}
echo -e '\E[33m' "The number of http status [300+]:" ${Resettem} ${Http_status_codes[2]}
echo -e '\E[33m' "The number of http status [400+]:" ${Resettem} ${Http_status_codes[3]}
echo -e '\E[33m' "The number of http status [500+]:" ${Resettem} ${Http_status_codes[4]}
echo -e '\E[33m' "All request numbers:" ${Resettem} ${Http_status_codes[5]}

}
Check_http_status

Check_http_code()
{
	Http_Code=Http_status_codes=$(cat access.log  | grep -ioE "HTTP\/1\.[1|0]\"[[:blank:]][0-9]{3}" | awk -v total=0 -F '[ ]+' '{
				if ($2!="")
				    {code[$2]++;total++}
				else 
				    {exit}}END{
					print code[404]?code[404]:0,code[403]?code[403]:0,total
					}')
echo -e '\E[33m' "The number of http status [404]:" ${Resettem} ${Http_status_codes[0]}
echo -e '\E[33m' "The number of http status [403]:" ${Resettem} ${Http_status_codes[1]}
echo -e '\E[33m' "All request numbers:" ${Resettem} ${Http_status_codes[2]}
}

Check_http_code
