export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};

export RUN_ANALYSIS=${4};

export SSH_USER=root;
export SSH_PASS=${6};
export SSH_PASS_COMMAND=

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});



if [ "${5}" != "" ]; then	

	export SSH_USER=${5};

fi

if [ "${SSH_PASS}" != "" ]; then	

	export SSH_PASS_COMMAND="sshpass -p ${SSH_PASS}"

fi


export SIP_CAPTURE_NAME_BEFORE_CALL=$(${SSH_PASS_COMMAND} ssh ${SSH_USER}@${HOST_IP} "ls -ltr /archive/SIP_capture/ | awk  '{print \$9}' | sort | tail -1");
echo "First SIP Capture file to download ${SIP_CAPTURE_NAME_BEFORE_CALL}";

~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "rm -rf ${LOGPATH};pkill -9 diagmgr; mkdir -p ${LOGPATH}; /opt/bnet/tools/xmldiagmgr config.xml.sbc.sip ${LOGPATH} & sleep ${TIMEOUT}; pkill -9 diagmgr; tar cvf ${LOGPATH}Diag.tar ${LOGPATH}; gzip -f ${LOGPATH}Diag.tar; rm -rf ${LOGPATH};" "${LOGPATH}Diag.tar.gz ${LOGPATH}Diag.tar.gz" "${SSH_USER}" "${SSH_PASS}";



if [ "${RUN_ANALYSIS}" == "y" ]; then

   pushd /

   export SCS_FILE_NAME=\/$(tar xvf ${LOGPATH}Diag.tar.gz | grep SCS);

   popd

   echo "SCS_FILE_NAME = ${SCS_FILE_NAME}"

   mkdir -p ${SCS_FILE_NAME}.dir

   mv ${SCS_FILE_NAME} ${SCS_FILE_NAME}.dir

   echo ${SCS_FILE_NAME}.dir/$(basename ${SCS_FILE_NAME}) | ~/dev-newton/scripts/NoFileCreationReplaceFileList.sh "\(.*\)" "~/dev-newton/scripts/ExtractMessagesFromBnetLog.sh \1 '.*PIN HOLE ##########'; ~/dev-newton/scripts/CreateBnetFlowDiag.pl \1" | sh;

fi;


echo ~/dev-newton/scripts/UploadSipCaptures.sh "${SIP_CAPTURE_NAME_BEFORE_CALL}" "${DIRNAME}" "${HOST_IP}" "${SSH_USER}" "${SSH_PASS}";

~/dev-newton/scripts/UploadSipCaptures.sh "${SIP_CAPTURE_NAME_BEFORE_CALL}" "${DIRNAME}" "${HOST_IP}" "${SSH_USER}" "${SSH_PASS}";
#~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "cd /archive/SIP_capture/; export a=\$(ls -ltr | grep -v -n ' 0 ' | grep $(basename ${SIP_CAPTURE_NAME_BEFORE_CALL}) | cut -d: -f1); export b=\$(ls -ltr | grep -v -n ' 0 ' | tail -1 | cut -d: -f1); ls -ltr | grep -v ' 0 ' | tail -\$(expr \$b - \$a)| awk  '{print \$9}' | xargs tar zcvf ${DIRNAME}/SIP_Capture.tar.gz;" "${DIRNAME}/SIP_Capture.tar.gz ${DIRNAME}/SIP_Capture.tar.gz" "${SSH_USER}";


if [ "${RUN_ANALYSIS}" == "y" ]; then

   mv ${DIRNAME}/SIP_Capture.tar.gz ${SCS_FILE_NAME}.dir
   mv ${LOGPATH}.pcap.gz ${SCS_FILE_NAME}.dir
   pushd ${SCS_FILE_NAME}.dir
   tar xvf  SIP_Capture.tar.gz
   gzip -d -f *.pcap.gz
   /cygdrive/c/Program\ Files/Wireshark/mergecap.exe -w Merged$(basename ${LOGPATH}.pcap) *.pcap

   popd

fi;


