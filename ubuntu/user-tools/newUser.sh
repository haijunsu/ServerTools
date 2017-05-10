#!/bin/bash
# Usage: newUser.sh <username> [group name]
#
# This script create a user and create user's home directory. It also asks to update user information.

usage() {
	echo "Usage: ./newUser.sh <username> [group name]"
	echo "    Group name is the default group name for user. Default is same as username."
}

USER_GRP=${2}
if [ "x${USER_GRP}" != "x" ]; then
	USER_GRP="-g ${USER_GRP}"
fi

if [ "x${1}" = "x" ]; then
	usage
	exit 0
fi
useradd -m ${USER_GRP} -s /bin/bash ${1}
chfn ${1}
exit 0
