#!/usr/bin/env bash
# This script is intended to run as part of a docker action to extract the ledger state and output it 

set -e

echo -e "[...]\tretrieving ledger status"
curl -vs --retry 5 --retry-delay 5 --max-time 10 http://localhost:9000/status?validators=1 >ledger_state.json
echo -e "[OK]"
echo -e "[...]\tparsing ledger status"
SYNC_STATE_N1=$(jq '.validators[0].Node_info.Catchup_status.Ledger_statuses[] | . == "synced"' ledger_state.json | sort -u)
SYNC_STATE_N2=$(jq '.validators[1].Node_info.Catchup_status.Ledger_statuses[] | . == "synced"' ledger_state.json | sort -u)
SYNC_STATE_N3=$(jq '.validators[2].Node_info.Catchup_status.Ledger_statuses[] | . == "synced"' ledger_state.json | sort -u)
SYNC_STATE_N4=$(jq '.validators[3].Node_info.Catchup_status.Ledger_statuses[] | . == "synced"' ledger_state.json | sort -u)
FRESHNESS_N1=$(jq '.validators[0].Node_info.Freshness_status[].Has_write_consensus' ledger_state.json | sort -u)
FRESHNESS_N2=$(jq '.validators[1].Node_info.Freshness_status[].Has_write_consensus' ledger_state.json | sort -u)
FRESHNESS_N3=$(jq '.validators[2].Node_info.Freshness_status[].Has_write_consensus' ledger_state.json | sort -u)
FRESHNESS_N4=$(jq '.validators[3].Node_info.Freshness_status[].Has_write_consensus' ledger_state.json | sort -u)
UNREACHABLE_N1=$(jq '.validators[0].Pool_info.Unreachable_nodes_count' ledger_state.json)
UNREACHABLE_N2=$(jq '.validators[1].Pool_info.Unreachable_nodes_count' ledger_state.json)
UNREACHABLE_N3=$(jq '.validators[2].Pool_info.Unreachable_nodes_count' ledger_state.json)
UNREACHABLE_N4=$(jq '.validators[3].Pool_info.Unreachable_nodes_count' ledger_state.json)
echo "Node 1 (synced=$SYNC_STATE_N1, write-consensus=$FRESHNESS_N1, unreachable-nodes=$UNREACHABLE_N1): $(jq '.validators[0].Node_info.Catchup_status.Ledger_statuses' ledger_state.json)"
echo "Node 2 (synced=$SYNC_STATE_N2, write-consensus=$FRESHNESS_N2, unreachable-nodes=$UNREACHABLE_N2): $(jq '.validators[1].Node_info.Catchup_status.Ledger_statuses' ledger_state.json)"
echo "Node 3 (synced=$SYNC_STATE_N3, write-consensus=$FRESHNESS_N3, unreachable-nodes=$UNREACHABLE_N3): $(jq '.validators[2].Node_info.Catchup_status.Ledger_statuses' ledger_state.json)"
echo "Node 4 (synced=$SYNC_STATE_N4, write-consensus=$FRESHNESS_N4, unreachable-nodes=$UNREACHABLE_N4): $(jq '.validators[3].Node_info.Catchup_status.Ledger_statuses' ledger_state.json)"
echo "::set-output name=n1_synced::$SYNC_STATE_N1"
echo "::set-output name=n2_synced::$SYNC_STATE_N2"
echo "::set-output name=n3_synced::$SYNC_STATE_N3"
echo "::set-output name=n4_synced::$SYNC_STATE_N4"
echo "::set-output name=n1_freshness::$FRESHNESS_N1"
echo "::set-output name=n2_freshness::$FRESHNESS_N2"
echo "::set-output name=n3_freshness::$FRESHNESS_N3"
echo "::set-output name=n4_freshness::$FRESHNESS_N4"
echo "::set-output name=n1_unreachable::$UNREACHABLE_N1"
echo "::set-output name=n2_unreachable::$UNREACHABLE_N2"
echo "::set-output name=n3_unreachable::$UNREACHABLE_N3"
echo "::set-output name=n4_unreachable::$UNREACHABLE_N4"
