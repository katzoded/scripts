#!/bin/bash -x

export PBX_IP=$1
export LOCAL_INTERFACE_IP=$2
export DEST_PORT=$3
export PROTOCOL=$4


if grep "net.ipv4.ip_forward = 1"  /etc/sysctl.conf; then
	echo "ip forwarding is already on"
else
	echo "ip forwarding is not on, please do edit vi /etc/sysctl.conf"
	echo "change net.ipv4.ip_forward from 0 to 1"
	echo "sysctl -p"
	exit
fi

#iptables -t nat -A PREROUTING -d [the source of the packet] -p [protocol] -m [modified protocol] --dport [dest port] -j DNAT --to-destination [change to dest  IP]
iptables -t nat -D PREROUTING -d ${LOCAL_INTERFACE_IP} -p ${PROTOCOL} -m ${PROTOCOL} --dport ${DEST_PORT} -j DNAT --to-destination ${PBX_IP}

#iptables -t nat -A POSTROUTING -d [the source of the packet after changing] -p [protocol] -m [modified protocol] --dport [dest port] -j SNAT --to-source [change to src IP]
iptables -t nat -D POSTROUTING -d ${PBX_IP}/32 -p ${PROTOCOL} -m ${PROTOCOL} --dport ${DEST_PORT} -j SNAT --to-source ${LOCAL_INTERFACE_IP}    

service iptables save;
service iptables reload;
