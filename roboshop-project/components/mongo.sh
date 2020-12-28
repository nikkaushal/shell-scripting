#!bin/bash

COMPONENT=MongoDB

source components/common.sh

INFO "setup MongoDB component"
INFO "set up MongoDB YUM repo"
echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
STAT $? "Repository setup"

INFO "Install MongoDB"
yum install -y mongodb-org &>>$LOG_FILE
STAT $? "MongoDB install"

# systemctl enable mongod
# systemctl start mongod
# /etc/mongod.conf 127.0.0.1 to 0.0.0.0