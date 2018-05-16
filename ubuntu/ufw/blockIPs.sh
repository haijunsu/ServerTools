#!/bin/bash
#####
# Ban IPs from internet
#####

##
# How to call this util
##
usage() {
  echo "Usage: ${0} <filename>"
}

blockIP() {
  ufw deny from $1 to any
  ufw reject out from any to $1
}

# check parameter number
if [ $# -ne 1 ]; then
  usage
  exit 1
fi

# source common labs
source ../../mylibs/commons.sh

# Read lines as array to MAPFILE
readLinesFromFile ${1}

for line in "${MAPFILE[@]}"
do 
  debug "Ban IP: ${line}"
  blockIP ${line}
done
ufw status
exit 0
