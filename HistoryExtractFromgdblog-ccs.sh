export NEW_DIR=${1}.dir

export FILENAME=${NEW_DIR}/History

mkdir ${NEW_DIR}



cat ${1} | tr '\n' ' ' | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\$[0-9]*\ =\ " "\\n" > ${FILENAME}.ph0

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "<.*>\ " "" ${FILENAME}.ph0 > ${FILENAME}.ph1 

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "<.*>," "," ${FILENAME}.ph1 > ${FILENAME}.ph2 

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " ${FILENAME}.ph2 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " > ${FILENAME}.ph2.1

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{m_Identifier = \([0-9]*\)," "\1" ${FILENAME}.ph2.1 > ${FILENAME}.ph3

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_Param1 = \([0-9]*\)," "\1" ${FILENAME}.ph3 > ${FILENAME}.ph4

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_Param2 = \([0-9]*\)," "\1" ${FILENAME}.ph4 > ${FILENAME}.ph5

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_Param3 = \([0-9]*\)," "\1" ${FILENAME}.ph5 > ${FILENAME}.ph6

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_pCookie = 0x0," "m_pCookie = 0x0 Something \"None\"" ${FILENAME}.ph6 > ${FILENAME}.ph6.1

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_pCookie =\ .*\ \"\(.*\)\"," "\"\1\"" ${FILENAME}.ph6.1 > ${FILENAME}.ph7

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_pfnTraceDesc = 0x0, " "" ${FILENAME}.ph7 > ${FILENAME}.ph8

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_TimeOccur = \([0-9]*\)," "\1" ${FILENAME}.ph8 > ${FILENAME}.ph9

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "m_MilliTimeOccur = \([0-9]*\)}" "\1" ${FILENAME}.ph9 > ${FILENAME}.ph10

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " ${FILENAME}.ph10 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\ \ " " " > ${FILENAME}.ph11

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\) \([0-9]*\) \([0-9]*\) \([0-9]*\) \"\(.*\)\" \([0-9]*\) \([0-9]*\)" "\6 \7 \5(\1, \2, \3, \4)" ${FILENAME}.ph11 > ${FILENAME}.ph12



cat ${FILENAME}.ph12 | sed -e 's/\b[0-9]\{5\}\b/0&/g; s/\b[0-9]\{4\}\b/00&/g; s/\b[0-9]\{3\}\b/000&/g; s/\b[0-9]\{2\}\b/0000&/g; s/\b[0-9]\b/00000&/g' > ${FILENAME}.ph13 

~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\([0-9]*\) \([0-9]*\)\b" "\1.\2" ${FILENAME}.ph13 > ${FILENAME}.ph14



sort ${FILENAME}.ph14 > ${FILENAME}.sort





#create CMI names list

cat ${FILENAME}.sort | grep -v gdb | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*(\(.*\)).*" "\1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\),.*" "-e \1" | sort | uniq.exe | xargs echo "find ~/dev-newton/5.11.1.0/okatz_5.11.0.bicc.il/gen/ -name "cmi_[a-z]*_[a-z]*_linkdefs.h" | xargs grep" |sh | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*:"| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*\(CMI_.*\) = \(.*\)," "\2 \1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_LinkDefs_MessageTypes" > ${FILENAME}.sort.cmi



#create CMI names list with usage count

cat ${FILENAME}.sort | grep -v gdb|~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*(\(.*\)).*" "\1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\),.*" "\1" | sort | grep -e "[0-9]*" | uniq.exe -c | sort -h | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "[ ]*\([0-9]*\) \([0-9]*\)" "|~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\2' '\1' " | xargs echo "cat ${FILENAME}.sort.cmi" | sh | sort -h | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "_LinkDefs_MessageTypes"  > ${FILENAME}.sort.cmi.withcount



#Convert .sort message Id to message name

cat ${FILENAME}.sort.cmi | grep -v -e "v[0-9]*_" |  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([0-9]*\) \(.*\)" "|~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\1' '\2' " | xargs echo "cat ${FILENAME}.sort" | sh > ${FILENAME}.sort.names