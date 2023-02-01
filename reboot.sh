#!/bin/bash
set -x

path=$2
add_config=$(cat /etc/rc.local | grep "reboot.sh")
if [ ! -d ${path}/reboot_test ]; then
  mkdir ${path}/reboot_test
fi

if [ ! -n "$add_config" ]; then
  echo "bash ${path}/reboot.sh" >>/etc/rc.local
fi

if [ -n "$1" ]; then
  echo $1 >${path}/reboot_test/count.txt
fi

total_number() {
  count_num=$(cat ${path}/reboot_test/count.txt)
  count=$(cat ${path}/reboot_test/date.txt | wc -l)
}

main() {
  echo -e "$((count + 1)):\t\c" >>${path}/reboot_test/date.txt
  date >>${path}/reboot_test/date.txt
  sleep 80
  reboot
}
total_number &>/dev/null
if [ $count -lt $count_num ]; then
  main
else
  echo "请使用  ./reboot.sh 10  方式执行该脚本"
  sed -i "s#${add_config}# #g" /etc/rc.local
fi
