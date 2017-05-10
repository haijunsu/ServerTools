#!/bin/bash
#####
# add local nat from file
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
./bulkRemoveLocalNAT.sh ${1}

# Read lines as array to MAPFILE
readLinesFromFile ${1}

for line in "${MAPFILE[@]}"
do 
  debug "./addLocalNAT.sh ${line}"
  ./addLocalNAT.sh ${line}
done
exit 0
