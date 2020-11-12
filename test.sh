#!/usr/bin/bash -f

while read entireline ;
do 
    folders=`echo $entireline | awk '{printf "%s", $1}'`
    lists=`echo $entireline | awk '{printf "%s", $2" "$3" "$4}'`
	export folder_nonewline=$(echo ${folders}| tr '\r' '/')	
	export folder_TR=$(echo ${folders}| tr '\r' 'S' | tr "[a-z]" "[A-Z]" | tr '/' '_' )
	
	echo entireline = ${entireline}
        echo folders= ${folders}
        echo lists= ${lists}	
done < folder.list

