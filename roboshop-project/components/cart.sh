#!bin/bash
COMPONENT=cart
source components/common.sh

INFO "Set-up cart component"
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

INFO "Downloading cart application"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/f62a488c-687f-4caf-9e5e-e751cf9b1603/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
INFO "Extract Artifacts"
mkdir -p /home/roboshop/${COMPONENT}
cd /home/roboshop/${COMPONENT}
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
STAT $? "Artifacts extract"

INFO "Install nodejs dependencies"
npm install --unsafe-perm &>>$LOG_FILE
STAT $? "NodeJs dependencies installation"
chown roboshop:roboshop /home/roboshop/${COMPONENT} -R

INFO "configuring cart startup script"
sed -i -e "s/CATALOGUE_ENDPOINT/catalogue-test.devopsnik.tk/" -e "s/REDIS_ENDPOINT/redis-test.devopsnik.tk/" /home/roboshop/${COMPONENT}/systemd.service
STAT $? "startup script configuration"

INFO "Setup systemD service for cart"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
STAT $? "cart SystemD Service"

INFO "Starting cart service"
systemctl enable ${COMPONENT} &>>$LOG_FILE
systemctl start ${COMPONENT} &>>$LOG_FILE
STAT $? "cart service start"