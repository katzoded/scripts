#!/usr/bin/sh -x

export LOCAL_PATH=${2};

export REMOTE_PATH=$(echo ${LOCAL_PATH} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Oded.Katz" "okatz")

ssh okatz@${1} "cd ${REMOTE_PATH}.build/; find . -name \"cdp_*.h\" -o -name \"cdp_*.cc\" | xargs tar cvf ${REMOTE_PATH}.build/cdp.tar ; cd ${REMOTE_PATH}/; find . -name \"cdp_*.h\" -o -name \"cdp_*.cc\" | xargs tar rvf ${REMOTE_PATH}.build/cdp.tar; gzip -f ${REMOTE_PATH}.build/cdp.tar; ";

scp okatz@${1}:${REMOTE_PATH}.build/cdp.tar.gz ${LOCAL_PATH}/gen;

cd ${LOCAL_PATH}/gen;

tar xvf cdp.tar.gz;