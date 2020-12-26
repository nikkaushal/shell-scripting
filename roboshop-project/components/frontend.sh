#!bin/bash

COMPONENT=frontend
source components/common.sh

INFO "setup frontend component"
INFO "installing nginx"
yum install nginx -y
