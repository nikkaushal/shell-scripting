#!bin/bash

COMPONENT=rabbitmq

source components/common.sh

INFO "Erlang is a dependency which is needed for RabbitMQ."
yum list esl-erlang &>>$LOG_FILE
case $? in
  0)
    STAT 0 "erlang installation"
  ;;
  1)
    yum install https://packages.erlang-solutions.com/erlang/rpm/centos/7/x86_64/esl-erlang_22.2.1-1~centos~7_amd64.rpm -y &>>$LOG_FILE
    STAT $? "Erlang is a dependency which is needed for RabbitMQ"
  ;;
esac

INFO "Setup YUM repositories for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
STAT $? "Setup YUM repositories for RabbitMQ"

INFO "Install RabbitMQ server"
yum install rabbitmq-server -y &>>$LOG_FILE
STAT $? "Install RabbitMQ server"

INFO "Start RabbitMQ service"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
STAT $? "Start RabbitMQ service"

INFO "Create roboshop app user in rabbitmq"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
STAT $? "roboshop app user create"
