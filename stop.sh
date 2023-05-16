#!/bin/bash

source /etc/profile
pid=$(ps -ef | grep reboot.sh | grep -v grep | awk '{print $2}')
kill -9 $pid
# shellcheck disable=SC2154
sed -i "s#run_path=${run_path}# #g" /etc/profile
