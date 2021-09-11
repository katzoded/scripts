#!/bin/bash

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
      edittedline=$(echo "${edittedline}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "")
      base64=$(echo ${base64} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "")
    done
    #     echo "decodedbase64 = $decodedbase64"
    decodedbase64=$(echo $decodedbase64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([\'\"]\)" "\\\\\1")
    base64=$(echo $base64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([+\'\"]\)" "\\\\\1")
    #    echo "decodedbase64 = $decodedbase64"
    #   echo "base64 = $base64"

    edittedline=$(echo "${edittedline}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${base64}" "${decodedbase64}")
  fi
}

base64=""
while read line
do
#    echo "$(date): line=${line}"
    edittedline="${line}"
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
    echo "${edittedline}"
done < "${1:-/dev/stdin}"
