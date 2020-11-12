#!/usr/bin/bash -x

export FILE_NAME=$1
export BASE_FOLDER=$2
export INITIAL_PATH=$3/../
#export PATH_NAME=
#export NEW_PATH_NAME=
#export LINE=

export WORK=${BASE_FOLDER}/vobs/vikings
export PATH=${PATH}:${WORK}/utils

# inserting the possible paths of the file into a text file 
find ${INITIAL_PATH} -name "${FILE_NAME}.d" > PATH_NAME;
#replacing the name of the file with nothing ---> deleting the name of the file from 
#the library path
sed -e s/${FILE_NAME}\\.d//g PATH_NAME > NEW_PATH_NAME;
#passing through each line in the text file
while read LINE;
do
	pushd $LINE;
	ccpbuild;
	popd
	#ls -l;
# end of while loop
done < NEW_PATH_NAME
rm NEW_PATH_NAME;
rm PATH_NAME;   
exit;
