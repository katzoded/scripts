export GIT_REPOSITORY_PATH=${1}
export SSFINDIMPORTLINE=""

if [ "${IMPORT_DATA_FILE}" != "" ]; then
	export SSFINDIMPORTLINE=""
else
	echo "Missing IMPORT_DATA_FILE variable, please set the variable before running script"
	exit 1
fi

for var in "$@"
do
    if [ ${GIT_REPOSITORY_PATH} != ${var} ]; then
        export var=$(echo ${var} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "TrilliumInfraStructure" "TrilliumInfra");
        export  SSFINDIMPORTLINE="${SSFINDIMPORTLINE} | grep -i ${var}"
    fi
done

export IMPORTED_DATA=$(echo "cat ${IMPORT_DATA_FILE} ${SSFINDIMPORTLINE}" | sh | sort | uniq)
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
	found ${NUMBEROF_IMPORTLINES} lines\n please choose the line number to import from ${IMPORT_DATA_FILE} or [s]kip this version or [i]gnore this dependency"
    read input
	export IMPORTED_DATA=${input}

fi
echo "${IMPORTED_DATA}"
if [ "${IMPORTED_DATA}" != "" ]; then
    echo "${IMPORTED_DATA}" \
    | awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$1" "$2" "$3" "$4" "$5" "$6}' \
    | tee -a /tmp/import.ssver.sh
fi


