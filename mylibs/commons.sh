#####
# Trap lib
# source: http://stackoverflow.com/questions/64786/error-handling-in-bash
####

####
# Echo masssge with timestamp
####
msg() {
     echo `date "+%Y-%m-%d %H:%M:%S.%N"` - "$1"
}

####
# This method is used to show error line number, custumized error message and return code
# useage:
#      trap 'error ${LINENO}' ERR
#      trap 'error ${LINENO} "my error msg"' ERR
#      trap 'error ${LINENO} "my error msg" 2' ERR
####
error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    msg "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    msg "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  exit "${code}"
}

####
# This method is used to debug scripts. if DEBUG is not set, no message print.
# Useage:
#      DEBUG=on
#      debug "test message" 
####
debug () {
  if [ ! -z "$DEBUG" ]; then
	msg "$*"
  fi
}

####
# Check root user and exit if not
####
checkroot() {
	if [[ $EUID -ne 0 ]]; then
   		msg "This script must be run as root" 
  		exit 1
	fi
}

###
# Read line as array and ignore comment. Trims leading and trailing space in every line.
# Params:
#   1. File name to be read (required)
#   2. Comment delimiter (optional; default: '#'). The line will be ignored if startswith delimiter
###
readLinesFromFile() {
	if [[ -z "$1" ]] || [[ ! -e $1 ]]; then
		msg "File not provided or does not exist."
		return 1
	else
		debug "File to read: $1"
	fi

	commentPattern="\#*"
	[[ -n "$2" ]] && commentPattern="\\$2*"
	[[ -n "$commentPattern" ]] && debug " ... will skip lines and trailing portions of lines beginning with this pattern: '$commentPattern'."

	mapfile -t < $1
	
	let i=0
	for l in "${MAPFILE[@]}"
	do
		l=${l%%$commentPattern}		# Remove trailing portion beginning with delimiter.
		l=${l%%*( )}				# Trim trailing spaces
		l=${l##*( )}				# Trim leading spaces
		if [[ -z "$l" ]]; then		# Remove line if it is empty/blank.
			unset MAPFILE[$i]
		else
			MAPFILE[$i]=$l			# Replace the line we read with its modified version.
		fi
		let i++
	done
	
	return 0
}

