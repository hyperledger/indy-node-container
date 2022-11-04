#!/usr/bin/env bash

# skip existing rules to avoid duplicates
add_new_rule() {
    RULE="$@"

    if rule_exists ${RULE}; then
        echo "[skip] $RULE already exists"
    elif [[ "$RULE" == *"DROP"* ]] || [[ "$RULE" == *"RETURN"* ]] || [[ "$RULE" == *"REJECT"* ]]; then
        iptables -A $RULE
        echo "[OK] $RULE added to the end of the chain"
    else
        iptables -I $RULE
        echo "[OK] $RULE added to the beginning of the chain"
    fi
}

make_last_rule() {
    RULE="$@"
    delete_rule ${RULE}
    iptables -A $RULE
    echo "[OK] $RULE added to the end of the chain"
}

rule_exists() {
    RULE="$@"
    if iptables -C ${RULE} 2>/dev/null 1>&2; then
        return 0
    fi
    return 1
}

delete_rule() {
    RULE="$@"
    while rule_exists ${RULE}; do
        iptables -D $RULE
        echo "[OK] $RULE deleted"
    done
}

ip_tables_installed() {
    if which iptables 2>/dev/null 1>&2 && iptables -nL 2>/dev/null 1>&2; then
        return 0
    fi
    return 1
}

ip_tables_persistent_installed() {
    if which iptables-save 2>/dev/null 1>&2; then
        return 0
    fi
    return 1
}

save_rules() {
    if ! ip_tables_persistent_installed; then
        check_setup
        exit 1
    fi
    iptables-save >/etc/iptables/rules.v4
    ip6tables-save >/etc/iptables/rules.v6
    echo "[OK] iptables rules saved"
}

check_setup() {
    cat <<-EOF

    Warning: iptables and/or iptables-persistent is not installed, or permission denied. 

    Please ensure iptables and iptables-persistent are both installed and iptables-persistent is enabled, and try running with sudo.

    # To install iptables-persistent:
    sudo apt-get install -y iptables-persistent

    # Make sure services are enabled on Debian or Ubuntu using the systemctl command:
    sudo systemctl is-enabled netfilter-persistent.service

    # If not enable it:
    sudo systemctl enable netfilter-persistent.service

    # Get status:
    sudo systemctl status netfilter-persistent.service

EOF
}
