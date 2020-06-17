#!/bin/bash

docker_image='elephantscale/es-training:prod'
password='bingobob123'
while getopts 'i:p:' OPTION; do
  case "$OPTION" in
    i)
      docker_image="$OPTARG"
      ;;
    p)
      password="$OPTARG"
      ;;
    esac
done
shift "$(($OPTIND -1))"
cmd="$@"

echo "Starting docker image : ${docker_image} ..."

working_dir=$(pwd -P)

## Port mappings  (host --> docker)
##    80   : landing page / noVNC
##  2181 : ZK
##  2222 : SSH
##  4040-4050  : Spark UI
##  6006 : Tensorboard
##  8000 : Grafana
##  8001 : Graphite
##  8080 : Spark master
##  8081 : Spark worker
##  8787 : RStudio
##  8888 : Jupyter
##  9000 : Kafka manager
##  9001 : ZK Web
##  9092 : Kafka
##  10,000 --> 10,100 : custom apps

docker run -it   \
    -v "$working_dir:/home/ubuntu/dev" \
    -v $HOME/datasets:/data \
    -v $HOME/datasets:/home/ubuntu/data \
    -p 80:80 \
    -p 2181:2181 \
    -p 2222:22 \
    -p 3389:3389 \
    -p 4040-4050:4040-4050 \
    -p 6006:6006 \
    -p 8000:8000  \
    -p 8001:8001  \
    -p 8080:8080  \
    -p 8081:8081  \
    -p 8787:8787  \
    -p 8888:8888  \
    -p 9000:9000  \
    -p 9001:9001  \
    -p 9092:9092  \
    -p 10000-10100:10000-10100  \
    -e PASSWORD="$password" \
    "$docker_image" \
    "$@"
