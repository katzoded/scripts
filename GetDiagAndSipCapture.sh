export TIMEOUT=${1};
export LOGPATH=${2};
export HOST_IP=${3};
export RUN_ANALYSIS=${4};
export SSH_USER=root;
export BASENAME=$(basename ${LOGPATH});
export DIRNAME=$(dirname ${LOGPATH});

if [ "${5}" != "" ]; then	
	export SSH_USER=${5};
fi

export SIP_CAPTURE_NAME_BEFORE_CALL=$(ssh ${SSH_USER}@${HOST_IP} "sh ~/dev-newton/scripts/WatchSipCapture.sh");
~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "rm -rf ${LOGPATH};pkill -9 diagmgr; mkdir ${LOGPATH}; /opt/bnet/tools/xmldiagmgr config.xml.sbc.sip ${LOGPATH} & sleep ${TIMEOUT}; pkill -9 diagmgr; tar cvf ${LOGPATH}Diag.tar ${LOGPATH}; gzip -f ${LOGPATH}Diag.tar; rm -rf ${LOGPATH};" "${LOGPATH}Diag.tar.gz ${LOGPATH}Diag.tar.gz";
export SIP_CAPTURE_NAME_AFTER_CALL=$(ssh ${SSH_USER}@${HOST_IP} "sh ~/dev-newton/scripts/WatchSipCapture.sh");

if [ "${RUN_ANALYSIS}" == "y" ]; then
   pushd /
   export SCS_FILE_NAME=\/$(tar xvf ${LOGPATH}Diag.tar.gz | grep SCS);
   popd
   echo "SCS_FILE_NAME = ${SCS_FILE_NAME}"
   mkdir ${SCS_FILE_NAME}.dir
   mv ${SCS_FILE_NAME} ${SCS_FILE_NAME}.dir
   echo ${SCS_FILE_NAME}.dir/$(basename ${SCS_FILE_NAME}) | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "~/dev-newton/scripts/ExtractMessagesFromBnetLog.sh \1 '.*PIN HOLE ##########'; ~/dev-newton/scripts/CreateBnetFlowDiag.pl \1" | sh;
fi;


export SCP_COMMAND=$(echo "${SIP_CAPTURE_NAME_BEFORE_CALL}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "scp ${SSH_USER}@${HOST_IP}:\1 ${LOGPATH}/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_BEFORE_CALL})");
echo "${SCP_COMMAND}";


${SCP_COMMAND};
if [ "${SIP_CAPTURE_NAME_AFTER_CALL}" != "${SIP_CAPTURE_NAME_BEFORE_CALL}" ]; then	
    export SCP_COMMAND=$(echo "${SIP_CAPTURE_NAME_AFTER_CALL}" | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "scp ${SSH_USER}@${HOST_IP}:\1 ${LOGPATH}/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_AFTER_CALL})");
    echo "${SCP_COMMAND}";
    ${SCP_COMMAND};
fi;

if [ "${RUN_ANALYSIS}" == "y" ]; then
   mv ${LOGPATH}/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_BEFORE_CALL}) ${SCS_FILE_NAME}.dir
   mv ${LOGPATH}/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_AFTER_CALL}) ${SCS_FILE_NAME}.dir
   
   gzip -d -f ${SCS_FILE_NAME}.dir/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_BEFORE_CALL})
   gzip -d -f ${SCS_FILE_NAME}.dir/${BASENAME}.$(basename ${SIP_CAPTURE_NAME_AFTER_CALL})
fi;

if [ "${RUN_ANALYSIS}" == "y" ]; then
   mv ${LOGPATH}.pcap ${SCS_FILE_NAME}.dir
   pushd ${SCS_FILE_NAME}.dir
   /cygdrive/c/Program\ Files/Wireshark/mergecap.exe -w Merged$(basename ${LOGPATH}.pcap) *.pcap
   popd
fi;
