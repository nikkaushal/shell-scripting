#!bin/bash
COMPONENT=catalogue
source components/common.sh

INFO "Set-up catalogue component"
INFO "installing Node JS"
yum install nodejs make gcc-c++ -y  &>>$LOG_FILE
STAT $? "NodeJS Intallation"

INFO "Create Application user"
id roboshop &>>$LOG_FILE
case $? in
  0)
    STAT $? "Application user creation"
  ;;
  1)
    useradd roboshop  &>>$LOG_FILE
    STAT $? "Application user creation"
  ;;
esac

INFO "Downloading catalogue application"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/d62914b9-61e7-4147-ab33-091f23c7efd4/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"

INFO "Extract Artifacts"
mkdir -p /home/roboshop/${COMPONENT}
cd /home/roboshop/${COMPONENT}
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
STAT $? "Artifacts Extract"

INFO "Install nodejs dependencies"
npm install --unsafe-perm &>>$LOG_FILE
STAT $? "NodeJs dependencies installation"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R

INFO "configuring catalogue startup script"
sed -i -e "s/MONGO_DNSNAME/mongo-test.devopsnik.tk/" /home/roboshop/catalogue/systemd.service
STAT $? "startup script configuration"

INFO "Setup systemD service for catalogue"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
STAT $? "Catalogue SystemD Service"

INFO "Starting catalogue service"
systemctl enable catalogue &>>$LOG_FILE
systemctl restart catalogue &>>$LOG_FILE
STAT $? "Catalogue service start"

