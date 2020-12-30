#!bin/bash

COMPONENT=payment

source components/common.sh
INFO "Setup Payment Component"
INFO "installing python3"
yum install python36 gcc python3-devel -y
STAT $? "Install python"

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
INFO "Downlaod payment artifact"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/cd32a975-ee45-4b3b-a08e-8e97c3ca7733/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"

INFO "Extract downloaded artifacts"
mkdir /home/roboshop/${COMPONENT}
cd /home/roboshop/${COMPONENT}
unzip -o /tmp/${COMPONENT}.zip &>>$LOG_FILE
STAT $? "Artifacts extract"

chown roboshop:roboshop /home/roboshop/${COMPONENT} -R &>>$LOG_FILE

INFP "Install python dependencies"
pip3 install -r requirements.txt
STAT $? "Dependencies download"

INFO "configuring payment startup script"
sed -i -e "s/CARTHOST/cart-test.devopsnik.tk/" \
      -e "s/USERHOST/user-test.devopsnik.tk/" \
      -e "s/AMPQHOST/rabbitmq-test.devopsnik.tk/" \
 /home/roboshop/catalogue/systemd.service

USER_UID=${ID-u centos}
USER_GID=${ID-g centos}
sed -i -e "/uid =/ c uid = ${USER_UID}" \
       -e "/gid =/ c gid = ${USER_GID}" \
STAT $? "startup script configuration"

INFO "Setup systemD service for payment"
mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
systemctl daemon-reload
STAT $? "Payment SystemD Service"

INFO "Starting payment service"
systemctl enable ${COMPONENT} &>>$LOG_FILE
systemctl start ${COMPONENT} &>>$LOG_FILE
STAT $? "Payment service start"

