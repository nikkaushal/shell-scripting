#!bin/bash

aws ec2 run-instances \ --launch-template LaunchTemplateId=lt-0a24e440439a9d8a1 \ --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=frontend}]"
