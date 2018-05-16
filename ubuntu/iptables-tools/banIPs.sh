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
  iptables -D INPUT -s $1 -j DROP
  iptables -D OUTPUT -d $1 -j REJECT
  iptables -A INPUT -s $1 -j DROP
  iptables -A OUTPUT -d $1 -j REJECT
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
iptables -L INPUT -v -n
iptables -L OUTPUT -v -n
exit 0
