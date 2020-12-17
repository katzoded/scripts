export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};
export CAPTURE_FILTER=${4}
export SSH_USER=root;
export SSH_PASS=${6};
export SSH_PASS_COMMAND=

if [ "${5}" != "" ]; then	
	export SSH_USER=${5};
fi

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});


~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${HOST_IP} "mkdir $(dirname ${LOGPATH}.pcap); pkill -9 tcpdump; tcpdump -i any -vv ${CAPTURE_FILTER} -w ${LOGPATH}.pcap & sleep ${TIMEOUT}; pkill -SIGINT tcpdump; gzip -f ${LOGPATH}.pcap" "${LOGPATH}.pcap.gz ${LOGPATH}.pcap.gz" ${SSH_USER} ${SSH_PASS}
