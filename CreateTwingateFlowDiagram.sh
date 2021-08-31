#!/bin/bash

FILENAME=~/tmp/IntegrationMessages.txt
USERS=($(/bin/cat ${FILENAME} | grep "Testing user" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*(\(.*\)@\(.*\)) .*" "\1@\2" | grep -v "(" | xargs))
#USERS=(Benjamin.Edwards@ward-mack.com)

TOKENS=('\"token\":' '\"access_token\":' '\"refresh_token\":')
for i in "${USERS[@]}"
do
   arr=($(echo $i | tr '@' ' '))
   echo "name=${arr[0]}\ndomain=${arr[1]}"

  /bin/cat ${FILENAME} | \
  ~/dev-newton/scripts/grep.multiline.pl -ss "Testing user.*" -g "${arr[0]}@${arr[1]}" > ${FILENAME}.${arr[0]}.${arr[1]};
  cp ${FILENAME}.${arr[0]}.${arr[1]} ${FILENAME}.${arr[0]}.${arr[1]}.txt

  for tokenval in "${TOKENS[@]}"
  do
    echo "/bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | grep \"${tokenval}\" | \
    ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh"
    tokenarr=($(/bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | grep "${tokenval}" | \
    ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*${tokenval}\"\(.*\)\".*" "\1 "))
    for token in "${tokenarr[@]}"
    do
      echo "tokenval = ${tokenval} \n token = $token"
      base64arr=($(echo $token | tr '.' ' '))
      decodedbase64=""
      for base64 in "${base64arr[@]}"
      do
        decodedbase64="$(echo ${base64} | base64 -d)"

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
      done
  #    token=$(echo $token | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([\.,\'\"]\)" "\\\\\1")
  #    echo "decodedbase64 = $decodedbase64"
  #    decodedbase64=$(echo $decodedbase64 | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\([\.,\'\"]\)" "\\\\\1")
  #    echo "token = $token"
  #    echo "decodedbase64 = $decodedbase64"

      
    done
  done
  /bin/cat ${FILENAME}.${arr[0]}.${arr[1]}.txt | fold -w 80 | \
  tr '\n' "\\" | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\-----------RE" "\n-----------RE" |
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh '\\' '\\n' | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*REQ.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\(.*\)" "note over Client: \1 \2\\\\n\3\n Client->Controller@\2:\1" | \
  ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "^.*RESP.*-\\\\n\([A-Z]* \)\([a-z0-9\/_]*\)\\\\n\\\\n\([0-9]*\)\(.*\)" "Controller@\2->Client:\3\nnote over Client: \3\\\\n\4" \
  > ${FILENAME}.${arr[0]}.${arr[1]}.txt.flow
done
