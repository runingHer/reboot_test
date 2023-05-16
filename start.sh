#!/bin/bash

path_state=$(cat /etc/profile | grep "run_path")
if [ ! -n "$path_state" ]; then
  echo -e "run_path=\c" >>/etc/profile
  echo $(pwd) >>/etc/profile
fi
chmod 777 reboot.sh
if [ -n "$1" ]; then
  ./reboot.sh $1
else
  ./reboot.sh 100
fi
