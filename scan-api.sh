#!/bin/sh

set -e


api_url=$API_URL
api_token=$API_TOKEN
username=$USERNAME
password=$PASSWORD

## GET PRIVATE IPS
private_IP= aws ec2 describe-instances --query "Reservations[*].Instances[*].PrivateIpAddress" --output=text  | sed 's/[^ ][^ ]*/"&"/g'| sed 's/.*/[&]/' | paste -sd, -

echo "${private_IP}"

body=$(cat <<EOF
{
	"api_token":"1234567890",
        "name":"api_job",
        "description":"api job",
        "target_map":{"local":"${private_IP}[*]"},
        "credentials":{"W":{"username":"$USERNAME","password":"$PASSWORD"}},
        "scanpolicy_id":2,
        "schedule":{"start_date":"2014-03-20","end_date":"2014-03- 20","time":"12:15","schedule":{"scanTime":"12:15","startDate":"2014-03-20","endDate":"2014-03-20","repeatPeriod":"monthly","repeatInterval":1,"monthlyByWeek":1,"weekOfMonth":3,"dayOfWeekOfMonth":4,"endsNever":1,"endsAfterOccurences":0,"endsBeforeDate":0}
	
}
EOF
)


## POST TO WEB API

#curl -i -H "Accept:application/json" -H "Content-Type:application/json" -X POST --data "$body" "http://dummy.restapiexample.com/api/v1/create"
curl -i -H "Accept:application/json" -H "Content-Type:application/json" -X POST --data "$body" "$api_url":"$port"/resouce?api_token="$api_token"
