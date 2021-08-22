export FILE_NAME=${1}

cat ${FILE_NAME} | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "><" ">\n<" > ${FILE_NAME}.fixed.xml

