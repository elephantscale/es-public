#!/bin/bash

## This is the master copy.
## If any changes are made, also copy it into `es-public/es-reveal-md' 

## invoke with '-d' for dev mode
## this will mount utils directory from host for live debugging

port=2000

while getopts 'dp:' OPTION; do
  case "$OPTION" in
    d)
      dev_mode="yes"
      ;;
    p)
      port=$OPTARG
      ;;
    esac
done
shift "$(($OPTIND -1))"

docker_image="elephantscale/es-reveal-md:prod"
if [ "$1" ] ; then 
	docker_image=$1
fi

echo "starting docker image : $docker_image"


# mount the current directory at /home/jovyan/work
me="${BASH_SOURCE-$0}"
mydir=$(cd -P -- "$(dirname -- "$me")" && pwd -P)
#mydir=$(realpath $(dirname -- "$me"))
working_dir=$(pwd -P)

## figure out utils dir
#utils_dir=$(realpath "$mydir/..")
utils_dir=$(cd $mydir/.. && pwd -P)
## do we have the full es-utils dir?
if [ -f "${utils_dir}/.es_utils_home" ] ; then
    found_es_utils="yes"
fi

echo "port : $port"
if [ "$found_es_utils" = "yes" -a "${dev_mode}" = "yes" ] ; then
    echo "DEV_MODE=on.  Mounting local utils"
    docker run -it   \
        --shm-size=1gb  \
        -p $port:$port -p 35729:35729 \
        -v"$working_dir:/home/ubuntu/dev" \
        -v"$utils_dir:/home/ubuntu/utils" \
        "$docker_image" -d -p $port $@
else
    echo "DEV_MODE=off."
    docker run -it   \
        --shm-size=1gb  \
        -p $port:$port  -p 35729:35729 \
        -v"$working_dir:/home/ubuntu/dev" \
        "$docker_image"   -p $port $@
fi
