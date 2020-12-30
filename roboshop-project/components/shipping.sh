#!bin/bash

COMPONENT=shipping

source components/common.sh
INFO "Install Maven"
yum install maven -y &>>$LOG_FILE
STAT $? "Install Maven"

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

INFO "Download the shipping applications"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/9c06b317-6353-43f6-81e2-aa4f5f258b2d/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"
INFO "Extract Artifacts"
mkdir -p /home/roboshop/${COMPONENT}
cd /home/roboshop/${COMPONENT}
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
STAT $? "Artifacts extract"

INFO "Compile shipping application"
mvn clean package &>>$LOG_FILE
mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
STAT $? "Shipping compile"

chown roboshop:roboshop /home/roboshop/${COMPONENT} -R
INFO "configuring shipping startup script"
sed -i -e "s/CARTENDPOINT/cart-test.devopsnik.tk/" -e "s/DBHOST/mysql-test.devopsnik.tk/" /home/roboshop/${COMPONENT}/systemd.service
STAT $? "startup script configuration"

INFO "Setup systemD service for shipping"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
STAT $? "user SystemD Service"

INFO "Starting shipping service"
systemctl enable ${COMPONENT} &>>$LOG_FILE
systemctl start ${COMPONENT} &>>$LOG_FILE
STAT $? "shipping service start"


