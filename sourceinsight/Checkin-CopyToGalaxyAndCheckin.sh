#!/bin/bash -x



export ROOT_PATH=$2

export FILE_NAME=$1

export SERVER=$3

export REPLACE_WITH_USER=$4

export COMMENT=$5

export FROM_STR=${USER}

export TO_STR=${REPLACE_WITH_USER}



if [ "${REPLACE_WITH_USER}" == "" ]; then

	export REPLACE_WITH_USER=$USER

	export FROM_STR=dev-newton/

	export TO_STR=

fi



export REPLACED_FILE_NAME="${FILE_NAME//${FROM_STR}/${TO_STR}}"



if [ "${COMMENT}" == "" ]; then

    export CHECKIN_STR="cleartool ci -nc ${REPLACED_FILE_NAME};"

else

    export CHECKIN_STR="cleartool ci -c \"${COMMENT}\" ${REPLACED_FILE_NAME};"

fi



if [ -f ${ROOT_PATH}/checkout.log ]; then

	if grep ${FILE_NAME} ${ROOT_PATH}/checkout.log; then

		echo "File exist in checkout list Do: check in"

	else

		echo "File was not checked out"

		exit

	fi

fi



if [ -f ${FILE_NAME} ]; then

	echo "File exist Proceed check in"

else

	echo "Error"

	exit

fi



export res="";



if [ "${REPLACE_WITH_USER}" == "${USER}" ]; then

	scp ${FILE_NAME} ${USER}@${SERVER}:${REPLACED_FILE_NAME}

	res=$(ssh ${REPLACE_WITH_USER}@${SERVER} ${CHECKIN_STR})

else

	res=$(ssh ${REPLACE_WITH_USER}@${SERVER} "cp ${FILE_NAME} ${REPLACED_FILE_NAME}; ${CHECKIN_STR}")

fi



echo "$(date)" >> ${ROOT_PATH}/checkin.ssh.log

echo "${res}" >> ${ROOT_PATH}/checkin.ssh.log



if [ "${res}" == "" ]; then

	exit

fi



if  echo "${res}" | grep Error ; then

	exit

fi



export REPLACED_FILE_NAME_FOR_SED="${FILE_NAME//\//\/}";

export REPLACED_FILE_NAME_FOR_SED="${REPLACED_FILE_NAME_FOR_SED//./\.}";

echo ${REPLACED_FILE_NAME_FOR_SED};

mv ${ROOT_PATH}/checkout.log ${ROOT_PATH}/checkout.log.backup 

cat ${ROOT_PATH}/checkout.log.backup | sed -e s/${REPLACED_FILE_NAME_FOR_SED}//g > ${ROOT_PATH}/checkout.log





chmod o-w,g-w,u-w ${FILE_NAME};



echo ${FILE_NAME} >> ${ROOT_PATH}/checkin.log

exit;

