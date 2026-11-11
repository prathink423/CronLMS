#!/bin/bash

# startup script
draw_ascii(){
clear
cat << 'EOF'
    ____                 _     __  __ ____  
   / ___|_ __ ___  _ __ | |   |  \/  / ___| 
  | |   | '__/ _ \| '_ \| |   | |\/| \___ \ 
  | |___| | | (_) | | | | |___| |  | |___) |
   \____|_|  \___/|_| |_|_____|_|  |_|____/ 

EOF
}
draw_ascii
echo "[CronLMS] starting"
sleep 0.1


# set variables
echo "[CronLMS] settings variables"
export NEWT_COLORS='
  root=,default 
  window=,default 
  textbox=white,default
  border=white,default
  actmenuitem=black,default

'


# set token
echo "[CronLMS] setting token"
export TOKEN="$(cat token.txt)"

echo "[CronLMS] setting domain"
export DOMAIN="YOUR_DOMAIN"

# clean function
clean(){
echo "[CronLMS] cleaning up"
rm -rf front_page.*
rm -rf courses.*
}

# run function
clean


# fetch the courses list
echo "[CronLMS] fetching course list"
curl -sL -H "Authorization: Bearer $TOKEN" \
  "https://$DOMAIN.instructure.com/api/v1/courses/?per_page=1000" \
  -o coursescurl.json


# format courses
echo "[CronLMS] formatting course list"
jq '.[] | select(.name != null) | {id, name}' coursescurl.json > courses.json
rm -rf coursescurl.json


# prepare items for whiptail
jq -r '.id, .name' courses.json > courses.txt

# append exit button to top of courses.txt
sed -i '1i Exit CronLMS' courses.txt
sed -i '1i 0' courses.txt

# filter out old courses
while read filter; do
  sed -i "/^$filter$/,+1d" courses.txt
done < filter.txt

# show the items in the whiptail
mapfile -t lines < courses.txt
COURSE=$(whiptail --fb --title "CronLMS | SELECT COURSE | CronLMS" --nocancel --menu "Pick a course" 50 100 12 "${lines[@]}" 3>&1 1>&2 2>&3)

echo "[CronLMS] selected course $COURSE"


# check if exit
if [[ $COURSE -eq 0 ]]; then
    clean
    # draw_ascii
    exit 0
fi


# fetch the main page of the course
curl -sL -H "Authorization: Bearer $TOKEN" \
  "https://$DOMAIN.instructure.com/api/v1/courses/$COURSE/front_page" \
  -o front_page.json


# extract only body from course
jq -r .body \
  front_page.json > front_page.html


# render the html
echo "[CronLMS] rendering the html"
w3m -dump front_page.html > front_page.txt

# append to file
sed -i '1i CronLMS | USE TAB TO NAVIGATE | USE ARROW KEYS TO SCROLL' front_page.txt


# display canvas course in whiptail dialog
whiptail --title "CronLMS | Course: $COURSE | CronLMS" --scrolltext --textbox front_page.txt 50 150

# remove leftover files
clean


# rerun the script again
clear
exec "$0" "$@"
