#!/usr/bin/bash

export REPLACESTR=$(grep "**** Received Event:" ${1}  | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\[.*\]\*\*\*\* Received Event: " | grep -v " " |sort | uniq | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "(.*)" | sort | uniq | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\1' 'HANDLE__\1'"  |xargs)
export CATSTR="cat ${2}"

echo ${CATSTR}  ${REPLACESTR} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "'" |sh > ${2}.updated
