#!/bin/bash

# This script provides idempotent initialization and finally runs the indy node inside the docker container

date -Iseconds

echo "INDY_NETWORK_NAME=${INDY_NETWORK_NAME:=sandbox}"
echo "WALLET_NAME=${WALLET_NAME:=MyWallet}"
echo "CFG_FILE=${CFG_FILE:=/home/indy/cfg/cliconfig.json}"

echo "WALLET_KEY=[$(echo -n $WALLET_KEY|wc -c) characters]"
echo "INDY_STEWARD_SEED=[$(echo -n $INDY_STEWARD_SEED|wc -c) characters]"



# Init indy-node
#if [[ ! -d "/var/lib/indy/$INDY_NETWORK_NAME/keys" ]]
#then
    echo -e "[...]\t No Wallet found. Creating Wallet"


echo "wallet create $WALLET_NAME key=$WALLET_KEY" > wallet_create
echo "wallet open $WALLET_NAME key=$WALLET_KEY" >> wallet_create
echo "did new seed=$INDY_STEWARD_SEED" >> wallet_create
echo "did new seed=$INDY_ENDORSER_SEED" >> wallet_create
echo "did list" >> wallet_create

if indy-cli --config $CFG_FILE wallet_create
then
        echo -e "[OK]\t Wallet and dids created"
else
    echo -e "[FAIL]\t Could not create wallet/dids"
fi
    rm wallet_create


    #else
#    echo -e "[OK]\t Keys directory exists, skipping init."
#fi

#USER root
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]

echo -e "[...]\t Running indy-cli"


exec ./ttyd -p 8080 indy-cli --config $CFG_FILE
