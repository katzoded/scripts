

export DATE_FORMAT="[0-9]*/[0-9]*/[0-9]* [0-9]*:[0-9]*:[0-9]*:[0-9]*"
export FILENAME=${1}
export FOLDERNAME=$(dirname ${FILENAME})
export EXTRA_FILTER="${2}"
export FILTER=".*SIP_Utils\.cc\.75|.*########## SIPMessage ##########"

#cat ${FILENAME} | ~/dev-newton/scripts/grep.multiline.pl "\[${DATE_FORMAT}]" "SIPCallLeg::AddRouteHeadersFromRecordRoute out_msg  ########## SIPMessage ##########|REceived message is  ########## SIPMessage ##########|B2BCallLeg::MsgToSendEvent.*########## SIPMessage ##########" > ${FOLDERNAME}/Messages.log;

#cat ${FOLDERNAME}/Messages.log | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*REceived message is  ########## SIPMessage ##########" "\[\1\] NOTE_OVER_RECEIVED \\n\1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*B2BCallLeg::MsgToSendEvent.*########## SIPMessage ##########" "\[\1\] NOTE_OVER_SENT \\n\1" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*SIPCallLeg::AddRouteHeadersFromRecordRoute out_msg  ########## SIPMessage ##########" "\[\1\] NOTE_OVER_SENT \\n\1" > ${FOLDERNAME}/Messages.log.note

#grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log  | sort | uniq |  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"NOTE_OVER_RECEIVED\\" \\"note over \1#yellow:\\" | ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"NOTE_OVER_SENT\\" \\"note over \1#pink:\\"' | 
#xargs echo "cat ${FOLDERNAME}/Messages.log.note" | sh  | fold -w 140 > ${FOLDERNAME}/Messages.log.updated

#grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.updated  | sort | uniq |  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"\\\\n|\\\\r\\" \\"\\\\\\\\n\\"' | 
#xargs echo "cat ${FOLDERNAME}/Messages.log.updated" | sh > ${FOLDERNAME}/Messages.log.updated.1

#cat ${FOLDERNAME}/Messages.log.updated.1 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\[${DATE_FORMAT}\]" "\n"|  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\\\n\\\\n" "\\\\n" > ${FOLDERNAME}/Messages.flow.log;


##### Grep All messages #############
if [ "${EXTRA_FILTER}" != "" ]; then
    export FILTER=${FILTER}+"|${EXTRA_FILTER}";
fi

#cat ${FILENAME} | ~/dev-newton/scripts/grep.multiline.pl "\[${DATE_FORMAT}]" ".*PIN HOLE ##########|.*SIP_Utils\.cc\.75|.*########## SIPMessage ##########" > ${FOLDERNAME}/Messages.pinholes;
cat ${FILENAME} | ~/dev-newton/scripts/grep.multiline.pl -ss "\[${DATE_FORMAT}]" -g "${FILTER}" > ${FOLDERNAME}/Messages.log.all;
cat ${FOLDERNAME}/Messages.log.all \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*REceived message is  ########## SIPMessage ##########" "\[\1\] NOTE_OVER_RECEIVED \\n\1"  \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*B2BCallLeg::MsgToSendEvent.*########## SIPMessage ##########" "\[\1\] NOTE_OVER_SENT \\n\1" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*SIPCallLeg::AddRouteHeadersFromRecordRoute out_msg  ########## SIPMessage ##########" "\[\1\] NOTE_OVER_SENT \\n\1" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*SIP_Utils\.cc\.75.*" "\[\1\] NOTE_OVER_MESSAGE \\n\1"  \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*########## SIPMessage ##########" "\[\1\] NOTE_OVER_MESSAGE \\n\1"  \
> ${FOLDERNAME}/Messages.log.all.note.pre

cat ${FOLDERNAME}/Messages.log.all.note.pre > ${FOLDERNAME}/Messages.log.all.note;

if [ "${EXTRA_FILTER}" != "" ]; then
    cat ${FOLDERNAME}/Messages.log.all.note.pre \
    | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\[${DATE_FORMAT}\]" "${EXTRA_FILTER}" "^\[${DATE_FORMAT}\]"  ""\
    > ${FOLDERNAME}/Messages.log.all.note;
fi

cat ${FOLDERNAME}/Messages.log.all.note > ${FOLDERNAME}/Messages.log.all.updated;

grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |  
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" 'cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\\[${DATE_FORMAT}\\]" "Call-ID:\1" "NOTE_OVER_MESSAGE" "note over\1#lightgreen:" \> ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated' |sh

grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |  
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" 'cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\\[${DATE_FORMAT}\\]" "Call-ID:\1" "NOTE_OVER_RECEIVED" "note over\1#yellow:" \> ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated' |sh

grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |  
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" 'cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\\[${DATE_FORMAT}\\]" "Call-ID:\1" "NOTE_OVER_SENT" "note over\1#pink:" \> ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated' |sh

cat ${FOLDERNAME}/Messages.log.all.updated | fold -w 140 > ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated;

#export MSGLIST1=$(grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |  
#~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"NOTE_OVER_MESSAGE\\" \\"note over \1#lightgreen:\\"');
#export MSGLIST2=$(grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |  
#~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"NOTE_OVER_RECEIVED\\" \\"note over \1#yellow:\\"');
#export MSGLIST3=$(grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all  | sort | uniq |
#~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"NOTE_OVER_SENT\\" \\"note over \1#pink:\\"');

#echo ${MSGLIST1} ${MSGLIST2} ${MSGLIST3} | xargs echo "cat ${FOLDERNAME}/Messages.log.all.note" | sh -x | fold -w 140 > ${FOLDERNAME}/Messages.log.all.updated

#grep -e "Call-ID:"  ${FOLDERNAME}/Messages.log.all.updated  | sort | uniq |  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Call-ID:\([\ 0-9a-zA-Z\-]*\).*" '| ~/dev-newton/scripts/search.and.replace.multiline.pl \\"^\\\\[${DATE_FORMAT}\\\\]\\" \\"Call-ID:\1\\" \\"\\\\n|\\\\r\\" \\"\\\\\\\\n\\"' | 
#xargs echo "cat ${FOLDERNAME}/Messages.log.all.updated" | sh > ${FOLDERNAME}/Messages.log.all.updated.1
cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\[${DATE_FORMAT}\]" ".*" "\n|\r" "\\n"> ${FOLDERNAME}/Messages.log.all.updated.1


cat ${FOLDERNAME}/Messages.log.all.updated.1 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\[${DATE_FORMAT}\]" "\n"|  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\\\n\\\\n" "\\\\n" > ${FOLDERNAME}/Messages.all.flow.log;

grep -v " OPTIONS" ${FOLDERNAME}/Messages.all.flow.log > ${FOLDERNAME}/Messages.all.flow.log.nooptions
grep -v " REGISTER" ${FOLDERNAME}/Messages.all.flow.log.nooptions > ${FOLDERNAME}/Messages.all.flow.log.nooptions.noregister

