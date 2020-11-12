#!/usr/bin/bash -x



echo "#!/usr/bin/bash -x" > tarupdatesfromview_${1}.sh

echo "touch emptyfile" >> tarupdatesfromview_${1}.sh

echo "tar cvf ${1}.tar emptyfile" >> tarupdatesfromview_${1}.sh



cat ${1} | grep New: > tmp.in

cat ${1} | grep Updated: >> tmp.in



#echo "/.*lost+found.*/p"> ClearNonRelevant.sed

#cat tmp.in | sed -nf ClearNonRelevant.sed > tmp.in





echo "s/.*vobs\/\([a-zA-Z0-9_\./]*\) .*/tar rvf ${1}.tar .\/vobs\/\1/g" > tarupdatesfromview.sed

#echo "s/\/dev-newton//g" >> checkout.sed

sed -f tarupdatesfromview.sed tmp.in >> tarupdatesfromview_${1}.sh

echo "rm emptyfile" >> tarupdatesfromview_${1}.sh

#rm tmp.in

rm tarupdatesfromview.sed



#echo "s/\/home\/$USER\(.*\)/cleartool ci -nc \/home\/$REPLACE_WITH_USER\1/g" > checkin.sed

#echo "s/\/dev-newton//g" >> checkin.sed



#sed -f checkin.sed checkout.log >> checkin.sh

#rm checkin.sed



#if [ "${1}" == "" ]; then

#	echo "s/\/home\/$USER\/dev-newton\(.*\)/cp \/home\/$USER\/dev-newton\1 \/home\/$REPLACE_WITH_USER\1/g" > copytoview.sed

#else

#	echo "s/\/home\/$USER\(.*\)/cp \/home\/$USER\1 \/home\/$REPLACE_WITH_USER\1/g" > copytoview.sed

#fi

#sed -f copytoview.sed checkout.log >> copytoview.sh

#rm copytoview.sed



#chmod 777 checkout.sh

#chmod 777 checkin.sh

chmod 777 tarupdatesfromview_${1}.sh

./tarupdatesfromview_${1}.sh

