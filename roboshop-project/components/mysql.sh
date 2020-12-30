#!bin/bash

COMPONENT=mysql

source components/common.sh

INFO "Setup mysql yum repo"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
STAT $? "Set up mysql server"

INFO "Install mysql server"
yum remove mariadb-libs -y &>>$LOG_FILE
yum install mysql-community-server -y &>>$LOG_FILE
STAT $? "MySQL installation"

INFO "Start mysql service"
systemctl enable mysqld &>>$LOG_FILE
systemctl start mysqld &>>$LOG_FILE
STAT $? "mysql service startup"

echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'P@Ssw0rd123';
uninstall plugin validate_password;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';" >/tmp/schema.sql

MYSQL_DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}'
)

INFO "Reset mysql password"
echo show databases | mysql -u root -ppassword &>>$LOG_FILE
case $? in
  0)
    STAT 0 "Password reset"
    ;;
  1)
    mysql --connect-expired-password -u root -p${MYSQL_DEFAULT_PASSWORD} </tmp/schema.sql &>>$LOG_FILE
    STAT $? "Password reset"
    ;;
esac
# mysql_secure_installation
