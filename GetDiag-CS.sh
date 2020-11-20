export TIMEOUT=${1};

export LOGPATH=${2};

export HOST_IP=${3};

export XML_FILENAME=${4};

export SSH_USER=root;

export BASENAME=$(basename ${LOGPATH});

export DIRNAME=$(dirname ${LOGPATH});



if [ "${5}" != "" ]; then	

	export SSH_USER=${5};

fi




~/dev-newton/scripts/StartSSHCommandAndUpload.sh "${HOST_IP}" "pkill -9 diagmgr; cd /opt/IPVRdiagmgr/; ./goxml.param ${XML_FILENAME} | grep somesession | xargs tar cvf ${DIRNAME}/Diag.tar; gzip -f ${DIRNAME}/Diag.tar & sleep ${TIMEOUT}; pkill -9 diagmgr;" "${DIRNAME}/Diag.tar.gz /tmp"  "${SSH_USER}";


