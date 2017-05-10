#!/bin/bash
# Usage: ./findLargeFolders.sh [path]
du -a ${1} | sort -n -r | head -n 10 
