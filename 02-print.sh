# we csn print a message on screen using two commands in linux
#1. echo -> preferred one. becsue of less syntax
#2. Printf --> have more syntax

echo hellow world
echo Good morningss

#escape sequencing
#\n new line
#\t tab
#\e new color
echo -e "hello, \n\n\twelcome to todays session, \n\n regards,\n nikk"

#colors- Background
# red 31, 41
#green 32, 42
# yellow 33, 43
# blue 34, 44
# msgenta 35, 45
# cyan 36,46

#echo -e "\e[COLmMessage"

echo -e "\e[31mRED Text"
echo -e "\e[32mGREEN Text"
echo -e "\e[33mYELLOW Text"
echo -e "\e[41;33mYELLOW Text on RED"

#color we enable will not be disabled, moves to next line

echo -e "\e[41;33mYELLOW Text on RED\e0m"