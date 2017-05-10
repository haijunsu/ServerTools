#!/bin/bash
# Usage: ./findLargeFiles.sh [path]
find ${1} -type f -exec du -Sh {} + | sort -rh | head -n 10
