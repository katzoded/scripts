export FIRST_SIPCAPTURE_FILE=${1};
export DIRNAME=${2};
export HOST_IP=${3};
export SSH_PASS=${5};
export SSH_USER=root;

if [ "${4}" != "" ]; then	
	export SSH_USER=${4};
fi
~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "
cd /archive/SIP_capture/; 
export a=\$(ls -ltr | grep -n SIPmsg_ | grep $(basename ${FIRST_SIPCAPTURE_FILE}) | cut -d: -f1);
export b=\$(ls -ltr | grep -n SIPmsg_ | tail -1 | cut -d: -f1);
if [ '\${a}' == '' ]; then
    echo 'Start file \${FIRST_SIPCAPTURE_FILE} is Empty - nothing to download'
else
    echo a=\${a}, b=\${b} b-a=\$(expr \$b - \$a);
    ls -ltr  | grep -n SIPmsg_ | tail -\$(expr \$b - \$a + 1)| grep -v ' 0 ' | awk  '{print \$9}' | xargs tar zcvf ${DIRNAME}/SIP_Capture.tar.gz;
fi" "${DIRNAME}/SIP_Capture.tar.gz ${DIRNAME}/SIP_Capture.tar.gz" "${SSH_USER}" "${SSH_PASS}"