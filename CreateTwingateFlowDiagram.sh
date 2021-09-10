#!/bin/bash

FILENAME=${1}
ELEMENT_1=${2}
ELEMENT_2=${3}

replace_http_precentage_symbols()
{
  while read -r line
  do
    existance=$(echo $line | grep "%")
    if [ "${existance}" != "" ]; then
      editedline=""
      for (( i=0; i<${#line}; i++ )); do
        c=${line:i:1}
        if [[ "${c}" == "%" ]]; then
          if [[ ${line:i+1:2} =~ [a-fA-F0-9] ]]; then
            editedline+=$(echo 0x${line:i+1:2} | xxd -r)

            ((i+=2))
          else
            editedline+="${c}"
          fi
        else
          editedline+="${c}"
        fi
      done
      line="${editedline}"
    fi
    echo "${line}" >> ${FILENAME}.txt
  done < "${FILENAME}"
}

convert_and_replace()
{
#  if [ ${#base64} -ge 100 ]; then
#    echo "${base64}"
#  fi
  if [[ "${base64}" == "==" || "${base64}" == "=" ]]; then
      return 0;
  fi
  decodedbase64=$(echo "${base64}" | base64 -d)
  if [ "$?" != 0 ]; then
    echo "failed to convert input=${base64}"
    return 0;
  fi
  if [ "${decodedbase64}" != "" ]; then
    for (( j=0; j<${#decodedbase64}; j++ )); do
      c=${decodedbase64:j:1}
     if [[ !(${c} =~ [a-zA-Z0-9:,\ \-\._]) ]]; then
        if [[ "${c}" != "{" && "${c}" != "}" && "${c}" != "[" && "${c}" != "]" && "${c}" != "\"" ]]; then
          j=${#decodedbase64}
#          if [ ${#base64} -ge 100 ]; then
#            echo "invalid char ${j}, ${c}\n ${decodedbase64}"
#          fi

          return 0;
        fi
      fi
    done
  else
    return 0
  fi
  if [ "$?" -eq 0 ]; then 
    while [ ${#base64} -ge 1000 ]
    do 
    #        echo "base64 length = ${#base64}"
      partbase64=$(echo ${base64} | cut -c1-400)
      /bin/cat ${FILENAME}.txt.tmp | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "" \
      > ${FILENAME}.txt.tmp.1
      if [ "$?" -eq 0 ]; then 
        mv ${FILENAME}.txt.tmp.1 ${FILENAME}.txt.tmp;
      fi
      base64=$(echo ${base64} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "")
    done
    #     echo "decodedbase64 = $decodedbase64"
    decodedbase64=$(echo $decodedbase64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([\'\"]\)" "\\\\\1")
    base64=$(echo $base64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([+\'\"]\)" "\\\\\1")
    #    echo "decodedbase64 = $decodedbase64"
    #   echo "base64 = $base64"

    /bin/cat ${FILENAME}.txt.tmp | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${base64}" "${decodedbase64}" \
    > ${FILENAME}.txt.tmp.1
    if [ "$?" -eq 0 ]; then 
      mv ${FILENAME}.txt.tmp.1 ${FILENAME}.txt.tmp;
    fi
  fi
}

replace_all_base64()
{
  cp ${FILENAME}.txt ${FILENAME}.txt.tmp
  base64=""
  while read -r line
  do
#    echo "$(date): line=${line}"
    for (( i=0; i<${#line}; i++ )); do
      c=${line:i:1}
      if [[ !(${c} =~ [a-zA-Z0-9/+]) ]]; then
        if [[ "${line:i:1}" == "=" ]]; then
          base64+="${line:i:1}"
        fi
        if [[ "${line:i+1:1}" == "=" ]]; then
          base64+="${line:i+1:1}"
          ((i++))
        fi
        convert_and_replace
        base64=""
      else
        base64+="${c}"
        if [[ "${c}" == "%" ]]; then
          ((i+=2))
        fi
      fi
    done
  done < "${FILENAME}.txt"
  mv ${FILENAME}.txt.tmp ${FILENAME}.txt
}

echo '' > ${FILENAME}.txt

echo "$(date): Replacing all %HH symbols"
replace_http_precentage_symbols

echo "$(date): Replacing all base64 - phase I"
replace_all_base64
echo "$(date): Replacing all base64 - phase II"
replace_all_base64

echo "$(date): creating Flow for ${FILENAME}"
/bin/cat ${FILENAME}.txt | \
fold -w 80 | \
sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\-----------RE" "\n-----------RE" |
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\) \(.*\\\\n\)\(.*\)" "note over ${ELEMENT_1}: \1 \2?\3\\\\n\4\n ${ELEMENT_1}->${ELEMENT_2}@\2:\1" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\(.*\)" "note over ${ELEMENT_1}: \1 \2\\\\n\3\n ${ELEMENT_1}->${ELEMENT_2}@\2:\1" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*RESP.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\\\\n\([0-9]*\)\\\\n\(.*\)" "${ELEMENT_2}@\2->${ELEMENT_1}:\3\nnote over ${ELEMENT_1}: \3\\\\n\4" \
> ${FILENAME}.txt.flow
