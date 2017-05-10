#!/bin/bash
# Usage: ./listAllUsers.sh 
#
# This script list user's name and derscription which id is greater that 1000 from /etc/hosts.

usage() {
	echo "Usage: ./newuser.sh"
}
awk -F':' '{ if($3 >= 1000) print $0 }' /etc/passwd | cut -d: -f1,5
exit 0
