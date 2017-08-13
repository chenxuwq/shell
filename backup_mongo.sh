#!/usr/bin/env bash
# Used to:   Backup full database mongodb
#------------------------------------------------------------------------------------------------
# Developer:    xu.chen
# Blog:         http://chenxu.info
# Email:        linuxjosery@gmail.com
# Created on:   2017/07/31
# Location:
# Execution:    backup_mongo.sh
# Description:  全备份mongo数据库
# Revision History:
#
# Name             Date            Description
#------------------------------------------------------------------------------------------------
# xu.chen        2017/07/31      Initial Version
#------------------------------------------------------------------------------------------------

dd=`date +%Y-%m-%d`
backup=/mnt/backup/mongo/$dd
rmday=$(date -d '5 day ago' +%Y-%m-%d)

[ -d /mnt/backup/mongo ] || mkdir -p /mnt/backup/mongo

[ ! -f /usr/bin/mongodump ] && exit 1

# Remove 5 day ago backup data
cd /mnt/backup/mongo && [ -f "${rmday}.tgz" ] && rm -fr ${rmday}.tgz

#backup
/usr/bin/mongodump --host 127.0.0.1 --out $backup

[ -d $backup ] && cd `dirname $backup` && tar -czf $dd.tgz $dd && rm -rf $dd
