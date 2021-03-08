#!/bin/bash

###
# Attach an interface to a guest
###

usage() {
  echo `basename ${0}` "<domain name> <type> <source> <model> <mac>"
}

if [[ $# < 5 ]]; then
  usage
  echo Total $#
  exit 0
else
  # usage()
  echo `basename ${0}` "<domain name> <type> <source> <model> <mac>"
fi

DOMAIN=$1

#sudo virsh attach-interface --domain ssh-proxy --type direct --source em1 --model e1000 --config --live --mac ba:cb:0b:6d:2c:b2
