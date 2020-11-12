#!/usr/bin/bash -x



extraFilter="-v grep"

scp okatz@172.29.14.111:${1}/${2}.gz ${3};

cd ${3};

gzip -d -f ${2}.gz;



if [ "${4}" != "" ]; then

	extraFilter=$4

fi	



neaPID=`/usr/bin/ps -ef | grep "./${2} -" | grep ${extraFilter} | awk '{print $2}'`;

#echo $neaPID

kill -9 ${neaPID};





