export GIT_REPOSITORY_PATH=${1}
export SSFINDIMPORTLINE=""

for var in "$@"
do
    if [ ${GIT_REPOSITORY_PATH} != ${var} ]; then
        export var=$(echo ${var} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "TrilliumInfraStructure" "TrilliumInfra");
        export  SSFINDIMPORTLINE="${SSFINDIMPORTLINE} | grep -i ${var}"
    fi
done

export NUMBEROF_IMPORTLINES=$(echo "cat /tmp/ImportSS.Data ${SSFINDIMPORTLINE}" | sh | uniq | wc | awk '{print $1}');
export LINESTOIMPORTSSVER=$(echo "/tmp/workSSver.bat.sh ${SSFINDIMPORTLINE}" | sh);

if [ ${NUMBEROF_IMPORTLINES} -eq 0 ]; then
    echo "the import of ${LINESTOIMPORTSSVER} was not found\n please choose the line number to import from /tmp/ImportSS.Data or [s]kip this version or [i]gnore this dependency"
    read input
elif [ ${NUMBEROF_IMPORTLINES} -gt 1 ]; then
    echo "the import of ${LINESTOIMPORTSSVER} found ${NUMBEROF_IMPORTLINES} lines\n please choose the line number to import from /tmp/ImportSS.Data or [s]kip"
    read input
else
    echo "cat /tmp/ImportSS.Data ${SSFINDIMPORTLINE}" | sh | uniq \
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
    | awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$3" "$4" "$5" "$6" "$7 }' \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_REPLACEWITHSPACE" " " \
    | tee -a /tmp/import.ssver.sh
fi


