#!/usr/bin/env bash 
# Add or remove SecurityGroupRule of ECS
# SourceIP: Office PPPOE IP 

ipSite='ip.cip.cc'
sourceIP=`/usr/bin/curl -s $ipSite`
#sourceIP='121.35.102.138'
ecs_name=$1


function test_196 ()
{
    ports=(82 88 93 90 8222)
    region='cn-shenzhen'
    SecurityGroup='sg-wz9626b3aa33jfq4bevx'

}

function action ()
{
    for PORT in `echo ${ports[*]}` ; do
        /usr/bin/aliyuncli ecs AuthorizeSecurityGroup --RegionId $region --SecurityGroupId sg-wz9626b3aa33jfq4bevx --IpProtocol tcp --PortRange $PORT/$PORT --SourceCidrIp $sourceIP/32 --Policy accept --NicType internet --Description 'Auto-Create by aliyuncli'
    done
}



case "$ecs_name" in
    'test_196')
        test_196 && action;
    ;;
    *)
        echo "Usage: $0 {test_196}" 
esac
