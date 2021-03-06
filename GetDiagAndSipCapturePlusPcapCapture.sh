if [ "${1}" == "-h" ]; then	

	echo "[1] timeout\n"
	echo "[2] LogPath\n"
	echo "[3] Host IP\n"
	echo "[4] Capture Filter\n"
	echo "[5] y for run analysis of any other for no analysis\n"
	echo "[6] ssh Username if not present root will be used\n"
	echo "[7] ssh password\n"
else
    export TIMEOUT=${1};

    export LOGPATH=${2};

    export HOST_IP=${3};

    export CAPTURE_FILTER=${4}

    export RUN_ANALYSIS=${5};

    export SSH_USER=root;
    export SSH_PASS=${7};

    export BASENAME=$(basename ${LOGPATH});

    export DIRNAME=$(dirname ${LOGPATH});



    if [ "${6}" != "" ]; then	

        export SSH_USER=${6};

    fi

    ~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${HOST_IP} "mkdir $(dirname ${LOGPATH}.pcap); pkill -9 tcpdump; tcpdump -i any -vv ${CAPTURE_FILTER} -w ${LOGPATH}.pcap & sleep ${TIMEOUT}; pkill -SIGINT tcpdump; gzip -f ${LOGPATH}.pcap" "${LOGPATH}.pcap.gz ${LOGPATH}.pcap.gz" ${SSH_USER} ${SSH_PASS}&
    ~/dev-newton/scripts/GetDiagAndSipCapture.sh ${TIMEOUT} ${LOGPATH} ${HOST_IP} ${RUN_ANALYSIS} ${SSH_USER} ${SSH_PASS}   
fi




 
