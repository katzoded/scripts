#!/usr/bin/bash -x

export LISTFILENAME=$2
export PATH2REPLACE="${1//\//\\/}" 

echo s/${PATH2REPLACE}/tar rvf ${LISTFILENAME}.tar ./g > /tmp/tar.sed
echo touch emptyfile
echo tar cvf  ${LISTFILENAME}.tar emptyfile
sed -f /tmp/tar.sed ${LISTFILENAME} 

