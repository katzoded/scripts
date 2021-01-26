export SSVER_FILE=${1}
export GIT_REPOSITORY_PATH=${2}

#Will find the import clause 
export SSIMPORT_SECTION_BEGIN=$(cat -n ${SSVER_FILE} | grep ":ssImport" | awk '{print $1}')
export TOTALNUMOFLINE=$(cat ${SSVER_FILE} | wc | awk '{print $1}')
export SSIMPORT_SECTION_ENDS=$(cat -n ${SSVER_FILE} | tail -$(expr ${TOTALNUMOFLINE} - ${SSIMPORT_SECTION_BEGIN}) | grep "goto" | head -1 | awk '{print $1}')

#Will replace all set variables of this file to have their values
echo "cat ${SSVER_FILE} \\" > /tmp/workSSver.bat.sh; 
cat ${SSVER_FILE} | grep -i set \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*[sS][eE][tT]\ \(.*\)=\(.*\)\r" \
"| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '%\1%' '\2' \\\\" >> /tmp/workSSver.bat.sh; 
chmod +x /tmp/workSSver.bat.sh; 
#/tmp/workSSver.bat.sh | tail -${SSIMPORT_SECTION_BEGIN} -n $(expr ${SSIMPORT_SECTION_ENDS} - ${SSIMPORT_SECTION_BEGIN})

#Import the copying part 
/tmp/workSSver.bat.sh | tail -$(expr ${TOTALNUMOFLINE} - ${SSIMPORT_SECTION_BEGIN})  | head -$(expr ${SSIMPORT_SECTION_ENDS} - ${SSIMPORT_SECTION_BEGIN}) \
| grep -e "[cC][oO][pP][yY]"  \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\\\w" " " \
| awk '{print $2}' \
 | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\\\\\\\newton\\\\archive\\\\\(.*\)\.out\\\\\(.*\)\\\\\(.*\)\\\\\([0-9]*\)\\\\.*" "~/dev-newton/scripts/ssFindWhatToImport.sh ${GIT_REPOSITORY_PATH} \1 \2 \3 \4" \
 | sort | uniq \
 > /tmp/importCurrentSSver.sh
 
 
 #Import the SS part 
/tmp/workSSver.bat.sh | tail -$(expr ${TOTALNUMOFLINE} - ${SSIMPORT_SECTION_BEGIN})  | head -$(expr ${SSIMPORT_SECTION_ENDS} - ${SSIMPORT_SECTION_BEGIN}) \
| grep -e "[sS][sS]"  \
| grep -v -e "[cC][oO][pP][yY]"  \
| tr '\r' ';' | tr '\n' ' ' \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "SET SSDIR" "\n" \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ".*=\\\\\\\\newton\\\\archive\\\\\([a-zA-Z]*\);" "\1 " \
| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\([a-zA-Z]*\).*-vl\(.*\)" "~/dev-newton/scripts/ssFindWhatToImport.sh ${GIT_REPOSITORY_PATH} \1 \2" \
>> /tmp/importCurrentSSver.sh

echo "" > /tmp/import.ssver.sh
chmod +x /tmp/importCurrentSSver.sh
/tmp/importCurrentSSver.sh
