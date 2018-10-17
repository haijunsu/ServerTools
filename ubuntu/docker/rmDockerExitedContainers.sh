#!/bin/bash
docker rm $(docker ps -a -q -f status=exited)

docker images | grep -v REPOSITORY| grep "<none>" | awk '{printf("%s\n", $3)}' |xargs docker rmi
