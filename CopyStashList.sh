#!/usr/bin/bash -f



export REGEXP=$1

export OUTPUTDIR=$2

export LISTFILENAME=$3



~/dev-newton/scripts/ReplaceFileList.sh "${REGEXP}" "mkdir -p ${OUTPUTDIR}/\1;rm -fr ${OUTPUTDIR}/\1; cp \1 ${OUTPUTDIR}/\1"