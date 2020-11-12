#!/usr/bin/sh 

echo "updating ${1}";

~/dev-newton/scripts/ReplaceFileList.sh "io\\.swagger\\.\([model|api|client]\)" "com.dlgc.bn4000.vm.\1" ${1} > ${1}.new

if [ -s ${1}.new ]

then 

    cp ${1}.new ${1};

	if [ -s ${1} ]

	then 

		rm ${1}.new

	fi;

fi;

