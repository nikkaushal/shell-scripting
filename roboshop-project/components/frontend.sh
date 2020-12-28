#!bin/bash

COMPONENT=frontend
source components/common.sh

INFO "setup frontend component"
INFO "installing nginx"
yum install nginx -y &>>$LOG_FILE
STAT $? "Nginx Installation"
INFO "Downloading Artifacts"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f4b641c1-99db-46d1-8110-5c6c24ce2fb9/_apis/git/repositories/a781da9c-8fca-4605-8928-53c962282b74/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"

INFO "Remove old artifacts"
rm -rvf /usr/share/nginx/html/* &>>$LOG_FILE
STAT $? "Artifact Removal"

INFO "Extract Artifact Archive"
cd /usr/share/nginx/html
unzip -o /tmp/frontend.zip &>>$LOG_FILE
mv static/* .
STAT $? "Artifact extract successfull"
rm -rf static README.md #not really needed, those files will not harm anything

INFO "Update Nginx configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $? "Nginx configuration update"

INFO "Start NGINX service"
systemctl enable nginx  &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $? "NGINX Service Startup"


