#!/bin/bash
#####
# add remote nat from file
#####

##
# How to call this util
##
usage() {
  echo "Usage: ${0} <filename>"
}

# check parameter number
if [ $# -ne 1 ]; then
  usage
  exit 1
fi

# source common labs
source ../../mylibs/commons.sh

# remove previous NAT settings
./bulkRemoveRemoteNAT.sh ${1}

# Read lines as array to MAPFILE
readLinesFromFile ${1}

for line in "${MAPFILE[@]}"
do 
  debug "./addRemoteNAT.sh ${line}"
  ./addRemoteNAT.sh ${line}
done
