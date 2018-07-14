#!/usr/bin/env bash
# WordPress Docker Destroy

docker kill $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
rm -rf backup/*