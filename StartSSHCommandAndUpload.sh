#!/usr/bin/bash

export SSH_USER=root;



if [ "${4}" != "" ]; then	

	export SSH_USER=${4};

fi



ssh ${SSH_USER}@${1} "${2}"; scp ${SSH_USER}@${1}:${3};

