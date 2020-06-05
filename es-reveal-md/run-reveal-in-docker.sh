#!/bin/bash

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


if [ -z "$1" ] ; then
    echo "Usage:  $0    [-d ]  [-p port_number]  <image name>    [optional command]"
    echo "Missing Docker image id.  exiting"
    exit -1
fi


image_id="$1"


# mount the current directory at /home/jovyan/dev
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
        "$image_id" -d -p $port $@
else
    echo "DEV_MODE=off."
    docker run -it   \
        --shm-size=1gb  \
        -p $port:$port  -p 35729:35729 \
        -v"$working_dir:/home/ubuntu/dev" \
        "$image_id"   -p $port $@
fi
