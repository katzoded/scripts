#!/usr/bin/bash -x

export SSH_USER=root;



if [ "${4}" != "" ]; then	

	export SSH_USER=${4};

fi



scp ${SSH_USER}@${1}:${3}; ssh ${SSH_USER}@${1} "${2}"; 

