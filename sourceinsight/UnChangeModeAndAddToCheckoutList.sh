#!/usr/bin/bash -x

export ROOT_PATH=$1

echo "#!/usr/bin/bash -x" > ${ROOT_PATH}/uncheckout.sh

cat ${ROOT_PATH}/checkout.log | sed -e 's/\(.*\)/chmod u-w,o-w,g-w \1 /g' >> ${ROOT_PATH}/uncheckout.sh
cat ${ROOT_PATH}/checkout.log >> ${ROOT_PATH}/uncheckout.log

${ROOT_PATH}/uncheckout.sh
rm ${ROOT_PATH}/checkout.log 
exit;
