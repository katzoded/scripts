export SSVER_FILE=${1}
export GIT_REPOSITORY_PATH=${2}
export LISTOF_CHANGED_LINES=$(git diff ${SSVER_FILE} \
| gawk 'match($0,"^@@ -([0-9]+),[0-9]+ [+]([0-9]+),[0-9]+ @@",a){left=a[1];right=a[2];next};\
/^(---|\+\+\+|[^-+ ])/{print;next};\
{line=substr($0,2)};\
/^-/{print "-" left++ ":" line;next};\
/^[+]/{print "+" right++ ":" line;next};\
{print "(" left++ "," right++ "):"line}' | grep -e "^+" | grep -v "+++" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "+\([0-9]*\):.*" "\1")


#Will find the import clause 
export SSIMPORT_SECTION_BEGIN=$(cat -n ${SSVER_FILE} | grep -v pcout | grep -v DSP | grep ":ssImport" | awk '{print $1}')
export TOTALNUMOFLINE=$(cat ${SSVER_FILE} | grep -v pcout | grep -v DSP | wc | awk '{print $1}')
export SSIMPORT_SECTION_ENDS=$(cat -n ${SSVER_FILE} | grep -v pcout | grep -v DSP | tail -$(expr ${TOTALNUMOFLINE} - ${SSIMPORT_SECTION_BEGIN}) | grep "goto" | head -1 | awk '{print $1}')

echo "SSIMPORT_SECTION_BEGIN ${SSIMPORT_SECTION_BEGIN}, SSIMPORT_SECTION_ENDS ${SSIMPORT_SECTION_ENDS}"
echo "" > /tmp/preimportCurrentSSver.sh

#Will replace all set variables of this file to have their values
echo "cat ${SSVER_FILE} \\" > /tmp/workSSver.bat.sh; 
cat ${SSVER_FILE} | grep -i set | grep -v WIND_BASE\
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*[sS][eE][tT]\ \(.*\)=\(.*\)\r" \
"| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '%\1%' '\2' \\\\" >> /tmp/workSSver.bat.sh; 
echo "| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '\\\\P85X' '' \\" >> /tmp/workSSver.bat.sh; 
echo "| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '\\\\PPC' '' \\" >> /tmp/workSSver.bat.sh; 
echo "| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh '\\\\ANY' '' \\" >> /tmp/workSSver.bat.sh; 
#echo "| grep -v pcout | grep -v DSP"  >> /tmp/workSSver.bat.sh; 
chmod +x /tmp/workSSver.bat.sh; 
/tmp/workSSver.bat.sh > /tmp/ssver.novar.data

export ISIMPORT="";
for var in ${LISTOF_CHANGED_LINES}
do
	#echo "line # ${var}"
    if [ ${var} -lt ${SSIMPORT_SECTION_BEGIN} ] || [ ${var} -gt ${SSIMPORT_SECTION_ENDS} ] ; then
		export ISSET=$(cat ${SSVER_FILE} | head -n ${var} | tail -1 | grep -e "[sS][eE][tT]");
		#echo "ISSET ${ISSET}"
		if [ "${ISSET}" != "" ]; then
			export var=$(echo ${ISSET} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*[sS][eE][tT]\ \(.*\)=\(.*\)\r" "\1");
			export LISTOF_CHANGED_LINES+=" ";
			export LISTOF_CHANGED_LINES+=$(cat -n ${SSVER_FILE} | grep -i ${var} | grep -v -e [sS][eE][tT] | awk '{print $1'});
		fi
    fi
done

for var in ${LISTOF_CHANGED_LINES}
do
	#echo "line # ${var}"
    if [ ${var} -ge ${SSIMPORT_SECTION_BEGIN} ] && [ ${var} -le ${SSIMPORT_SECTION_ENDS} ] ; then
		cat /tmp/ssver.novar.data | head -n ${var} | tail -1;
		export ISCOPY=$(cat /tmp/ssver.novar.data | head -n ${var} | tail -1 | grep -e "[cC][oO][pP][yY]");
		if [ "${ISCOPY}" != "" ]; then
			#echo "ISCOPY ${ISCOPY}"
			echo ${ISCOPY} | ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\\\w" " " \
			| awk '{print $2}' \
			| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\\\\\\\\newton\\\\archive\\\\\(.*\)\.out\\\\\(.*\)\\\\\(.*\)\\\\\([0-9a-zA-Z]*\)\\\\.*" "~/dev-newton/scripts/ssFindWhatToImport.sh ${GIT_REPOSITORY_PATH} \1 \2 \3 \4" \
			| grep -v "\\\\" \
			| sort | uniq \
			| grep "ssFindWhatToImport.sh"  >> /tmp/preimportCurrentSSver.sh
		elif [ "${ISIMPORT}" == "" ]; then
			export ISIMPORT=$(cat /tmp/ssver.novar.data | head -n ${var} | tail -1 | grep -e "[sS][sS]" | grep -v -e "[cC][oO][pP][yY]");
			#echo "ISIMPORT ${ISIMPORT}"
		fi
    fi
done

#/tmp/workSSver.bat.sh | tail -${SSIMPORT_SECTION_BEGIN} -n $(expr ${SSIMPORT_SECTION_ENDS} - ${SSIMPORT_SECTION_BEGIN})

#Import the copying part 

if [ "${ISIMPORT}" != "" ]; then
	cat /tmp/ssver.novar.data | tail -$(expr ${TOTALNUMOFLINE} - ${SSIMPORT_SECTION_BEGIN})  | head -$(expr ${SSIMPORT_SECTION_ENDS} - ${SSIMPORT_SECTION_BEGIN}) > /tmp/workSSver.bat.data
	cat "/tmp/workSSver.bat.data" \
	| grep -e "[sS][sS]"  \
	| grep -v -e "[cC][oO][pP][yY]"  \
	| tr '\r' ';' | tr '\n' ' ' \
	| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "SET SSDIR" "\n" \
	| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh ".*=\\\\\\\\newton\\\\archive\\\\\([a-zA-Z]*\);" "\1 " \
	| ~/dev-newton/scripts/CaseInsensitiveNoFileCreationIReplaceFileList.sh "\([a-zA-Z]*\).*-vl\(.*\)" "~/dev-newton/scripts/ssFindWhatToImport.sh ${GIT_REPOSITORY_PATH} \1 \2" \
	| grep -v "\\\\" \
	| grep "ssFindWhatToImport.sh" >> /tmp/preimportCurrentSSver.sh
fi
 
 
 #Import the SS part 

echo "" > /tmp/import.ssver.sh
cat /tmp/preimportCurrentSSver.sh | sort | uniq > /tmp/importCurrentSSver.sh
chmod +x /tmp/importCurrentSSver.sh
/tmp/importCurrentSSver.sh
