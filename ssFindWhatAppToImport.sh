export IMPORT_DATA_FILE=${1}

cat ${IMPORT_DATA_FILE} | grep -i igate | grep -e "ig4p" -e "ig4k" -e "ig4s" | grep -v -i infra \
| grep -v "Label:" \
| grep -v Share \
| grep -v SHARE \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommitForApp.sh "$1" "$2" "$3" "$4" "$5" "$6}' \
| grep "$/" \
| tee /tmp/import.App.sh


