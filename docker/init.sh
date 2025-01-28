pp_env=stage
source ipfs.${pp_env}.cfg
echo /onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID}
/opt/paidpiper/ipfs init --announce=/onion3/${hsHostname}:4001 \
    --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
    --torPath=/usr/local/bin/tor \
    --torConfigPath=/usr/local/etc/tor/torrc
