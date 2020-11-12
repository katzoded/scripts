#!/usr/bin/sh 

export LISTFILENAME=$3
export PATH2REPLACE=$1
export REPLACEINTO=$2
export PATH2REPLACE="${1//\//\\/}" 
export REPLACEINTO="${2//\//\\/}"

if [ -f "$(which shuf)" ]; then  
	export RAND=$(shuf -i 1-100000 -n 1) 
else
	export RAND="" 
fi

if [ /tmp/rep${RAND}.sed ]; then  
	export RAND=$(shuf -i 1-100000 -n 1) 
fi

echo s/${PATH2REPLACE}/${REPLACEINTO}/g > /tmp/rep${RAND}.sed
sed -f /tmp/rep${RAND}.sed ${LISTFILENAME} 
rm -rf /tmp/rep${RAND}.sed

