

export DATE_FORMAT="[0-9]*/[0-9]*/[0-9]* [0-9]*:[0-9]*:[0-9]*:[0-9]*"
export FILENAME=${1}
export FOLDERNAME=$(dirname ${FILENAME})
export EXTRA_FILTER="${2}"
export FILTER="^CMI_.*"

##### Grep All messages #############
if [ "${EXTRA_FILTER}" != "" ]; then
    export FILTER=".*SIP_Utils\.cc\.75|.*########## SIPMessage ##########|${EXTRA_FILTER}";
fi

cat ${FILENAME} \
| ~/dev-newton/scripts/grep.multiline.pl "\[${DATE_FORMAT}]" "${FILTER}" \
| ~/dev-newton/scripts/grep.multiline.pl "\[${DATE_FORMAT}]" "LocalCallId" \
> ${FOLDERNAME}/Messages.log.all;

cat ${FOLDERNAME}/Messages.log.all \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^\[\(${DATE_FORMAT}\)\].*" "\[\1\] NOTE_OVER_CMI \\n\1" \
> ${FOLDERNAME}/Messages.log.all.note.pre

cat ${FOLDERNAME}/Messages.log.all.note.pre > ${FOLDERNAME}/Messages.log.all.note;

if [ "${EXTRA_FILTER}" != "" ]; then
    cat ${FOLDERNAME}/Messages.log.all.note.pre \
    | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\[${DATE_FORMAT}\]" "${EXTRA_FILTER}" "^\[${DATE_FORMAT}\]"  ""\
    > ${FOLDERNAME}/Messages.log.all.note;
fi

cat ${FOLDERNAME}/Messages.log.all.note > ${FOLDERNAME}/Messages.log.all.updated;



grep LocalCallId ${FOLDERNAME}/Messages.log.all | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*CallId\ \([1-9][0-9]*\).*" "\1" | sort | uniq | grep -v CallId |  
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([1-9][0-9]*\)" 'cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\\[${DATE_FORMAT}\\]" "\1" "NOTE_OVER_CMI" "note over \1#lightgreen:" \> ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated' |sh


cat ${FOLDERNAME}/Messages.log.all.updated | fold -w 140 > ${FOLDERNAME}/Messages.log.all.updated.tmp; mv ${FOLDERNAME}/Messages.log.all.updated.tmp ${FOLDERNAME}/Messages.log.all.updated;

cat ${FOLDERNAME}/Messages.log.all.updated | ~/dev-newton/scripts/search.and.replace.multiline.pl "^\[${DATE_FORMAT}\]" ".*" "\n|\r" "\\n" > ${FOLDERNAME}/Messages.log.all.updated.1


cat ${FOLDERNAME}/Messages.log.all.updated.1 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\[${DATE_FORMAT}\]" "\n"|  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\\\\n\\\\n" "\\\\n" | grep -v "CallId 0"\
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "CCL_BaseMessage.*CMI_" "CMI_" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*CMI_.*\)\ .*" "\1" \
> ${FOLDERNAME}/Messages.all.flow.log;

cat  ${FOLDERNAME}/Messages.all.flow.log | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "{.*}" > ${FOLDERNAME}/Messages.all.flow.log.noData;

