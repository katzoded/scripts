export GIT_REPOSITORY_PATH=${1}

cat /tmp/ImportSS.Data | grep -i igate | grep -e "ig4p" -e "ig4k" -e "ig4s" | grep -v -i infra \
| grep -v "Label:" \
| grep -v Share \
| grep -v SHARE \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for" \
| awk  '{print $1" "$3" "$5" "$6" "$7" "$4}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\)/\([0-9]*\)/\([0-9]*\)\ " "20\3 \2 \1 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\):\([0-9]*\)\ " "\1 \2 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)\(\"[a-zA-Z0-9 \._-]*\"\)\(.*\)" "\1 \3 \2" \
| awk '{ printf "%s/%02d/%02d %02d:%02d %s %s %s %s REPLACEWITHGITPATH_REPLACEWITHSPACE/%s/%s/%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $6, $7, $8}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH" "${GIT_REPOSITORY_PATH}" \
| awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommitForApp.sh "$3" "$4" "$5" "$6" "$7 }' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_REPLACEWITHSPACE" " " \
| grep "$/" \
| tee /tmp/import.App.sh


