'/cygdrive/c/Program Files (x86)/Wireshark/tshark.exe' -Y "(${2})" -E separator=, -T fields -e sip.to.tag -e sip.from.tag -r ${1} >Tags.log;

cat Tags.log | sort | uniq | grep -e "^BN[0-9]*" > Tags.log.sort;

~/dev-newton/scripts/ReplaceFileList.sh "BN\([0-9]*\)-[0-9\-]*,\(.*\)\r" "'/cygdrive/c/Program Files (x86)/Wireshark/tshark.exe' -Y \"(sip.to.tag contains \"BN\1\" \|\| sip.from.tag contains \"BN\1\" \|\| sip.from.tag == \"\2\")\" -r ${1} -w ${1}-BN\1-\2.cap" Tags.log.sort | tee ExtractSessions.sh