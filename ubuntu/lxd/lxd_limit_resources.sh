#!/bin/bash

########
# Set limited resources for customer container
# The limited varaiables are hardcode. Need to read from somewhere later.
########

# dispaly how to use this script
usage() {
  echo "Usage: ${0} <container name>" 
}

# check parameter
if [ $# -ne 1 ]; then
  usage
  exit 1
fi

#####
# set resources
# params:
#   1. container name
#   2. resource property name (such as limits.cpu)
#   3. expected value
#####
configRes() {
  if [ $# -ne 3 ]; then
    echo "Wrong parameters!"
    exit 1
  fi
  sh -c "lxc config set $1 $2 $3" lxdadm
}

#####
# set device resources
# params:
#   1. container name
#   2. resource property name (such as limits.cpu)
#   3. expected value
#####
configDeviceRes() {
  if [ $# -ne 3 ]; then
    echo "Wrong parameters!"
    exit 1
  fi
  sh -c "lxc config device set $1 $2 $3" lxdadm
}

configRes $1 "boot.autostart" 1
configRes $1 "limits.cpu" 2
configRes $1 "limits.memory" 4GB
configDeviceRes $1 "root size" 80GB
echo "done"
exit 0
