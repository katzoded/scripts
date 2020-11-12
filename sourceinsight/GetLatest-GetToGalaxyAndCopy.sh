#!/bin/bash -x



export ROOT_PATH=$2

export FILE_NAME=$1

export SERVER=$3

export REPLACE_WITH_USER=$4

export FROM_STR=${USER}

export TO_STR=${REPLACE_WITH_USER}



if [ "${REPLACE_WITH_USER}" == "" ]; then

	export REPLACE_WITH_USER=$USER

	export FROM_STR=dev-newton/

	export TO_STR=

fi



export REPLACED_FILE_NAME="${FILE_NAME//${FROM_STR}/${TO_STR}}"





if [ -f ${ROOT_PATH}/checkout.log ]; then

	if grep ${FILE_NAME} ${ROOT_PATH}/checkout.log; then

		echo "File exist in checkout list get latest version abort...."

		exit;

	fi

fi



res=$(ssh ${REPLACE_WITH_USER}@${SERVER} "cleartool update ${REPLACED_FILE_NAME}")

echo "$(date)" >> ${ROOT_PATH}/getlatest.ssh.log

echo "${res}" >> ${ROOT_PATH}/getlatest.ssh.log



scp  ${REPLACE_WITH_USER}@${SERVER}:${REPLACED_FILE_NAME} ${FILE_NAME}



exit;

