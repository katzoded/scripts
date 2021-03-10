export INPUT_FILE=${1}

cat ${INPUT_FILE} \
| tr '\n' ' ' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{" "\\n{" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "}" "}\\n" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "[a-zA-Z0-9_]* = " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "([a-zA-Z0-9_, \*&]*)" \
| grep -e"[{}]" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "}" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh " " \
> ${INPUT_FILE}.ph0

cat ${INPUT_FILE}.ph0 \
| awk 'BEGIN { FS = "," } ; {print $7 " " $8 " " $6":"$5"("$1","$2","$3","$4")"}' \
>${1}.ph1

cat ${INPUT_FILE}.ph1 \
| sed -e 's/\b[0-9]\{5\}\b/0&/g; s/\b[0-9]\{4\}\b/00&/g; s/\b[0-9]\{3\}\b/000&/g; s/\b[0-9]\{2\}\b/0000&/g; s/\b[0-9]\b/00000&/g' \
>${1}.ph2

~/dev-newton/scripts/ReplaceFileList.sh "^\([0-9]*\) \([0-9]*\)\b" "\1.\2" ${INPUT_FILE}.ph2 > ${INPUT_FILE}.ph3

#beautify the Cache Rescords to have a string of Identity
cat ${INPUT_FILE}.ph3 \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*FormatCacheManagerChangeHistoryRecord.*" -prefixreg "(.*\([0-9]*,)" -numtohexreg ".*\([0-9]*,([0-9]*),([0-9]*),([0-9]*)\)" -suffixreg "(\))" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*FormatCacheManagerChangeHistoryRecord.*" -prefixreg "(.*\([0-9]*,)" -hextocharreg ".*\([0-9]*,([0-9a-zA-Z]*)\)" -suffixreg "(\))" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*FormatCacheManagerChangeHistoryRecord.*" -prefixreg "(.*\()" -numtohexreg ".*\(([0-9]*)," -suffixreg "\([0-9]*(,.*)" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*FormatCacheManagerChangeHistoryRecord.*" -prefixreg "(.*\()" -hextobitmaskreg ".*\(([0-9a-zA-Z]*)," "LineNumber=32 RegCacheId=32" -suffixreg "\([0-9a-zA-Z]*(,.*)" \
> ${INPUT_FILE}.ph4

#beautify the RV Callbacks with App SessionId and App CallLeg ID
cat ${INPUT_FILE}.ph4 \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*SIPCallLeg::Format.*" -prefixreg "(.*\(.*,).*,.*,.*\)" -numtohexreg ".*\(.*,(.*),.*,.*\)" -suffixreg ".*\(.*,.*(,.*,.*\))" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*SIPCallLeg::Format.*" -prefixreg "(.*\(.*,).*,.*,.*\)" -hextobitmaskreg ".*\(.*,(.*),.*,.*\)" "SessionId=32 CallLegId=32" -suffixreg ".*\(.*,.*(,.*,.*\))" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*SIPCallLeg::Format.*" -prefixreg "(.*\(.*,.*,).*,.*\)" -numtohexreg ".*\(.*,.*,(.*),.*\)" -suffixreg ".*\(.*,.*,.*(,.*\))" \
| ~/dev-newton/scripts/NumberToHex.pl -g ".*SIPCallLeg::Format.*" -prefixreg "(.*\(.*,.*,).*,.*\)" -hextobitmaskreg  ".*\(.*,.*,(.*),.*\)" "Unused=28 TxnReason=6 OtherState=6 StateReason=8 NewState=6 CurState=6 CLIndex=4" -suffixreg ".*\(.*,.*,.*(,.*\))" \
> ${INPUT_FILE}.ph5


sort ${INPUT_FILE}.ph5 | uniq > ${INPUT_FILE}.sort
cat ${INPUT_FILE}.sort | grep -v SetRealTimeReportForAccess > ${INPUT_FILE}.sort.NoCacheManager


exit


~/dev-newton/scripts/ReplaceFileList.sh "<.*>\ " "" ${INPUT_FILE}.ph0 > ${INPUT_FILE}.ph1 

~/dev-newton/scripts/ReplaceFileList.sh "<.*>," "," ${INPUT_FILE}.ph1 > ${INPUT_FILE}.ph2 

~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " ${INPUT_FILE}.ph2 | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " > ${INPUT_FILE}.ph2.1

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "[a-zA-Z0-9_]* = " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "<.*>"

~/dev-newton/scripts/ReplaceFileList.sh "{m_Identifier = \([0-9]*\)," "\1" ${INPUT_FILE}.ph2.1 > ${INPUT_FILE}.ph3

~/dev-newton/scripts/ReplaceFileList.sh "m_Param1 = \([0-9]*\)," "\1" ${INPUT_FILE}.ph3 > ${INPUT_FILE}.ph4

~/dev-newton/scripts/ReplaceFileList.sh "m_Param2 = \([0-9]*\)," "\1" ${INPUT_FILE}.ph4 > ${INPUT_FILE}.ph5

~/dev-newton/scripts/ReplaceFileList.sh "m_Param3 = \([0-9]*\)," "\1" ${INPUT_FILE}.ph5 > ${INPUT_FILE}.ph6

~/dev-newton/scripts/ReplaceFileList.sh "m_pCookie = 0x0," "m_pCookie = 0x0 Something \"None\"" ${INPUT_FILE}.ph6 > ${INPUT_FILE}.ph6.1

~/dev-newton/scripts/ReplaceFileList.sh "m_pCookie =\ .*\ \"\(.*\)\"," "\"\1\"" ${INPUT_FILE}.ph6.1 > ${INPUT_FILE}.ph7

~/dev-newton/scripts/ReplaceFileList.sh "m_pfnTraceDesc = .*\ ," "" ${INPUT_FILE}.ph7 > ${INPUT_FILE}.ph8

~/dev-newton/scripts/ReplaceFileList.sh "m_TimeOccur = \([0-9]*\)," "\1" ${INPUT_FILE}.ph8 > ${INPUT_FILE}.ph9

~/dev-newton/scripts/ReplaceFileList.sh "m_MilliTimeOccur = \([0-9]*\)}" "\1" ${INPUT_FILE}.ph9 > ${INPUT_FILE}.ph10

~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " ${INPUT_FILE}.ph10 | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " > ${INPUT_FILE}.ph11

~/dev-newton/scripts/ReplaceFileList.sh "\([0-9]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\) \"\(.*\)\" \([0-9]*\) \([0-9]*\)" "\6 \7 \5(\1, \2, \3, \4)" ${INPUT_FILE}.ph11 > ${INPUT_FILE}.ph12



cat ${INPUT_FILE}.ph12 | sed -e 's/\b[0-9]\{5\}\b/0&/g; s/\b[0-9]\{4\}\b/00&/g; s/\b[0-9]\{3\}\b/000&/g; s/\b[0-9]\{2\}\b/0000&/g; s/\b[0-9]\b/00000&/g' > ${INPUT_FILE}.ph13 

~/dev-newton/scripts/ReplaceFileList.sh "^\([0-9]*\) \([0-9]*\)\b" "\1.\2" ${INPUT_FILE}.ph13 > ${INPUT_FILE}.ph14



sort ${INPUT_FILE}.ph14 > ${INPUT_FILE}.sort
cat ${INPUT_FILE}.sort | grep -v SetRealTimeReportForAccess > ${INPUT_FILE}.sort.NoCacheManager



