export SOURCESAFE_HISTORY_DATAFILE=${1}
export GIT_REPOSITORY_PATH=${2}


echo "export GIT_REPOSITORY_PATH=${2}; " > DoCommands.sh
echo "mkdir ${GIT_REPOSITORY_PATH}; " >> DoCommands.sh
echo "cd ${GIT_REPOSITORY_PATH}; " >> DoCommands.sh
echo "git init; " >> DoCommands.sh
echo "echo a >tempfile;" >> DoCommands.sh
echo "git add tempfile;" >> DoCommands.sh
echo "git commit -a -m \"FirstCommit\";" >> DoCommands.sh
echo "git rm -f tempfile;" >> DoCommands.sh 
echo "git commit -a -m \"FirstCommit\"" >> DoCommands.sh
echo "" >> DoCommands.sh

cat ${SOURCESAFE_HISTORY_DATAFILE} \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH" "${GIT_REPOSITORY_PATH}" \
| awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$3" "$4" "$5" "$6" "$7 }' >> DoCommands.sh