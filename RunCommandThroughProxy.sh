#!/usr/bin/bash

export PROXY_IP=${1}
shift;
export PROXY_USER=${1}
shift;
export REMOTESCRIPTFILENAME="${1}";
export LOCALSCRIPTFILENAME="${1}";


echo scp ${LOCALSCRIPTFILENAME} ${PROXY_USER}@${PROXY_IP}:${REMOTESCRIPTFILENAME} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "'" |sh

ssh ${PROXY_USER}@${PROXY_IP} "$@"



