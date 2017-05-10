#!/bin/bash
# Usage: ./findLargeFolders2.sh [path]
du -Sh ${1} | sort -rh | head -10
#du -hs ${1}* | sort -rh | head -n 10 
