#!/bin/bash
read -p "Enter your log group name: " option
log_groups=$(aws logs describe-log-groups | grep "logGroupName" | cut -d ":" -f 2 | sed '$s/.$//')
loggroup_list=($log_groups)
if echo ${loggroup_list[@]} | grep -q -w "$option"; then 
  logstream_name=$(aws logs describe-log-streams --log-group-name $option --log-stream-name-prefix 2020 | grep "logStreamName" | awk -F '[:]' '/logStreamName/ {print $2}' | cut -d "," -f 1 | tr -d '"' | sed 's/ //')
  echo "$logstream_name" >logstream_list.txt
    count=1
    while read logstreamname;
    do
        echo "=======================Started fetching file-$count) $logstreamname logs============================"
        phani_logs=$(aws logs get-log-events --log-group-name $option --log-stream-name "$logstreamname" >$logstreamname.json)
        echo "Fetching the logs of $option and writing to  to $logstreamname.json"
        echo "=======================Ended fetching logs===================================================="
        ((count++))
    done <logstream_list.txt
else 
    echo "please enter the vaild log group name the entered $option is not in Cloudwatch log groups"
fi

