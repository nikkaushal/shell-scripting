#!bin/bash

COMPONENT=frontend
source components/common.sh

INFO "setup frontend component"
INFO "installing nginx"
yum install nginx -y &>>$LOG_FILE
STAT $? "Nginx Installation"
INFO "Downloading Artifacts"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/fdf87296-ccbe-45e5-a615-bc6ecbd78bfe/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"

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
sed -i -e "/catalogue/ s/localhost/catalogue-test.devopsnik.tk/" \
      -e "/cart/ s/localhost/cart-test.devopsnik.tk/" \
      -e "/user/ s/localhost/user-test.devopsnik.tk/" \
      -e "/shipping/ s/localhost/shipping-test.devopsnik.tk/" \
      -e "/payment/ s/localhost/payment-test.devopsnik.tk/" \
     /etc/nginx/default.d/roboshop.conf
STAT $? "Nginx configuration update"

INFO "Start NGINX service"
systemctl enable nginx  &>>$LOG_FILE
#systemctl restart nginx &>>$LOG_FILE
STAT $? "NGINX Service Startup"


