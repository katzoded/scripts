#!/usr/bin/bash -x



export ADD_FILENAME=""

if [ "${3}" != "" ]; then

	export ADD_FILENAME=":\\\\n$1\\\\n"

fi



echo "/CMI_\(.*\){/p"> ClearNonRelevant.sed

echo "/Transition From.*/p">> ClearNonRelevant.sed

echo "/Changing From State.*/p">> ClearNonRelevant.sed

echo "/Changing State From.*/p">> ClearNonRelevant.sed

# Format Transition From:[] To:[]

echo "s/\([ 0-9]*\)\(.*\)/ \2 [link${ADD_FILENAME}:\1]/g"> SearchAndReplace.sed

echo "s/\(\[.*\]\)\(.*\)Transition From\\w*:\\w*\([0-9a-zA-Z_ ]*\)To\\w*:\\w*\([0-9a-zA-Z_ ]*\)\(\[link:.*\]\)/ note left of SMTrans \\">> SearchAndReplace.sed

echo "(\3->\4)\\\\n \2\\\\n \1\\\\n (\5) \\">> SearchAndReplace.sed

echo "end note/g">> SearchAndReplace.sed

# Changing From State :[] to :[]

echo "s/\(\[.*\]\)Changing From State : \([0-9a-zA-Z_ ]*\)to :\([0-9a-zA-Z_ ]*\)For\(.*\)\(\[link:.*\]\)/ note left of SMTrans \\">> SearchAndReplace.sed

echo "(\2->\3)\\\\n \4\\\\n \1\\\\n (\5) \\">> SearchAndReplace.sed

echo "end note/g">> SearchAndReplace.sed

# Changing State From:  to: 

echo "s/\(\[.*\]\)Changing State From\\w*:\([0-9a-zA-Z_\\w]*\)to\\w*:\([0-9a-zA-Z_\\w]*\)For\(.*\)\(\[link:.*\]\)/ note left of SMTrans \\">> SearchAndReplace.sed

echo "(\2->\3)\\\\n \4\\\\n \1\\\\n (\5) \\">> SearchAndReplace.sed

echo "end note/g">> SearchAndReplace.sed

echo "s/CMI_\([a-zA-Z0-9]*\)_\([a-zA-Z0-9]*\)_\([a-zA-Z_0-9]*\).*\(\[link:.*\]\)/\1->\2:\3 \\\\n(\4)/g">> SearchAndReplace.sed



echo title $2 \\n $1 > ${1}.flow.log



cat -n $1 | sed -nf ClearNonRelevant.sed > cmi.tmp 

sed -f SearchAndReplace.sed cmi.tmp >> ${1}.flow.log

rm cmi.tmp

rm SearchAndReplace.sed

rm ClearNonRelevant.sed



#cat -n $1 | sed -f $1 > cmi.tmp

#cat -n $1 | sed -nf createflow.sed > cmi.tmp 

#sed -f createflow1.sed cmi.tmp > flow.log

#sed -e 's/\([0-9]+\)CMI_\([a-zA-Z_]*\).*/\2 line \1/g' cmi.tmp > cmi1.tmp

#sed -e 's/CMI_\([a-zA-Z_]*\).*/\1 /g' cmi.tmp > cmi1.tmp

#sed -e 's/\([a-zA-Z]+\)_\([a-zA-Z]+\)_\([a-zA-Z]+\) /\1->\2:\3/g' cmi1.tmp > flow.log

#rm cmi.tmp

#rm cmi1.tmp

