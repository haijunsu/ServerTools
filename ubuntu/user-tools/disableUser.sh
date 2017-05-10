#!/bin/bash
# Usage: deleteUser.sh <username> 
#
# This script delete a user and  user's home directory.

usage() {
	echo "Usage: ./deleteUser.sh <username>"
}

if [ "x${1}" = "x" ]; then
	usage
	exit 0
fi
usermod -s /bin/nologin ${1}
exit 0
