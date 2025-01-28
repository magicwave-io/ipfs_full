#!/bin/bash

echo $PP_ENV
source ipfs.${PP_ENV}.cfg
echo /onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID}


../ipfs init --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
            --torPath=/usr/local/bin/tor \
            --torConfigPath=/usr/local/etc/tor/torrc \
            --dhtRoutingType=dhtserver

