export SOURCESAFE_HISTORY_DATAFILE=${1}
export GIT_REPOSITORY_PATH=${2}


cat ${SOURCESAFE_HISTORY_DATAFILE} \
| grep -v "Label:" \
| grep -v Share \
| grep -v SHARE \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for"> ${SOURCESAFE_HISTORY_DATAFILE}.clean

echo "export GIT_REPOSITORY_PATH=${2}; mkdir ${GIT_REPOSITORY_PATH}; cd ${GIT_REPOSITORY_PATH}; git init;" > DoCommands.sh

cat ${SOURCESAFE_HISTORY_DATAFILE}.clean \
| awk  '{print "\""$1" "$3"\" "$5" "$6" "$7" "$4}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\)/\([0-9]*\)/\([0-9]*\)\ " "20\3 \2 \1 " \
| awk '{ printf "%s/%02d/%02d %s %s %s %s %s\n", $1, $2, $3, $4, $5, $6, $7, $8 }' |sort \
| awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$3" "$4" "$5" "$6" ${GIT_REPOSITORY_PATH}" }' >> DoCommands.sh