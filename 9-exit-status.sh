#!/bin/bash

#every command after its execution maty or may not give output but it gives status in form of a number
#that is called a exit status

# exit states ranges from 0-255
# 0 - global success
#1-255 - partial success/partial failure/failure
# 0-125 is left for users to use, either can be a command or a script

#we can use that number with the help of exit command
# exit 0-125, it is user states

exit 1
