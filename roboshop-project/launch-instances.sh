#!bin/bash

case $1 in
  launch)
    for component in frontend cart catalogue user rabbitmq reddis payment mysql mongo redis; do
    echo "launching $component spot instances"
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-0a24e440439a9d8a1--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instatances-launch
    done
   ;;
  routes)
    echo updating routes
    for component in frontend cart catalogue user rabbitmq reddis payment mysql mongo redis; do
    IP=$(aws ec2 describe-instances --filters Name=tag:Name,Values=${component} Name=instance-state-name,Values=running | jq '.Reservations[].Instances[].PrivateIpAddress')
   echo $component $IP
   done
  ;;
esac



