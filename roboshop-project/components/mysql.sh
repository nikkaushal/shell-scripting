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
INFO "Download mysql schema"
DOWNLOAD_ARTIFACT "https://dev.azure.com/DevOps-Batches/f635c088-1047-40e8-8c29-2e3b05a38010/_apis/git/repositories/2235ab8a-3229-47d9-8065-b56713ed7b28/items?path=%2F&versionDescriptor%5BversionOptions%5D=0&versionDescriptor%5BversionType%5D=0&versionDescriptor%5Bversion%5D=master&resolveLfs=true&%24format=zip&api-version=5.0&download=true"

INFO "Load schema"
cd /tmp
unzip -o mysql.zip &>>$LOG_FILE
mysql -u root -ppassword <shipping.sql &>>$LOG_FILE
STAT $? "Schema load"

# mysql_secure_installation
