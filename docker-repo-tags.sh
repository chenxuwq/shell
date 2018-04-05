#!/bin/sh
#
# Simple script that will display docker repository tags.
#
# Usage:
if [ "$#" -eq 0 ]; then
    echo -e "Simple script that will display docker repository tags. Usage:\n"$0" REPO1 [REPO2] ..."
    echo "eg: $0 ubuntu centos"
fi

# Install `jq`
which -s jq
[ "$?" -eq 0 ] || Install_jq

for REPO in $* ; do
    echo "tags of $REPO:" 
    curl -s -S "https://registry.hub.docker.com/v2/repositories/library/$REPO/tags/" | \
    # If `jq` is already installed, just use this one:
    jq '."results"[]["name"]' | \
    sort
    echo '-------------------------'
done

function Install_jq () 
{
	yum install wget -y
	wget -c https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/local/bin/jq
	chmod a+x /usr/local/bin/jq
}
