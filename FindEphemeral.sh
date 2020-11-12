#!/usr/bin/bash 

grep '\(   E\)' ${1} | ~/dev-newton/scripts/ReplaceFileList.sh 'T:[0-9]* sec,' '' > log.log; cat -A log.log | ~/dev-newton/scripts/ReplaceFileList.sh '|[ ]*|' '|' > log1.log; cat log1.log | ~/dev-newton/scripts/ReplaceFileList.sh '|[ ]*RTP' '|RTP' | sort | uniq -c |sort -r