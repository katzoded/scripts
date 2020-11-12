#!/usr/bin/sh



export LOCAL_PATH=${2};

export REMOTE_PATH=$(echo ${LOCAL_PATH} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Oded.Katz" "okatz")



ssh okatz@${1} "cd ${REMOTE_PATH}; find . -name \"cm[pi]_*.h\" -o  -name \"cm[pi]_*.cc\" -o  -name \"cm[pi]_*.e\" -o  -name \"cm[pi]_*.v\" -o  -name \"cm[pi]_*.pm\" | xargs tar cvf ${REMOTE_PATH}.build/cmi.tar"

ssh okatz@${1} "cd ${REMOTE_PATH}.build; find . -name \"cm[pi]_*.h\" -o  -name \"cm[pi]_*.cc\" -o  -name \"cm[pi]_*.e\" -o  -name \"cm[pi]_*.v\" -o  -name \"cm[pi]_*.pm\" | xargs tar rvf  ${REMOTE_PATH}.build/cmi.tar"

ssh okatz@${1} "gzip -f ${REMOTE_PATH}.build/cmi.tar;";



scp okatz@${1}:${REMOTE_PATH}.build/cmi.tar.gz ${LOCAL_PATH}/gen/;

cd ${LOCAL_PATH}/gen;

tar xvf cmi.tar.gz;

