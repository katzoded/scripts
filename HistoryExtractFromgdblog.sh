
cat ${1} \
| tr '\n' ' ' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{" "\\n{" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "}" "}\\n" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "[a-zA-Z0-9_]* = " \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "([a-zA-Z0-9_, \*&]*)" \
| grep -e"[{}]" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "}" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh " " \
> ${1}.ph0

cat ${1}.ph0 \
| awk 'BEGIN { FS = "," } ; {print $7 " " $8 " " $6":"$5"("$1","$2","$3","$4")"}' \
>${1}.ph1

cat ${1}.ph1 \
| sed -e 's/\b[0-9]\{5\}\b/0&/g; s/\b[0-9]\{4\}\b/00&/g; s/\b[0-9]\{3\}\b/000&/g; s/\b[0-9]\{2\}\b/0000&/g; s/\b[0-9]\b/00000&/g' \
>${1}.ph2

~/dev-newton/scripts/ReplaceFileList.sh "^\([0-9]*\) \([0-9]*\)\b" "\1.\2" ${1}.ph2 > ${1}.ph3



sort ${1}.ph3 > ${1}.sort
cat ${1}.sort | grep -v SetRealTimeReportForAccess > ${1}.sort.NoCacheManager


exit


~/dev-newton/scripts/ReplaceFileList.sh "<.*>\ " "" ${1}.ph0 > ${1}.ph1 

~/dev-newton/scripts/ReplaceFileList.sh "<.*>," "," ${1}.ph1 > ${1}.ph2 

~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " ${1}.ph2 | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " > ${1}.ph2.1

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "[a-zA-Z0-9_]* = " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "<.*>"

~/dev-newton/scripts/ReplaceFileList.sh "{m_Identifier = \([0-9]*\)," "\1" ${1}.ph2.1 > ${1}.ph3

~/dev-newton/scripts/ReplaceFileList.sh "m_Param1 = \([0-9]*\)," "\1" ${1}.ph3 > ${1}.ph4

~/dev-newton/scripts/ReplaceFileList.sh "m_Param2 = \([0-9]*\)," "\1" ${1}.ph4 > ${1}.ph5

~/dev-newton/scripts/ReplaceFileList.sh "m_Param3 = \([0-9]*\)," "\1" ${1}.ph5 > ${1}.ph6

~/dev-newton/scripts/ReplaceFileList.sh "m_pCookie = 0x0," "m_pCookie = 0x0 Something \"None\"" ${1}.ph6 > ${1}.ph6.1

~/dev-newton/scripts/ReplaceFileList.sh "m_pCookie =\ .*\ \"\(.*\)\"," "\"\1\"" ${1}.ph6.1 > ${1}.ph7

~/dev-newton/scripts/ReplaceFileList.sh "m_pfnTraceDesc = .*\ ," "" ${1}.ph7 > ${1}.ph8

~/dev-newton/scripts/ReplaceFileList.sh "m_TimeOccur = \([0-9]*\)," "\1" ${1}.ph8 > ${1}.ph9

~/dev-newton/scripts/ReplaceFileList.sh "m_MilliTimeOccur = \([0-9]*\)}" "\1" ${1}.ph9 > ${1}.ph10

~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " ${1}.ph10 | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/ReplaceFileList.sh "\ \ " " " > ${1}.ph11

~/dev-newton/scripts/ReplaceFileList.sh "\([0-9]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\) \"\(.*\)\" \([0-9]*\) \([0-9]*\)" "\6 \7 \5(\1, \2, \3, \4)" ${1}.ph11 > ${1}.ph12



cat ${1}.ph12 | sed -e 's/\b[0-9]\{5\}\b/0&/g; s/\b[0-9]\{4\}\b/00&/g; s/\b[0-9]\{3\}\b/000&/g; s/\b[0-9]\{2\}\b/0000&/g; s/\b[0-9]\b/00000&/g' > ${1}.ph13 

~/dev-newton/scripts/ReplaceFileList.sh "^\([0-9]*\) \([0-9]*\)\b" "\1.\2" ${1}.ph13 > ${1}.ph14



sort ${1}.ph14 > ${1}.sort
cat ${1}.sort | grep -v SetRealTimeReportForAccess > ${1}.sort.NoCacheManager



