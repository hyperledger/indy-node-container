#!/bin/bash

set -e

usage()
{
    echo "Usage:"
    echo "INTERFACE=[your_network_interface] IP_FILE=[path_to_ip_addresses_file] $0"
    echo "Where the ip adresses file should contain the white list of nodes"
    echo "in your network. One ip address per line."
    echo "The network interface should be the physical one used for incoming connections from the internet"
    echo
    echo "This script needs to be run as root/via sudo."
    echo
}

# skip existing rules to avoid duplicates
add_new_rule()
{
    RULE="$@"

    if iptables -C $RULE 2>/dev/null 1>&2; then
	echo "[skip] $RULE already exists"
    elif [[ "$RULE" == *"DROP"* ]]; then
	iptables -A $RULE
	echo "[ok] $RULE added to the end of the chain"
    else
	iptables -I $RULE
	echo "[ok] $RULE added"
    fi
}

# -h --help --whatever
if ! [ -z "$*" ]; then
    usage
    exit 0
fi


echo "INTERFACE=${INTERFACE:=ens18}"

# check if INTERFACE is set to an inet facing interface
if ! ip a | grep inet | grep "$INTERFACE" >/dev/null; then
    echo "interface $INTERFACE does not seem to be an internet facing interface"
    usage
    exit 1
fi

echo "IP_FILE=${IP_FILE:=idu_ips}"

if ! [ -f "$IP_FILE" ]; then
    echo "file $IP_FILE not found"
    usage
    exit 1
fi



# 9701 whitelist approach: drop all others INCOMING (-i) connections
add_new_rule DOCKER-USER -p tcp -i $INTERFACE --dport 9701 -j DROP

# 9701 create IP whitelist from file
while read IP; do
    add_new_rule DOCKER-USER -p tcp --dport 9701 -s $IP -j ACCEPT
done < "$IP_FILE"

# 9702 connlimit
add_new_rule DOCKER-USER -p tcp --syn --dport 9702 -m connlimit --connlimit-above 16 -j REJECT

