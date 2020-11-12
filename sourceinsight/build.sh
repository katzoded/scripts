#!/usr/bin/bash -x

export MODULE_NAME=$1
export BASE_FOLDER=$2
export BIN_SRC_NAME=${BASE_FOLDER}/vobs/vikings/$3
export BIN_DST_NAME=$4
export TESTBED_IP=$5

#if ( -f ${BIN_SRC_NAME} ) then
#	rm -rf ${BIN_SRC_NAME};
#endif

export WORK=${BASE_FOLDER}/vobs/vikings
export PATH=${PATH}:${WORK}/utils

pushd ${WORK}/utils;
${MODULE_NAME}build;

if [ "${3}" != "" ]; then

	rm ${BIN_SRC_NAME}*gz
	rm ${BIN_SRC_NAME}*debug

    for file in `ls ${BIN_SRC_NAME}`
    do 
    if [ -x  ${file} ]; then
    	cp ${file} ${file}.debug;
    	strip ${file}
    	gzip ${file}
    fi
    done
fi    


popd
#if ( -f ${BIN_SRC_NAME} ) then
#	if ( "${TESTBED_IP}" == "" ) then
#		exit;
#	else
#		scp ${BIN_SRC_NAME} root@${TESTBED_IP}:${BIN_DST_NAME};
#	endif
#endif
exit;
