export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};

export XML_FILENAME=${4};

export CAPTURE_FILTER=${5};

export EMS_HOST_IP=${6};

export SSH_USER=root;

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});



if [ "${7}" != "" ]; then	

	export SSH_USER=${7};

fi


scp ~/dev-newton/scripts/GetDiagPlusPcapCapture-CS.sh ${SSH_USER}@${EMS_HOST_IP}:~/dev-newton/scripts/
scp ~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${SSH_USER}@${EMS_HOST_IP}:~/dev-newton/scripts/
scp ~/dev-newton/scripts/GetDiag-CS.sh ${SSH_USER}@${EMS_HOST_IP}:~/dev-newton/scripts/

export DIAGMNGR_COMMAND="~/dev-newton/scripts/GetDiag-CS.sh ${TIMEOUT} ${LOGPATH} ${HOST_IP} ${XML_FILENAME} ${SSH_USER}";
export TCPDUMP_COMMAND="~/dev-newton/scripts/StartSSHCommandAndUpload.sh \"${HOST_IP}\" \"mkdir $(dirname ${LOGPATH}.pcap); pkill -9 tcpdump; tcpdump -i any -vv ${CAPTURE_FILTER} -w ${LOGPATH}.pcap & sleep ${TIMEOUT}; pkill -SIGINT tcpdump; gzip -f ${LOGPATH}.pcap\" \"${LOGPATH}.pcap.gz ${LOGPATH}.pcap.gz\" ${SSH_USER}";

~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${EMS_HOST_IP}" "${TCPDUMP_COMMAND}" "${LOGPATH}.pcap.gz ${LOGPATH}.pcap.gz" ${SSH_USER} &

~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${EMS_HOST_IP}" "${DIAGMNGR_COMMAND}" "/tmp/Diag.tar.gz /tmp"  "${SSH_USER}";



