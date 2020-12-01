#!/usr/bin/bash -x

export SSH_USER=root;
export SSH_PASS=${5};
export SSH_PASS_COMMAND=



if [ "${4}" != "" ]; then	

	export SSH_USER=${4};

fi


 
 if [ "${SSH_PASS}" != "" ]; then	

	export SSH_PASS_COMMAND="sshpass -p ${SSH_PASS}"

fi

${SSH_PASS_COMMAND} scp ${SSH_USER}@${1}:${3};
${SSH_PASS_COMMAND} ssh ${SSH_USER}@${1} "${2}";


