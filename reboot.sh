#!/bin/bash
#set -x

source /etc/profile

add_config=$(cat /etc/rc.local | grep "reboot.sh")
# shellcheck disable=SC2154
if [ ! -d ${run_path}/test_logs ]; then
  mkdir ${run_path}/test_logs
fi
if [ ! -n "$add_config" ]; then
  echo "bash ${run_path}/reboot.sh" >>/etc/rc.local
fi
#重启次数控制
if [ -n "$1" ]; then
  echo $1 >${run_path}/test_logs/count.txt
fi
total_number() {
  count_num=$(cat ${run_path}/test_logs/count.txt)
  count=$(cat ${run_path}/test_logs/date.txt | wc -l)
}
#bit上报功能检验
bit_state_check() {
  bit_state=$(cat /root/apache-tomcat-8.5.23/logs/catalina.out | grep "发送")
  echo -e "$((count + 1)):\t\c" >>${run_path}/test_logs/bit_state.txt
  if [ ! -n "$bit_state" ]; then
    echo "error-----bit state abnormal!" >>${run_path}/test_logs/bit_state.txt
  else
    echo "success-----bit state normal!" >>${run_path}/test_logs/bit_state.txt
  fi
}
#检测网络端口号
net_state_check() {
  net_prot=$(ifconfig | grep "flags=" | awk -F ":" '{print $1}')
  port_num=$(ifconfig | grep "flags=" | awk -F ":" '{print $1}' | wc -l)
  echo -e "$((count + 1)):\t\c" >>${run_path}/test_logs/net_port.txt
  # shellcheck disable=SC2154
  for i in ${net_port};do
    # shellcheck disable=SC2028
    echo "网口${i}已识别！\t\c" >>${run_path}/test_logs/net_port.txt
  done
  echo "网口数量为${port_num}！" >>${run_path}/test_logs/net_port.txt
}
main() {
  echo -e "$((count + 1)):\t\c" >>${run_path}/test_logs/date.txt
  date >>${run_path}/test_logs/date.txt
  sleep 30
#  net_state_check
  sleep 50
  reboot
}
total_number &>/dev/null
if [ $count -lt $count_num ]; then
  main
else
  echo "请使用  ./reboot.sh 10  方式执行该脚本"
  sed -i "s#${add_config}# #g" /etc/rc.local
fi
