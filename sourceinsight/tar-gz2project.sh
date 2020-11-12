#!/usr/bin/bash



export SRC_FOLDER=$1

export DST_FOLDER=$2



pushd ${SRC_FOLDER}





#free some space with removing the already zipped releases

for file in `ls`

do

	if [ -f ${DST_FOLDER}/${file}.tar.gz ]; then

		rm -rf ${file}

	fi

done





#for each folder in build do tar&zip&move to release&remove build folder

for file in `ls`

do

	if ! [ -f ${DST_FOLDER}/${file}.tar.gz ]; then

		if [ -d  ${file} ]; then

			tar cvf ${file}.tar ${file};

			gzip ${file}.tar;

			mv ${file}.tar.gz ${DST_FOLDER}/${file}.tar.gz;

			rm -rf ${file}

		fi

	else

		rm -rf ${file}

	fi

done

exit;

