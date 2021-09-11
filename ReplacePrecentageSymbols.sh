#!/bin/bash

while read -r line
do

  existance=$(echo $line | grep "%")
  if [ "${existance}" != "" ]; then
    editedline=""
    for (( i=0; i<${#line}; i++ )); do
      c=${line:i:1}
#      if [[ "${c}" == "\"" || "${c}" == "\'" || "${c}" == "*" ]]; then
#          editedline+="\\${c}"
#      el
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
    echo "${editedline}"
  else
    echo "${line}"
  fi

done < "${1:-/dev/stdin}"