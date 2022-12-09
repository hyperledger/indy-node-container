#!/usr/bin/env bash

set +x
set -e

source ./ip_tables_utils.sh

usage() {
    echo
    echo "Usage:"
    echo -n "IP_FILE=[path_to_ip_addresses_file, defaults to first argument, env wins ties] "
    echo -n "INTERNAL_PORT=[indy port, default 9701] CLI_PORT=[client port, default 9702] CHAIN=[iptables chain to edit, default DOCKER-USER]"
    echo "$0 INTERFACE IP_FILE"
    echo
    echo "This script will add rules to your ip tables chain CHAIN to allow incoming connections on port INTERNAL_PORT"
    echo "only from ips listed in the IP_FILE. It will also restrict the number of connections to port CLI_PORT to MAX_CONN."
    echo
    echo "The ip adresses file should contain the list of nodes"
    echo "in your network. One ip address per line."
    echo "The network interface INTERFACE should be the physical one used for incoming connections from the internet."
    echo "Positional arguments can be given by environment variables instead. Env takes precedence."
    echo
    echo "This script needs to be run as root/via sudo."
    echo
}

if ! ip_tables_installed; then
    echo "Can not find/use iptables. Did you run this script with root priviledges?"
    usage
    exit 1
fi

INTERFACE=$1
echo "INTERFACE=${INTERFACE:=ens18}"

# check if INTERFACE is set to an inet facing interface
if ! ip a | grep inet | grep "$INTERFACE" >/dev/null; then
    echo "[ERROR] interface '$INTERFACE' does not seem to be an internet facing interface"
    usage
    exit 1
fi

echo "INTERNAL_PORT=${INTERNAL_PORT:=9701}"
echo "CLI_PORT=${CLI_PORT:=9702}"
echo "CLI_PORT_PROTECTION_SCRIPT=${CLI_PORT_PROTECTION_SCRIPT:=./add_ddos_protection_iptables_rule.sh}"
echo "CHAIN=${CHAIN:=DOCKER-USER}"
echo "OVER_ALL_CONN_LIMIT=${OVER_ALL_CONN_LIMIT:=1500}"
echo "CONN_LIMIT_PER_IP=${CONN_LIMIT_PER_IP:=10}"
echo "CONN_RATE_LIMIT_LIMIT=${CONN_RATE_LIMIT_LIMIT:=50}"
echo "CONN_RATE_LIMIT_PERIOD=${CONN_RATE_LIMIT_PERIOD:=60}"


echo "IP_FILE=${IP_FILE:=$2}"
if ! [ -f "$IP_FILE" ]; then
    echo "[ERROR] file '$IP_FILE' not found"
    usage
    exit 1
fi

echo
echo "[...] Setting up iptables white list for ips that may access port ${INTERNAL_PORT} from file ${IP_FILE}"

# 9701 whitelist approach: drop all others INCOMING (-i) connections
add_new_rule $CHAIN -p tcp -i $INTERFACE --dport $INTERNAL_PORT -j DROP

# 9701 create IP whitelist from file
while read -r IP; do
    if [[ "$IP" != "#"* ]] && [[ "$IP" != "" ]]; then
        add_new_rule $CHAIN -p tcp --dport $INTERNAL_PORT -s "$IP" -j ACCEPT
    fi
done <"$IP_FILE"

# make sure, RETURN ist the last rule
make_last_rule $CHAIN -j RETURN

echo "[OK] Connections to ${INTERNAL_PORT} only allowed from white listed ips."
echo
echo "[...] Setting DOS protection on port ${CLI_PORT} via ${CLI_PORT_PROTECTION_SCRIPT}"

$CLI_PORT_PROTECTION_SCRIPT "${CLI_PORT}" "${OVER_ALL_CONN_LIMIT}" "${CONN_LIMIT_PER_IP}" "${CONN_RATE_LIMIT_LIMIT}" "${CONN_RATE_LIMIT_PERIOD}" debug

# make sure, RETURN ist the last rule
make_last_rule $CHAIN -j RETURN

echo "[OK] Rules for connections on port ${CLI_PORT} set."

if ip_tables_persistent_installed; then
    echo "[...] Persisting iptables rules"
    save_rules
else
    echo "[SKIP] 'iptables-persistent' not installed, skipping rules persistence."
fi

echo
echo "[DONE] $0 finished"
echo
