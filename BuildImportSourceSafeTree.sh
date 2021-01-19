export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export GIT_REPOSITORY_PATH=${3}

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}
export SOURCESAFE_SUB_TREE_SLASHED=$(echo ${SOURCESAFE_SUB_TREE} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/" "//")

ss Dir ${SOURCESAFE_SUB_TREE}/ -F- -Yokatz,Johanson23 | grep -v item | grep -v : \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "$\(.*\)\r" "ss Dir ${SOURCESAFE_SUB_TREE}/\1 -F- -Yokatz,Johanson23 | grep -v item | grep -v : | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '$\\\\(.*\\\\)\\\\r' './ImportSourceSafeIntoGit.sh ${SOURCESAFE_DB} \1 \\\\1 '"    |sh
