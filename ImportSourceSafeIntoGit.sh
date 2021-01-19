export SOURCESAFE_DB=${1}
export SOURCESAFE_SUB_TREE=${2}
export SOURCESAFE_PROJECT=${3}
export GIT_REPOSITORY_PATH=${4}

export  SSDIR=\\\\Newton\\Archive\\${SOURCESAFE_DB}

ss History  -L -ohist.log -Yokatz,Johanson23 \$/${SOURCESAFE_SUB_TREE}/${SOURCESAFE_PROJECT};
cat hist.log |  tr '\n' ' ' | tr '\r' ' ' \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "Label:" "Label:\n" \
| ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(\".*\"\).*Date:\(.*\) Time:\(.*\) Labeled.*" "\2:\3 \1 ${SOURCESAFE_DB} ${SOURCESAFE_SUB_TREE} ${SOURCESAFE_PROJECT}" >> ImportSS.Data

