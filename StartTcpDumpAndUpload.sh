#!/usr/bin/bash

export TIMEOUT=60;

if [ "${2}" != "" ]; then	
	export TIMEOUT=${2};
fi

~/dev-newton/scripts/StartSSHCommandAndUpload.sh ${1} "tcpdump -i any  -vv host 10.16.12.196 or sctp or udp port 5060 or udp port 2427 or udp port 2727 -w /tmp/CSP-\$(hostname).pcap & sleep ${TIMEOUT}s; pkill -SIGINT tcpdump" "/tmp/CSP-*.pcap /tmp/"
