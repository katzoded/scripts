#!/usr/bin/bash -x



export BASE_FOLDER=$1

export BASE_FOLDER_FOR_RUNNING_SCRIPT=$2

export SCRIPT_NAME=$3



#if ( -f ${BIN_SRC_NAME} ) then

#	rm -rf ${BIN_SRC_NAME};

#endif



export WORK=${BASE_FOLDER}/vobs/vikings

export PATH=${PATH}:${WORK}/utils



pushd ${BASE_FOLDER_FOR_RUNNING_SCRIPT};

./${SCRIPT_NAME} ${4};



popd

#if ( -f ${BIN_SRC_NAME} ) then

#	if ( "${TESTBED_IP}" == "" ) then

#		exit;

#	else

#		scp ${BIN_SRC_NAME} root@${TESTBED_IP}:${BIN_DST_NAME};

#	endif

#endif

exit;

