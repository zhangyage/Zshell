#!/bin/sh
year=`date -d "yesterday" +"%Y"`
month=`date -d "yesterday" +"%m"`
day=`date -d "yesterday" +"%d"`
logs_path="/usr/local/nginx/logs"
mv $logs_path/evenaccess.log $logs_path/evenaccess-$year-$month-$day.log
kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
