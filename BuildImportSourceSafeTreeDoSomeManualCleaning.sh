#!/usr/bin/sh  
export SOURCESAFE_HISTORY_DATAFILE=${1}
export GIT_REPOSITORY_PATH=$(echo "${2}" | tr '[:upper:]' '[:lower:]');

cat ${SOURCESAFE_HISTORY_DATAFILE} \
| grep -v "Label:" \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for" \
| awk  '{print $1" "$3" "$5" "$6" "$7" "$4}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\)/\([0-9]*\)/\([0-9]*\)\ " "20\3 \2 \1 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\):\([0-9]*\)\ " "\1 \2 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)\(\"[a-zA-Z0-9 \._-]*\"\)\(.*\)" "\1 \3 \2" \
| awk '{ printf "%s/%02d/%02d %02d:%02d %s %s %s %s REPLACEWITHGITPATH_REPLACEWITHSPACE/%s/%s/%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $6, $7, $8}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| grep "$/" > ${SOURCESAFE_HISTORY_DATAFILE}.clean

#Updates per Database
#sipGw & Protocols
cat ${SOURCESAFE_HISTORY_DATAFILE}.clean \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/SipGw/Gateway.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/SipGw/Gateway/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/TrilliumInfraStructure" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Protocols/Protocols/TrilliumInfra" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4p.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4p/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/ig4s.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4s/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4k.*/" "REPLACEWITHGITPATH_REPLACEWITHSPACE/Igate/Ig4k/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/cmg.*/" "/cmg" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/dspk.*/" "/dspk" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/tpsm.*/" "/tpsm" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "/tdm.*/" "/tdm" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH" "${GIT_REPOSITORY_PATH}" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_REPLACEWITHSPACE" " " \
> ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed

cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed \
| awk 'BEGIN { FS = "\"" } ; { print $2 }' | sort | uniq -c | sort | grep -v " 1 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\ *[0-9]* " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "\"\1\"" > ${SOURCESAFE_HISTORY_DATAFILE}.grepfile


cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed | grep -f ${SOURCESAFE_HISTORY_DATAFILE}.grepfile |sort -f +4 | uniq > ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck
cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed | grep -v -f ${SOURCESAFE_HISTORY_DATAFILE}.grepfile > ${SOURCESAFE_HISTORY_DATAFILE}.WithoutManualCheck
grep -v -i " Tools " ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck | grep -v "Protocols_A10_M3UA M3ua" | grep -v "DafnaBo" |grep -v "Temp" > ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck.1

cat ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck.1 ${SOURCESAFE_HISTORY_DATAFILE}.WithoutManualCheck | sort | uniq \
| awk  '{print $3" "$4" "$5" "$6" "$7" "$8}' \
| grep -v "(" | grep -v ")" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\(/home/okatz/ss /[a-zA-Z]*/[a-zA-Z]*\)\..*/" "\1/" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\(/home/okatz/ss /[a-zA-Z]*/[a-zA-Z]*/[a-zA-Z]*\)\..*" "\1" \
> ${SOURCESAFE_HISTORY_DATAFILE}.Full
