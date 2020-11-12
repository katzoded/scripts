#!/usr/bin/bash
export DEV_IP=${1}
export SYS_IP=${2}
export BIN_NAME=${3}
export DEV_PATH=${4}
export TARGET_PATH=/opt/IPVR${BIN_NAME};

if [ "${5}" != "" ]; then	
export TARGET_PATH=/opt/IPVR${5};
fi

~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${DEV_IP} "gzip -f ${DEV_PATH}/${BIN_NAME}" "${DEV_PATH}/${BIN_NAME}.gz /tmp/${BIN_NAME}.oded.gz" okatz;
scp /tmp/${BIN_NAME}.oded.gz root@${SYS_IP}:${TARGET_PATH};
ssh root@${SYS_IP} "pkill -9 ${BIN_NAME}; gzip -d -f ${TARGET_PATH}/${BIN_NAME}.oded.gz"

