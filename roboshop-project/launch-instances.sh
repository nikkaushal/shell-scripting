#!bin/bash

case $1 in
  launch)
    for component in frontend cart catalogue user rabbitmq shipping payment mysql mongo redis; do
    echo "launching $component spot instances"
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-0a24e440439a9d8a1 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]"
    done
   ;;
  routes)
    echo updating routes
    for component in frontend cart catalogue user rabbitmq shipping payment mysql mongo redis; do
    IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
   echo $component $IP
   sed -e "s/IPADDRESS/${IP}/" -e "s/COMPONENT/${component}/" record.json >/tmp/${component}.json
   aws route53 change-resource-record-sets --hosted-zone-id Z0869909I3INDIN3CQDX --change-batch file:///tmp/${component}.json
   done
  ;;
esac



