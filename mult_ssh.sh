#!/bin/sh
# Used to:   Multiple SSH run commands
# You can change the 'COMMAND'

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 {server_file}"
	exit 1
fi

BASE_DIR=`dirname $0`
KEY_FILE='/root/.ssh/ssh-id_rsa'
SERVER_FILE=$1
COMMAND="yum -y install httpd"
USER='root'

# Ensure BASE_DIR exist
test -d ${BASE_DIR} || mkdir -p ${BASE_DIR}

# main body
for HOST in `cat ${SERVER_FILE}`; do 
	echo $HOST:
	ssh -n -i ${KEY_FILE} ${USER}@${HOST} ${COMMAND} 
	echo
done


