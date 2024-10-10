#!/bin/bash
while [ ! -f /opt/paidpiper/.tor_ready ]; do
  sleep 2 # or less like 0.2
  echo "tor not ready yet..."
done
#torDataDir="/Users/tumarsal/tor"
export hs_directory="/root/hidden_service"
if [[ "${no_conf}" != "1" ]]; then
  if [ ! -f /root/.ipfs/config ]; then 
    source /opt/paidpiper/ipfs.${PP_ENV}.cfg
    echo /onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID}
    rm -rf /root/.ipfs/*
    if [[ "${role}" == "hs_client" ]]; then
      selfHsHostname="$(sed 's/[.].*$//' ${hs_directory}/hsv3/hostname)"
      /opt/paidpiper/ipfs init --announce=/onion3/${selfHsHostname}:4001 \
          --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
          --torPath=/usr/local/bin/tor \
          --torConfigPath=/usr/local/etc/tor/torrc
      echo "Run as node"
    else 
      /opt/paidpiper/ipfs init \
          --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
          --torPath=/usr/local/bin/tor \
          --torConfigPath=/usr/local/etc/tor/torrc
      echo "Run as client "
    fi  
  fi  
fi
function mark {
  match=$1
  file=$2
  mark=1
  while read -r data; do
    echo $data
    if [[ $data == *"$match"* ]]; then 
      if [[ "$mark" == "1" ]]; then 
        echo "done" >> $file
        mark=0
      fi
    fi
  done
}
SEDOPTION="-i "
if [[ "$OSTYPE" == "darwin"* ]]; then
  SEDOPTION="-i ''"
fi

sed $SEDOPTION -e 's|/ip4/127.0.0.1/tcp/5001|/ip4/0.0.0.0/tcp/5001|g' /root/.ipfs/config 
sed $SEDOPTION -e 's|/ip4/127.0.0.1/tcp/8080|/ip4/0.0.0.0/tcp/8080|g' /root/.ipfs/config
if [ $# -eq 0 ]
then
  if [[ "${ipfs_debug}" != "1" ]]; then
    /opt/paidpiper/ipfs daemon --debug | mark "Daemon is ready" "/opt/paidpiper/.ipfs_ready"
  else 
    /opt/paidpiper/ipfs daemon | mark "Daemon is ready" "/opt/paidpiper/.ipfs_ready"
  fi
   
else 
    exec "$@" | mark "Daemon is ready" "/opt/paidpiper/.ipfs_ready"
fi
