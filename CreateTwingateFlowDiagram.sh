#!/bin/bash

FILENAME=${1}
ELEMENT_1=${2}
ELEMENT_2=${3}


cp ${FILENAME} ${FILENAME}.txt

echo "$(date): Replacing all %HH symbols"
cat ${FILENAME}.txt | ~/dev-newton/scripts/ReplacePrecentageSymbols.sh > ${FILENAME}.txt.1

echo "$(date): Replacing all base64 - phase I"
cat ${FILENAME}.txt.1 | ~/dev-newton/scripts/ConvertBase64.sh > ${FILENAME}.txt.2
echo "$(date): Replacing all base64 - phase II"
cat ${FILENAME}.txt.2 | ~/dev-newton/scripts/ConvertBase64.sh > ${FILENAME}.txt.3

echo "$(date): creating Flow for ${FILENAME}"
/bin/cat ${FILENAME}.txt.3 | \
fold -w 80 | \
sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\-----------RE" "\n-----------RE" |
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\) \(.*\\\\n\)\(.*\)" "note over ${ELEMENT_1}: \1 \2?\3\\\\n\4\n ${ELEMENT_1}->${ELEMENT_2}@\2:\1" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\(.*\)" "note over ${ELEMENT_1}: \1 \2\\\\n\3\n ${ELEMENT_1}->${ELEMENT_2}@\2:\1" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*RESP.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\\\\n\([0-9]*\)\\\\n\(.*\)" "${ELEMENT_2}@\2->${ELEMENT_1}:\3\nnote over ${ELEMENT_1}: \3\\\\n\4" \
> ${FILENAME}.txt.flow
