#!bin/bash
COMPONENT=user
source components/common.sh

INFO "Set-up user component"
INFO "installing Node JS"
yum install nodejs make gcc-c++ -y  &>>$LOG_FILE
STAT $? "NodeJS Intallation"

INFO "Create Applicat ion user"
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

INFO "Downloading user application"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/8cd1d535-7b52-4823-9003-7b52db898c08/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
INFO "Extract Artifacts"
mkdir -p /home/roboshop/${COMPONENT}
cd /home/roboshop/${COMPONENT}
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
STAT $? "Artifacts extract"

INFO "Install nodejs dependencies"
npm install --unsafe-perm &>>$LOG_FILE
STAT $? "NodeJs dependencies installation"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R

INFO "configuring user startup script"
sed -i -e "s/MONGO_ENDPOINT/mongo-test.devopsnik.tk/" -e "s/REDIS_ENDPOINT/redis-test.devopsnik.tk/" /home/roboshop/${COMPONENT}/systemd.service
STAT $? "startup script configuration"

INFO "Setup systemD service for user"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
STAT $? "user SystemD Service"

INFO "Starting user service"
systemctl enable ${COMPONENT} &>>$LOG_FILE
systemctl restart ${COMPONENT} &>>$LOG_FILE
STAT $? "user service start"