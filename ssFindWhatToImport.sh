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

if [ "${IMPORTED_DATA}" == "" ]; then
    echo "the import of
${LINESTOIMPORTSSVER}
keys:
${SSFINDIMPORTLINE}
was not found
please choose the line number to import from /tmp/ImportSS.Data or [s]kip this version or [i]gnore this dependency"
    read input
	export IMPORTED_DATA=${input}

elif [ ${NUMBEROF_IMPORTLINES} -gt 1 ]; then
	echo "echo '${IMPORTED_DATA}'" | sort | sh > /tmp/ImportedDataMultipleLines.data
	export  SSCHECKFORACCURACY=$(cat /tmp/ImportedDataMultipleLines.data \
	| grep -i protocols \
	| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ".*\".*\.\([a-zA-Z]*\)\.\([0-9][0-9][0-9][0-9]\)\".*" "\1" \
	| sort -r | uniq \
	| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\(.*\)" "| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh \1 \\\\");
	
	for var in "$@"
	do
		if [ ${GIT_REPOSITORY_PATH} != ${var} ]; then
			export var=$(echo ${var} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "TrilliumInfraStructure" "TrilliumInfra");
			export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ${var}"
		fi
	done
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh P85X_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh PPC_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ANY_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh PENTIUM_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh TPSM_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh CPUS_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh P603_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh P604_"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '\.'"
	export  SSCHECKFORACCURACY="${SSCHECKFORACCURACY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '\ '"

	#echo "${SSCHECKFORACCURACY}"
	export ACCURACYRESULT=$(echo "echo '${IMPORTED_DATA}' | sort | grep -n \"\" ${SSCHECKFORACCURACY}" | sh | grep \"\" | awk 'BEGIN {FS=":"}; {print $1}' | head -1);
	
	echo "the import of
${LINESTOIMPORTSSVER}
keys:
${SSFINDIMPORTLINE}
found:
${IMPORTED_DATA}
found ${NUMBEROF_IMPORTLINES} lines
"
	if [ "${ACCURACYRESULT}" != "" ]; then
		export IMPORTED_DATA=$(cat /tmp/ImportedDataMultipleLines.data | head -n ${ACCURACYRESULT} | tail -1)
		echo "automatic accuracy found:
${IMPORTED_DATA}"
	else
		echo "please choose the line number to import from ${IMPORT_DATA_FILE} or [s]kip this version or [i]gnore this dependency"
		read input
		export IMPORTED_DATA=${input}
	fi
fi
echo "${IMPORTED_DATA}"
if [ "${IMPORTED_DATA}" != "" ]; then
    echo "${IMPORTED_DATA}" \
    | awk  '{print "~/dev-newton/scripts/DoImportSourceSafeFilesAndCommit.sh "$1" "$2" "$3" "$4" "$5" "$6}' \
    | tee -a /tmp/import.ssver.sh
fi


