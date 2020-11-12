#!/usr/bin/bash -x

export ROOT_PATH=$2
export FILE_NAME=$1

if [ -f ${FILE_NAME} ]; then
	chmod o+wr,g+wr,u+wr ${FILE_NAME};
fi

if [ -f ${ROOT_PATH}/Hijacked.log ]; then
	if grep ${FILE_NAME} ${ROOT_PATH}/Hijacked.log; then
		exit
	fi
fi

echo ${FILE_NAME} >> ${ROOT_PATH}/Hijacked.log
exit;
