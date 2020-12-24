#!bin/bash
#Inputs before execution and those inputs can be loaded by script
#Those values will be loaded by special variables inside shell

#This is the approach taken by most of the commands in the shell
#special variables are $0-$n, $*,$@. $#
#$0 = script name
#$1-n = arguments passed
echo script name = $0
echo first arg =$1
echo second arg= $2