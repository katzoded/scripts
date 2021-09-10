#!/bin/bash

FILENAME=${1}

USERS=($(/bin/cat ${FILENAME} | grep "Testing user" | \
~/dev-newton/scripts/NoFileCreationReplaceFileList.sh ".*(\(.*\)@\(.*\)).*" "\1@\2" | grep -v "(" | xargs))


for i in "${USERS[@]}"
do
   arr=($(echo $i | tr '@' ' '))
   echo "name=${arr[0]}\ndomain=${arr[1]}"

  /bin/cat ${FILENAME} | \
  ~/dev-newton/scripts/grep.multiline.pl -ss "Testing user.*" -g "\(${arr[0]}@${arr[1]}\)" > ${FILENAME}.${arr[0]}.${arr[1]};
done
