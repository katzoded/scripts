mkdir /dev-sjcnetapp; /opt/bnet/tools/kbnetcmd 21 1200 130 $(cat /etc/hosts | awk '{print $1}') 0 10.6.0.19 32 0 0 17 1 1 21 1201 130 $(cat /etc/hosts | awk '{print $1}') 0 10.6.0.19 32 0 0 6 1 1 0; mount 10.6.0.19:/enghome /dev-sjcnetapp/

