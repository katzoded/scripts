export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}
export SOURCESAFE_SUB_TREE_SLASHED=$(echo ${SOURCESAFE_SUB_TREE} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" "//")
export SSUSENAMEPASS=okatz,Johanson23

if [ "${1}" == "sip" ]; then
	export SSUSENAMEPASS=oded,Aniston
fi

#echo ${SOURCESAFE_SUB_TREE_SLASHED}

ss Dir ${SOURCESAFE_SUB_TREE}/ -F- -Y${SSUSENAMEPASS} | grep -v item | grep -v : | grep -v "Cloaked"\
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "$\(.*\)\r" "ss Dir ${SOURCESAFE_SUB_TREE}/\1 -F- -Y${SSUSENAMEPASS} | grep -v item | grep -v : | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '$\\\\(.*\\\\)\\\\r' '~/dev-newton/scripts/ImportSourceSafeIntoGit.sh ${SOURCESAFE_DB} ${SOURCESAFE_SUB_TREE}\1 \\\\1 '"    |sh
