#!/usr/bin/bash -x



export SRC_FOLDER=$1

export DST_FOLDER=$2



pushd ${SRC_FOLDER}



for file in `ls *.gz`

do 

	if [ -f  ${file} ]; then

		mv ${file} ${DST_FOLDER}/${file};

	fi

done

exit;

