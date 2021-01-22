#!/usr/bin/sh 



export LISTFILENAME=$3

export PATH2REPLACE=$1

export REPLACEINTO=$2

export PATH2REPLACE="${1//\//\\/}" 

export REPLACEINTO="${2//\//\\/}"



sed -e "s/${PATH2REPLACE}/${REPLACEINTO}/gi" ${LISTFILENAME} 



