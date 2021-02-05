export IMPORT_DATA_FILE=${1}

cat ${IMPORT_DATA_FILE} | grep -i igate | grep -e "[iI][gG]4[pPkKsS]" | grep -v -i infra \
| grep -v "Label:" \
| grep -v Share \
| grep -v SHARE \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommitForApp.sh "$1" "$2" "$3" "$4" "$5" "$6}' \
| grep "$/" \
| uniq \
| tee /tmp/import.App.sh



cat /tmp/import.App.sh | sort -i > /tmp/import.App.sorted.sh;

cat /tmp/import.App.sorted.sh | awk '{print $4}' | sort | uniq -i | grep -v -e [\._] \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "cat /tmp/import.App.sorted.sh | grep -i '\1 '" \
| sh | tr '[:upper:]' '[:lower:]' | awk '{print $2" "$3" "$4}' | sort | uniq \
|~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\) $/\(.*\) \(.*\)" "\1 $/\2 \3 \"\1.\2\" \"\1.\2_\3_##\"" > /tmp/NewBranch.data

cat /tmp/import.App.sorted.sh | awk '{print $4}' | sort | uniq -i | grep -e [\._] \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "cat /tmp/import.App.sorted.sh | grep -i '\1 '" \
| sh | tr '[:upper:]' '[:lower:]' | awk '{print $2" "$3" "$4}' | sort | uniq \
 |~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\) $/\(.*\) \(.*\)\([\._]\)\(.*\)" "\1 $/\2 \3\4\5 \"\1.\2.\3\4\5\" \"\1.\2_\3_##\"" >> /tmp/NewBranch.data