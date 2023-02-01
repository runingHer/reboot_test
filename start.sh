#!/bin/bash

path=$(pwd)
chmod 777 reboot.sh
while [ 1 ]; do
  if [ -n "$1" ]; then
    ./reboot.sh $1 $path
    break
  else
    ./reboot.sh 100 $path
  fi
done
