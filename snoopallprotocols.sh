#/usr/bin/tcsh -x

snoop -d $2 -o $1 udp port 2944 or udp port 5060 or udp port 2427 or sctp port 2905 or sctp 9900

