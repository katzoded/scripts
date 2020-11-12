#!/bin/bash -x

StartCounting=0
while read line           
do           
	CMI=${CMI}${line}"\n"
	IsCCLMessage=$(echo ${line})|$(grep "CCL_BaseMessage")
	if [ ${IsCCLMessage} ]; then
		CMI=$line
		echo $CMI
		continue
	fi
	
	IsCMI=$(echo ${line})|$(grep ^CMI)
	if [ $IsCMI ]; then
		OpenBracket=0
		CloseBracket=0
		StartCounting=1
		echo $CMI
	fi	
	
	OpenBracketStr=$(echo ${line})|$(grep -o "{")|$(wc -l)
	CloseBracketStr=$(echo ${line})|$(grep -o "}")|$(wc -l)
	
    OpenBracket=$(expr $OpenBracket + ${OpenBracketStr})
    CloseBracket=$(expr $CloseBracket + ${CloseBracketStr})
    echo -e "${line} Open=${OpenBracket} Close=${CloseBracket}"
	
    if [ $StartCounting ]; then
        if [ $(expr $OpenBracket - $CloseBracket) = 0 ]; then
            echo $CMI
			StartCounting=0
        fi
    fi
	
	
done <${1}      
