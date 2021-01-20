#!/usr/bin/sh  
export SOURCESAFE_HISTORY_DATAFILE=${1}


cat ${SOURCESAFE_HISTORY_DATAFILE} \
| grep -v "Label:" \
| grep -v Share \
| grep -v SHARE \
| grep -v "is not an existing filename or project" \
| grep -v "Building list for" \
| awk  '{print $1" "$3" "$5" "$6" "$7" "$4}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\)/\([0-9]*\)/\([0-9]*\)\ " "20\3 \2 \1 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\):\([0-9]*\)\ " "\1 \2 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)\(\"[a-zA-Z0-9 \._-]*\"\)\(.*\)" "\1 \3 \2" \
| awk '{ printf "%s/%02d/%02d %02d:%02d %s %s %s %s REPLACEWITHGITPATH/%s/%s/%s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9, $6, $7, $8}' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "/$/" "/" \
| grep "$/" > ${SOURCESAFE_HISTORY_DATAFILE}.clean

#Updates per Database
#sipGw & Protocols
cat ${SOURCESAFE_HISTORY_DATAFILE}.clean \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/SipGw/Gateway.*/" "REPLACEWITHGITPATH/SipGw/Gateway/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Protocols/Protocols.*/" "REPLACEWITHGITPATH/Protocols/Protocols/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Protocols/Protocols/TrilliumInfraStructure" "REPLACEWITHGITPATH/Protocols/Protocols/TrilliumInfra" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/Ig4p.*/" "REPLACEWITHGITPATH/Igate/Ig4p/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/ig4p.*/" "REPLACEWITHGITPATH/Igate/Ig4p/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/Ig4k.*/" "REPLACEWITHGITPATH/Igate/Ig4k/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/ig4k.*/" "REPLACEWITHGITPATH/Igate/Ig4k/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/Ig4s.*/" "REPLACEWITHGITPATH/Igate/Ig4s/" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "REPLACEWITHGITPATH/Igate/ig4s.*/" "REPLACEWITHGITPATH/Igate/Ig4s/" \
> ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed

cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed \
| awk 'BEGIN { FS = "\"" } ; { print $2 }' | sort | uniq -c | sort | grep -v " 1 " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\ *[0-9]* " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "\"\1\"" > ${SOURCESAFE_HISTORY_DATAFILE}.grepfile



cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed | grep -f ${SOURCESAFE_HISTORY_DATAFILE}.grepfile |sort -f +4 | uniq > ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck
cat ${SOURCESAFE_HISTORY_DATAFILE}.clean.fixed | grep -v -f ${SOURCESAFE_HISTORY_DATAFILE}.grepfile > ${SOURCESAFE_HISTORY_DATAFILE}.WithoutManualCheck
grep -v -i " Tools " ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck | grep -v "Protocols_A10_M3UA M3ua" | grep -v "DafnaBo" |grep -v "Temp" > ${SOURCESAFE_HISTORY_DATAFILE}.ManualCheck.1
cat /home/okatz/dev-newton/scripts/ImportSS.Data.ManualCheck.1 /home/okatz/dev-newton/scripts/ImportSS.Data.WithoutManualCheck |sort > ${SOURCESAFE_HISTORY_DATAFILE}.Full
