#!bin/bash

case $1 in
  launch)
    for component in frontend cart catalogue user rabbitmq reddis payment mysql mongo redis; do
    echo "launching $component spot instances"
    aws ec2 run-instances --launch-template LaunchTemplateId=lt-0a24e440439a9d8a1 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${component}}]" &>>/tmp/instances-launch
   done
   ;;
  routes)
    echo updating routes
  ;;
esac



