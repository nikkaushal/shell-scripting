#!/bin/bash

#assign a name to date is variable
#assing a name to a group pf commands is function
#way1
function SAMPLE() {
  echo Hello from sample function
  a=10
  echo B=$b

#way2

SAMPLE1() {
  echo hello from function sample1
}
#function name standards are as same as variable in bash shell

#call a function in main program
b=20
SAMPLE
SAMPLE1
echo A =$a

#declare variable in main program, you can access in function and vice-versa

#you delcare a variable in main program and you can overwrite variable in function and vice-versa

