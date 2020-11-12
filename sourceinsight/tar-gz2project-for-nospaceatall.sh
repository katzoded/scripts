#!/usr/bin/bash -x

export SRC_FOLDER=$1
export DST_FOLDER=$2

pushd ${SRC_FOLDER}


#free some space with removing the already zipped releases
for file in `ls`
do
	if [ -f ${DST_FOLDER}/${file}.tar.gz ]; then
		echo rm -rf ${file}
	fi
done


#for each folder in build do tar&zip&move to release&remove build folder
for file in `ls`
do
	if ! [ -f ${DST_FOLDER}/${file}.tar.gz ]; then
		if [ -d  ${file} ]; then
			pushd ${DST_FOLDER}
			echo tar cvf ${file}.tar ${SRC_FOLDER}/${file};
			echo gzip ${file}.tar;
			popd
			echo rm -rf ${file}
		fi
	else
		echo rm -rf ${file}
	fi
done
popd
exit;
