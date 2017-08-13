#!/usr/bin/env bash
# Used to:   Check the average flow per second
#------------------------------------------------------------------------------------------------
# Developer:    xu.chen
# Blog:         http://chenxu.info
# Email:        linuxjosery@gmail.com
# Created on:   2015/11/27
# Location:
# Execution:    net_width.sh
# Description:  查看本机每秒网络流量
# Revision History:
#
# Name             Date            Description
#------------------------------------------------------------------------------------------------
# xu.chen            2015/11/27      Initial Version
#------------------------------------------------------------------------------------------------


if [ $# -ne 2 ]; then
	 echo "Usage:$0 {ethernet device} {sleep_time}"
         echo "    e.g. $0 eth0 2"
	 exit 10
fi

ETH=$1
NUM=$2
IN_OLD=`cat /proc/net/dev |grep $ETH |awk '{print $2}'`
OUT_OLD=`cat /proc/net/dev |grep $ETH |awk '{print $10}'`

for ((i=1; i<=3; i++)); do
	sleep $NUM
	IN=`cat /proc/net/dev |grep $ETH |awk '{print $2}'`
	OUT=`cat /proc/net/dev |grep $ETH |awk '{print $10}'`

	IN_AVG=$(((IN-IN_OLD)/NUM))
	OUT_AVG=$(((OUT-OUT_OLD)/NUM))
	CT=`date '+%F %H:%M:%S'`

	if [ $IN_AVG -ge 1024 ]; then
		# Show by KB/s
		IN_AVG="$((IN_AVG/1024))"
		OUT_AVG="$((OUT_AVG/1024))"
		echo "$CT IN: $IN_AVG KB/s          IN: $OUT_AVG KB/s"
	else
		# Show by Byte/s
		echo "$CT IN: ${IN_AVG} Byte/s      IN: ${OUT_AVG} Byte/s"
		IN_OLD=$IN
		OUT_OLD=$OUT
	fi
done
exit 0

