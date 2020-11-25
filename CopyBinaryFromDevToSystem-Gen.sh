#!/usr/bin/bash

export DEV_IP=${1}
export SYS_IP=${2}
export BIN_NAME=${3}
export DEV_PATH=${4}
export DEV_USER=${5}
export SYS_USER=${6}
export TARGET_PATH=/opt/IPVR${BIN_NAME};



if [ "${7}" != "" ]; then	

export TARGET_PATH=${7};

fi



~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${DEV_IP} "gzip -f ${DEV_PATH}/${BIN_NAME}" "${DEV_PATH}/${BIN_NAME}.gz /tmp/${BIN_NAME}.${DEV_USER}.gz" ${DEV_USER};

scp /tmp/${BIN_NAME}.${DEV_USER}.gz ${SYS_USER}@${SYS_IP}:${TARGET_PATH};

if [ "${8}" == "" ]; then
    ssh ${SYS_USER}@${SYS_IP} "pkill -9 ${BIN_NAME}; gzip -d -f ${TARGET_PATH}/${BIN_NAME}.${DEV_USER}.gz"
else
    ssh ${SYS_USER}@${SYS_IP} "service ${BIN_NAME} stop; gzip -d -f ${TARGET_PATH}/${BIN_NAME}.${DEV_USER}.gz; service ${BIN_NAME} start"
    
fi


