#!/bin/bash
#####
# add local nat from file
#####

##
# How to call this util
##
usage() {
  echo "Usage ${0} <filename>"
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
  debug "./removeLocalNAT.sh ${line}"
  ./removeLocalNAT.sh ${line}
done
exit 0
