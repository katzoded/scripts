#!/usr/bin/bash -x

echo "#!/usr/bin/bash -x" > copyupdatesfromview.sh

cat ${1} | grep New: > tmp.in
cat ${1} | grep Updated: >> tmp.in

#echo "s/\/home\/$USER\(.*\)/cleartool co -nc \/home\/$REPLACE_WITH_USER\1/g" > checkout.sed
#echo "s/\/dev-newton//g" >> checkout.sed
#sed -f checkout.sed checkout.log >> checkout.sh
#rm checkout.sed

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
chmod 777 copyupdatesfromview.sh
