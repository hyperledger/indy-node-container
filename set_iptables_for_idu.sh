#!/bin/bash


# skip existing rules to avoid duplicates
add_new_rule()
{
    RULE="$@"

    if ! iptables -C $RULE 2>/dev/null 1>&2; then
	iptables -I $RULE
    fi
}


# 9701 whitelist approach: drop all others
add_new_rule DOCKER-USER -p tcp --dport 9701 -j DROP

# 9701 create IP whitelist from file
while read IP; do
    add_new_rule DOCKER-USER -p tcp --dport 9701 -s $IP -j ACCEPT
done < idu_ips

# 9702 connlimit
add_new_rule DOCKER-USER -p tcp --syn --dport 9702 -m connlimit --connlimit-above 16 -j REJECT

