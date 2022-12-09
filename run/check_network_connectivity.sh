#!/usr/bin/env bash

set +x
set -e

usage() {
    echo
    echo "Usage:"
    echo "$0 [IP_FILE]"
    echo
    echo "Expect a file at IP_FILE (read from env, default to first argument) which contains one IP Adress per non empty non '#' starting line."
    echo "NMAP scan INTERNAL_PORT (read from env, default 9701) on those machines in order to test routing/firewalls."
    echo
}

check_setup() {
    if ! which nmap >>/dev/null; then
        echo
        echo -e "[fail]\t this script uses nmap to scan for open ports. Please install nmap and re-run this script."
        echo
        exit 1
    fi
}

check_connection() {
    nmap -Pn -n -p $INTERNAL_PORT $1
}

main() {

    check_setup

    echo "INTERNAL_PORT=${INTERNAL_PORT:=9701}"
    echo "IP_FILE=${IP_FILE:=$1}"

    if ! [ -f "$IP_FILE" ]; then
        echo -e "[ERROR]\t file '$IP_FILE' not found"
        usage
        exit 1
    fi
    ERRORS=
    while read -r IP; do
        echo -e "[...]\t checking $IP:$INTERNAL_PORT"
        if [[ "$IP" != "#"* ]] && [[ "$IP" != "" ]]; then
            RESULT="$(check_connection $IP)"
            if [[ "$RESULT" == *"open"* ]]; then
                echo "[OK]"
            else
                echo -e "[FAIL]\t port $INTERNAL_PORT not reachable on $IP"
                ERRORS="$ERRORS\n\n$RESULT"
            fi
        fi
    done <"$IP_FILE"
    echo
    if [[ "$ERRORS" != "" ]]; then
        echo -e "[FAIL]\t Not all reachable."
        echo "Errors:"
        echo -e "$ERRORS"
        echo
        exit 1
    else
        echo "[DONE]\t All reachable"
        echo
    fi
}

main $@
