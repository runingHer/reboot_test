#!/bin/bash

echo 0 >reboot_test/count.txt
pid=$(ps -ef | grep reboot.sh | grep -v grep | awk '{print $2}')
kill -9 $pid
