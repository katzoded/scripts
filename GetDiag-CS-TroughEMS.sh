export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};

export XML_FILENAME=${4};

export EMS_HOST_IP=${5};

export SSH_USER=root;

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});



if [ "${6}" != "" ]; then	

	export SSH_USER=${6};

fi


scp ~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${SSH_USER}@${EMS_HOST_IP}:~/dev-newton/scripts/
scp ~/dev-newton/scripts/GetDiag-CS.sh ${SSH_USER}@${EMS_HOST_IP}:~/dev-newton/scripts/

export DIAGMNGR_COMMAND="~/dev-newton/scripts/GetDiag-CS.sh ${TIMEOUT} ${LOGPATH} ${HOST_IP} ${XML_FILENAME} ${SSH_USER}";


~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${EMS_HOST_IP}" "${DIAGMNGR_COMMAND}" "${DIRNAME}/Diag.tar.gz /tmp"  "${SSH_USER}";



