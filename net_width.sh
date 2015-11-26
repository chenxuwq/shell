#!/bin/sh
# Show net_width
# Check the average flow per second
# define usage
# net_width.sh   
 
if [ $# -ne 2 ]; then
	 echo "Usage:$0 {ethernet device} {sleep_time}"
     echo "    e.g. $0 eth0 2"
	 exit 10
fi

eth=$1
NUM=$2
IN_OLD=`cat /proc/net/dev |grep $eth |awk '{print $2}'`
OUT_OLD=`cat /proc/net/dev |grep $eth |awk '{print $10}'`

for ((i=1; i<=3; i++)); do
	sleep $NUM
	IN=`cat /proc/net/dev |grep $eth |awk '{print $2}'`
	OUT=`cat /proc/net/dev |grep $eth |awk '{print $10}'`

	IN_AVG=$(((IN-IN_OLD)/NUM))
	OUT_AVG=$(((OUT-OUT_OLD)/NUM))
	CT=`date '+%F %H:%M:%S'`

	# Show by KB 
	# IN_AVG="$((IN_AVG/1024))"
	# OUT_AVG="$((OUT_AVG/1024))"
	# echo "$CT IN: $IN_AVG KB/s      IN: $OUT_AVG KB/s"

	echo "$CT IN: ${IN_AVG} Byte/s      IN: ${OUT_AVG} Byte/s"
	IN_OLD=$IN
	OUT_OLD=$OUT
done 
exit 0

