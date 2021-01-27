export GIT_REPOSITORY_PATH=${1}
export SSFINDIMPORTLINE=""

for var in "$@"
do
    if [ ${GIT_REPOSITORY_PATH} != ${var} ]; then
        export var=$(echo ${var} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "TrilliumInfraStructure" "TrilliumInfra");
        export  SSFINDIMPORTLINE="${SSFINDIMPORTLINE} | grep -i ${var}"
    fi
done

export IMPORTED_DATA=$(echo "cat /tmp/ImportSS.Data ${SSFINDIMPORTLINE}" | sh | sort | uniq)
export NUMBEROF_IMPORTLINES=$(echo "${IMPORTED_DATA}" | sort | uniq | wc | awk '{print $1}');
export LINESTOIMPORTSSVER=$(echo "cat /tmp/workSSver.bat.data ${SSFINDIMPORTLINE}");

if [ ${NUMBEROF_IMPORTLINES} -eq 0 ]; then
    echo "the import of 
	${LINESTOIMPORTSSVER} 
	keys:
	${SSFINDIMPORTLINE}
	was not found\n please choose the line number to import from /tmp/ImportSS.Data or [s]kip this version or [i]gnore this dependency"
    read input
	export IMPORTED_DATA=${input}

elif [ ${NUMBEROF_IMPORTLINES} -gt 1 ]; then
    echo "the import of 
	${LINESTOIMPORTSSVER} 
	keys:
	${SSFINDIMPORTLINE} 
	found:
	${IMPORTED_DATA}
	found ${NUMBEROF_IMPORTLINES} lines\n please choose the line number to import from /tmp/ImportSS.Data or [s]kip this version or [i]gnore this dependency"
    read input
	export IMPORTED_DATA=${input}

fi
echo "${IMPORTED_DATA}"
if [ "${IMPORTED_DATA}" != "" ]; then
    echo "${IMPORTED_DATA}" \
    | awk  '{print $1" "$3" "$5" "$6" "$7" "$4}' \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\)/\([0-9]*\)/\([0-9]*\)\ " "20\3 \2 \1 " \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\):\([0-9]*\)\ " "\1 \2 " \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)\(\"[a-zA-Z0-9 \._-]*\"\)\(.*\)" "\1 \3 \2" \
    | awk '{ printf "%s/%02d/%02d %02d:%02d %s %s %s %s REPLACEWITHGITPATH_REPLACEWITHSPACE/%s/%s/%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $6, $7, $8}' \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/SipGw/Gateway.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/SipGw/Gateway/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/TrilliumInfraStructure" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/TrilliumInfra" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4p.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4p/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/ig4p.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4p/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4k.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4k/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/ig4k.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4k/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4s.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4s/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/ig4s.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4s/" \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH" "${GIT_REPOSITORY_PATH}" \
    | awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$3" "$4" "$5" "$6" "$7 }' \
    | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_REPLACEWITHSPACE" " " \
    | tee -a /tmp/import.ssver.sh
fi


