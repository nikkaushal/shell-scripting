#!bin/bash
INFO () {
echo -e "[\e[1;34mINFO\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
}

SUCCESS() {
  echo -e "[\e[1;32mSUCCESS\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
}

FAIL (){
echo -e "[\e[1;31mFAILURE\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
echo -e "\n Refer log file : $LOG_FILE for more information"
exit 1
}


#verify user is root or not
USER_ID=$(id -u)
case $USER_ID in
  0)
  true ##nothing to perform so we choose true
  ;;
 *)
   echo -e "\e[1;31m you should be root user to perform this script\e[0m"
   exit 1
   ;;
 esac

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

STAT(){
  case $1 in
  0)
    SUCCESS "$2"
    ;;
  *)
    FAIL "$2"
    ;;
  esac
}

DOWNLOAD_ARTIFACT() {
  curl -s -o /tmp/${COMPONENT}.zip $1 &>>LOG_FILE
  STAT $? "Artifact Download"
}