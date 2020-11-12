#!/usr/bin/bash -x

export MODULE_NAME=$1
export SRC_FOLDER=$2
export BIN_DST_FOLDER=$3

pushd ${BIN_DST_FOLDER};
scp okatz@10.2.2.92:~/dev-newton/${SRC_FOLDER}/${MODULE_NAME}.gz .
gzip -fqd ${MODULE_NAME}.gz

ps -ef | grep ${MODULE_NAME} | grep port | awk '{print $2 }' | xargs echo "kill ${MODULE_NAME}"
ps -ef | grep ${MODULE_NAME} | grep port | awk '{print $2 }' | xargs kill -9

exit;
