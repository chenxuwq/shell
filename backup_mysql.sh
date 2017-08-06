#!/bin/env bash
# Used to:   Backup full database and backup every table at 2:00
#------------------------------------------------------------------------------------------------
# Developer:    xu.chen
# Blog:         http://chenxu.info
# Email:        linuxjosery@gmail.com
# Created on:   2017/07/31
# Location:
# Execution:    backup_mysql.sh
# Description:  全备份MySQL数据库和单独备份每张表
# Revision History:
#
# Name             Date            Description
#------------------------------------------------------------------------------------------------
# xu.chen        2017/07/31      Initial Version
#------------------------------------------------------------------------------------------------

#if [ $# -ne 1 ]; then
#       echo "Usage:$0 {full_dump|tb_dump}"
#fi

bak_dir='/mnt/backup/mysql'
tmp_dir="/tmp/`basename $0`"
today=$(date +%Y-%m-%d)
rmday=$(date -d '5 day ago' +%Y-%m-%d)
mode=$1
mysql_user='backup'
mysql_pw='B@ckup.123com'
#mysql_user='root'
#mysql_pw='Datahub0201#'

#exclude default databases
exclude_db='(database|sys|mysql|information_schema|performance_schema|report$)'
mysql_ping="$(/usr/bin/mysqladmin -u${mysql_user} -p${mysql_pw} ping 2>> /dev/null)"

[[ -f "/usr/bin/mysql" ]] && [[ -f "/usr/bin/mysqldump" ]] || exit 3
[[ ${mysql_ping} == 'mysqld is alive' ]] || exit 4

[ -d "$tmp_dir" ] || /bin/mkdir -p ${tmp_dir}

function full_dump()
{
    # Remove last full backup data
    cd ${bak_dir} && rm -fr ${rmday}_$mode.tar.bz2
    # Backup all database
    /usr/bin/mysqldump -u${mysql_user} -p${mysql_pw} --all-databases --opt > ${today}_$mode.sql 2>> /dev/null
    cd ${bak_dir} && /bin/tar -jcf ${today}_$mode.tar.bz2 ${today}_$mode.sql && rm -fr ${today}_$mode.sql
}

function tb_dump()
{
    # Remove 5 day ago backup data
    cd ${bak_dir} && [ -f "${rmday}_$mode.tar.bz2" ] && rm -fr ${rmday}_$mode.tar.bz2

    /usr/bin/mysql -u${mysql_user} -p${mysql_pw} -e 'show databases\G' 2>> /dev/null |grep 'Database:*' |egrep -v -e "Database: $exclude_db" |awk -F': ' '{print $2}' > ${tmp_dir}/db

    while read DB ; do
        # Get database name list
        /bin/mkdir -p ${bak_dir}/${today}_$mode/$DB
        /usr/bin/mysql -u${mysql_user} -p${mysql_pw} -e "SHOW TABLE STATUS from $DB"  2>> /dev/null |awk '{print $1}' > ${tmp_dir}/$DB-tb
        # Remove head
        /bin/sed -i '1d' ${tmp_dir}/$DB-tb

        while read TB ; do
                # Backup everyone table from every database
                /usr/bin/mysqldump -u${mysql_user} -p${mysql_pw} --opt $DB $TB > ${bak_dir}/${today}_$mode/$DB/$DB-$TB.sql 2>> /dev/null
        done < ${tmp_dir}/${DB}-tb
    done < ${tmp_dir}/db

# Gzip sql file
    /bin/tar -jcf ${today}_$mode.tar.bz2 ${today}_$mode && rm -fr ${today}_$mode
}

case "$mode" in
    full|full_dump|FULL_DUMP)
        full_dump
        ;;
    tb|tb_dump|TB_DUMP)
        tb_dump
        ;;
    *)
        echo "Usage: $0 {full_dump|tb_dump}"
        exit 2
esac
