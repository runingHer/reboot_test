#!/bin/bash

path=$(pwd)
chmod 777 reboot.sh
if [ -n "$1" ]; then
  ./reboot.sh $1 $path
else
  ./reboot.sh 100 $path
fi

