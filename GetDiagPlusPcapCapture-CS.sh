export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};

export CAPTURE_FILTER=${4}

export XML_FILENAME=${5};

export SSH_USER=root;

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});



if [ "${5}" != "" ]; then	

	export SSH_USER=${6};

fi

~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${HOST_IP} "mkdir $(dirname ${LOGPATH}.pcap); pkill -9 tcpdump; tcpdump -i any -vv ${CAPTURE_FILTER} -w ${LOGPATH}.pcap & sleep ${TIMEOUT}; pkill -SIGINT tcpdump; gzip -f ${LOGPATH}.pcap" "${LOGPATH}.pcap.gz ${LOGPATH}.pcap.gz" ${SSH_USER} &

~/dev-newton/scripts/GetDiagAndSipCapture-CS.sh ${TIMEOUT} ${LOGPATH} ${HOST_IP} ${XML_FILENAME} ${SSH_USER}

 