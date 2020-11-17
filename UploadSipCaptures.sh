export FIRST_SIPCAPTURE_FILE=${1};
export DIRNAME=${2};
export HOST_IP=${3};
export SSH_USER=root;
export BASENAME=$(basename ${LOGPATH});

if [ "${4}" != "" ]; then	
	export SSH_USER=${4};
fi
~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "cd /archive/SIP_capture/; export a=\$(ls -ltr | grep -v -n ' 0 ' | grep $(basename ${FIRST_SIPCAPTURE_FILE}) | cut -d: -f1); export b=\$(ls -ltr | grep -v -n ' 0 ' | tail -1 | cut -d: -f1); ls -ltr | grep -v ' 0 ' | tail -\$(expr \$b - \$a)| awk  '{print \$9}' | xargs tar zcvf ${DIRNAME}/SIP_Capture.tar.gz;" "${DIRNAME}/SIP_Capture.tar.gz ${DIRNAME}/SIP_Capture.tar.gz" "${SSH_USER}";
