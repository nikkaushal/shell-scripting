#!bin/bash
INFO () {
echo -e "[\e[1;34mINFO\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
}

SUCCESS() {
  echo -e "[\e[1;32mSUCCESS\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
}

FAIL (){
echo -e "[\e[1;31mFAILURE\e[0m] [\e[1;35m${COMPONENT}\e[0m]  [\e[1;36m$(date '+%F %T')\e[0m] $1"
}

#verify user is root or not
USER_ID =$(id-u)
case $USER_ID IN
  0)
  true ##nothing to perform so we choose true
  ;;
 *)
   echo -e "\e[1;31m you should be root user to perform this script\e[0m"
   exit 1
   ;;
 esac