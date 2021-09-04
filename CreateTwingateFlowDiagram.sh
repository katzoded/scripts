#!/bin/bash

FILENAME=${1}
ELEMENT_1=${2}
ELEMENT_2=${3}

USERS=($(/bin/cat ${FILENAME} | grep "Testing user" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*(\(.*\)@\(.*\)) .*" "\1@\2" | grep -v "(" | xargs))
#USERS=("Benjamin.Edwards@ward-mack.com")
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
    echo "${line}" >> ${FILENAME}.${arr[0]}.${arr[1]}.txt
  done < "${FILENAME}.${arr[0]}.${arr[1]}"
}

convert_and_replace()
{
  decodedbase64=$(echo ${base64} | base64 -d)
  if [ "$?" != 0 ]; then 
    return 0;
  fi
  if [ "${decodedbase64}" != "" ]; then
    for (( j=0; j<${#decodedbase64}; j++ )); do
      c=${decodedbase64:j:1}
     if [[ !(${c} =~ [a-zA-Z0-9:,\ \-\._]) ]]; then
        if [[ "${c}" != "{" && "${c}" != "}" && "${c}" != "[" && "${c}" != "]" && "${c}" != "\"" ]]; then
          j=${#decodedbase64}
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
      /bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "" \
      > ${FILENAME}.${arr[0]}.${arr[1]}.txt.tmp
      if [ "$?" -eq 0 ]; then 
        mv ${FILENAME}.${arr[0]}.${arr[1]}.txt.tmp ${FILENAME}.${arr[0]}.${arr[1]}.txt;
      fi
      base64=$(echo ${base64} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${partbase64}" "")
    done
    #     echo "decodedbase64 = $decodedbase64"
    decodedbase64=$(echo $decodedbase64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([\'\"]\)" "\\\\\1")
    base64=$(echo $base64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([+\'\"]\)" "\\\\\1")
    #    echo "decodedbase64 = $decodedbase64"
    #   echo "base64 = $base64"

    /bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "${base64}" "${decodedbase64}" \
    > ${FILENAME}.${arr[0]}.${arr[1]}.txt.tmp
    if [ "$?" -eq 0 ]; then 
      mv ${FILENAME}.${arr[0]}.${arr[1]}.txt.tmp ${FILENAME}.${arr[0]}.${arr[1]}.txt;
    fi

  fi
}

replace_all_base64()
{
  base64=""
  while read -r line
  do
    for (( i=0; i<${#line}; i++ )); do
      c=${line:i:1}
      if [[ !(${c} =~ [a-zA-Z0-9/+]) ]]; then
        if [[ "${line:i:1}" == "=" ]]; then
          base64+="${line:i:1}"
          ((i++))
        fi
        if [[ "${line:i:1}" == "=" ]]; then
          base64+="${line:i:1}"
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
  done < "${FILENAME}.${arr[0]}.${arr[1]}.txt"
}

for i in "${USERS[@]}"
do
   arr=($(echo $i | tr '@' ' '))
   echo "name=${arr[0]}\ndomain=${arr[1]}"

  /bin/cat ${FILENAME} | \
  ~/dev-newton/scripts/grep.multiline.pl -ss "Testing user.*" -g "${arr[0]}@${arr[1]}" > ${FILENAME}.${arr[0]}.${arr[1]};

  echo '' > ${FILENAME}.${arr[0]}.${arr[1]}.txt

  replace_http_precentage_symbols
  
  replace_all_base64
  replace_all_base64
  
  /bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | fold -w 80 | \
  tr '\n' "\\" | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\-----------RE" "\n-----------RE" |
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\\' '\\n' | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\(.*\)" "note over ${ELEMENT_1}: \1 \2\\\\n\3\n ${ELEMENT_1}->${ELEMENT_2}@\2:\1" | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*RESP.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\\\\n\([0-9]*\)\(.*\)" "${ELEMENT_2}@\2->${ELEMENT_1}:\3\nnote over ${ELEMENT_1}: \3\\\\n\4" \
  > ${FILENAME}.${arr[0]}.${arr[1]}.txt.flow
done
