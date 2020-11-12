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

		exit

	fi

fi



if [ -f ${FILE_NAME} ]; then

	chmod o+wr,g+wr,u+wr ${FILE_NAME};

	get_res=$(ssh ${REPLACE_WITH_USER}@${SERVER} "cleartool update ${REPLACED_FILE_NAME};") 	

	res=$(ssh ${REPLACE_WITH_USER}@${SERVER} "cleartool co -nc ${REPLACED_FILE_NAME};") 	

	echo "$(date)" >> ${ROOT_PATH}/checkout.ssh.log

	echo "${get_res}" >> ${ROOT_PATH}/checkout.ssh.log

	echo "${res}" >> ${ROOT_PATH}/checkout.ssh.log



	if [ "${res}" == "" ]; then

		chmod o-w+r,g-w+r,u-w+r ${FILE_NAME};

		exit

	fi

	

	if  echo "${res}" | grep Error ; then

		chmod o-w+r,g-w+r,u-w+r ${FILE_NAME};

		exit

	fi

	scp ${REPLACE_WITH_USER}@${SERVER}:${REPLACED_FILE_NAME} ${FILE_NAME}

else

	touch ${FILE_NAME};

	chmod o+wr,g+wr,u+wr ${FILE_NAME};

fi



echo ${FILE_NAME} >> ${ROOT_PATH}/checkout.log

exit;

