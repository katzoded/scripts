#!/usr/bin/sh 

cd ~/dev-newton/${1}/Swagger/sbcrestapi-swagger-res-${2};



echo "updating ${3}";

~/dev-newton/scripts/ReplaceFileList.sh "io\\.swagger\\.\([model|api|client]\)" "com.dlgc.bn4000.vm.\1" ${3} > ${3}.new

if [ -s ${3}.new ]

then 

    cp ${3}.new ${3};

	if [ -s ${3} ]

	then 

		rm ${3}.new

	fi;

fi;

