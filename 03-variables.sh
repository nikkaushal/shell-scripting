#!bin/bash

COURSE_NAME="DevOps"
echo welcome to $COURSE_NAME training
echo $COURSE_NAME Training timings -6AM
echo $COURSE_NAME triner- nik

#variables can use these characters- a-z, A-Z, 0-9, _
# variable name should not start with a number
#2var is wrong
#var2 is right

#style in variable names
#unix/linux- VARNAME (all in CAPITAL characters)
#java- CamelCase= VarName


#to declare variable front end dynamically, we should use
# 1) command substitution VAR=$(command)
# 2) Arithamatic substitution VAR=$(expression)

DATE=$(date +%F)
echo "Good Morning, today' date is $DATE"
