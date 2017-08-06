#!/bin/env bash
# Used to: Check AWS's "ELASTIC BLOCK STORE" status, if available send email to admin
# "AWS CLI" or "IAM" must available
# known more:
# http://docs.amazonaws.cn/cli/latest/reference/ec2/describe-volumes.html
# ------------------------------------------------------------------------------------------------
# Developer:    xu.chen
# Blog:         http://chenxu.info
# Email:        linuxjosery@gmail.com
# Created on:   2017/06/23
# Location:
# Execution:    check_ebs_status.sh
# Description:  检查亚马逊云主机EBS当前状态，如果出现"可用"，发邮件报告, aws cli 或 IAM 必须有权限
# Revision History:
#
# Name             Date            Description
#------------------------------------------------------------------------------------------------
# xu.chen        2017/06/23      Initial Version
#------------------------------------------------------------------------------------------------

# Define Variables
aws_cmd='/usr/bin/aws'
ebs_cmd='ec2 describe-volumes'
env='test'
sendEmail='/usr/local/bin/sendEmail'
#receiver='xu.chen@chiefclouds.com'
receiver='YOUR_RE_EMAIL'
#arg='--filters Name=status,Values=in-use --output text --query 'Volumes[].[VolumeId,State,Size,CreateTime]' --output table'
arg='--filters Name=status,Values=available --output text --query 'Volumes[].[VolumeId,State,Size,CreateTime]' --output table'

${aws_cmd} ${ebs_cmd} --profile $env $arg  > /tmp/$$
grep -q 'vol'  /tmp/$$

# Send available of ebs's VolumeId to $receiver, by "sendEmail"
if [ "$?" -eq 0 ]; then
        $sendEmail -f YOUR_SEND_EMAIL -s smtp.mxhichina.com -xu "YOUR_USERNAME" -xp "YOUR_PASSWORD" -t $receiver -u "$env available of ebs's VolumeId" -o message-file=/tmp/$$ >> /dev/null 2>&1
fi

# Remove temp files
cd /tmp && rm -fr $$
