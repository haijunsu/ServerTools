#!/bin/bash
# Usage: ./changeTimezone.sh [timezone name]
# default timezone is America/New_York
TIME_ZONE=${1}
if [ "x"${TIME_ZONE} = "x" ]; then
	TIME_ZONE="America/New_York"
fi
TIME_ZONE_FILE="/usr/share/zoneinfo/${TIME_ZONE}"
if [ -e ${TIME_ZONE_FILE} ]; then
	if [ -e "/etc/localtime" ]; then
		rm /etc/localtime
	fi
	ln -s ${TIME_ZONE_FILE} /etc/localtime
else
	echo "Error: Timezone doesn't exist."
fi
