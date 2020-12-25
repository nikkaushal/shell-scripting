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

