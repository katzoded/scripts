export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}
export SSUSENAMEPASS=okatz,Johanson23

if [ "${1}" == "sip" ]; then
	export SSUSENAMEPASS=oded,Aniston
fi

rm -f hist.log;
ss History  -L -ohist.log -Y${SSUSENAMEPASS} ${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
cat hist.log |  tr '\n' ' ' | tr '\r' ' ' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Label:" "\nLabel:" | grep -v "History of" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Label: \(\".*\"\).*Date:\(.*\) Time:\(.*\) Labeled.*" "\2:\3 \1 ${SOURCESAFE_DB} ${SOURCESAFE_SUB_TREE} ${SOURCESAFE_PROJECT}"

