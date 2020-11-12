#!/usr/bin/bash -x

export ADD_FILENAME=""
if [ "${3}" != "" ]; then
	export ADD_FILENAME=":\\\\n$1\\\\n"
fi

echo "/<TraceMessage\(.*\)>/p"> ClearNonRelevant.sed

# Format Transition From:[] To:[]
echo "s/.*message_id=\"\(.*\)\" message_type=\"\(.*\)\".* message_to=\"\(.*\)\" message_from=\"\(.*\)\"/\4->\3: \"\2\" \1/g"> SearchAndReplace.sed
#echo "s/.* message_id=\"\(.*\)\".* message_type=\"\(.*\)\" To=\"\(.*\)\" MessageType= \"\(.*\)\".*/\2->\3: \"\2\" \1/g">> SearchAndReplace.sed

echo "s/\(.*\)\">.*/\1\"/g"> SearchAndReplace1.sed

echo title $2 \\n $1 > ${1}.flow.log

cat -n $1 | sed -nf ClearNonRelevant.sed > cmi.tmp 
sed -f SearchAndReplace.sed cmi.tmp > cmi1.tmp

sed -f SearchAndReplace1.sed cmi1.tmp > cmi2.tmp
sed -f SearchAndReplace1.sed cmi2.tmp >> ${1}.flow.log

rm cmi*.tmp
rm SearchAndReplace.sed
rm SearchAndReplace1.sed
rm ClearNonRelevant.sed

#cat -n $1 | sed -f $1 > cmi.tmp
#cat -n $1 | sed -nf createflow.sed > cmi.tmp 
#sed -f createflow1.sed cmi.tmp > flow.log
#sed -e 's/\([0-9]+\)CMI_\([a-zA-Z_]*\).*/\2 line \1/g' cmi.tmp > cmi1.tmp
#sed -e 's/CMI_\([a-zA-Z_]*\).*/\1 /g' cmi.tmp > cmi1.tmp
#sed -e 's/\([a-zA-Z]+\)_\([a-zA-Z]+\)_\([a-zA-Z]+\) /\1->\2:\3/g' cmi1.tmp > flow.log
#rm cmi.tmp
#rm cmi1.tmp
