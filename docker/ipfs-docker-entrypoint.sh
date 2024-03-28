#!/bin/bash
echo "Starting ipfs service"
while [ ! -f /opt/${BASE_NAME}/.tor_ready ]; do
  sleep 2 # or less like 0.2
  echo "tor not ready yet..."
done
echo "Check free space..."
if [[ "${SKIPSPCECHECK}" != "1" ]]; then
  FREE=`df -k --output=avail "$PWD" | tail -n1`
  if [[ $FREE -lt 2485760 ]]; then
    echo "ERROR: Not enough free space"  # 2G = 2*1024*1024k
    exit 1
  fi
fi
echo "Configure ipfs ..."
export hs_directory="/root/hidden_service"
if [[ "${INITIALIZE_IPFS}" == "true" ]]; then
  if [ ! -f /root/.ipfs/config ]; then
    source /opt/${BASE_NAME}/ipfs.${PP_ENV}.cfg
    echo /onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID}
    rm -rf /root/.ipfs/*
    if [[ "${role}" == "hs_client" ]]; then
      selfHsHostname="$(sed 's/[.].*$//' ${hs_directory}/hsv3/hostname)"
      /opt/${BASE_NAME}/ipfs init --announce=/onion3/${selfHsHostname}:4001 \
          --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
          --torPath=/usr/local/bin/tor \
          --torConfigPath=/usr/local/etc/tor/torrc \
          --dhtRoutingType=dhtserver
      echo "Run as node"
    else
      /opt/${BASE_NAME}/ipfs init \
          --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} \
          --torPath=/usr/local/bin/tor \
          --torConfigPath=/usr/local/etc/tor/torrc \
          --dhtRoutingType=dhtserver
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
sed -i 's/"StorageMax": "10GB"/"StorageMax": "1024GB"/g' /root/.ipfs/config

function addSomFileToIPFS() {
  sleep 30
  echo "Create ipfs check files ipfs ..."
  echo "${ipfsSuperPeerID} is online!!" > /root/.ipfs/ipfstestfile.txt
  /opt/${BASE_NAME}/ipfs add -q /root/.ipfs/ipfstestfile.txt > /root/.ipfs/ipfs_test_cid.txt
  echo "Try get file from ipfs ..."
  /opt/${BASE_NAME}/ipfs cat QmSq9TVkhM4r4ctHE3YgCvqnWxWqQcyjEgLXxFQMpEU1HG
}
function ipfsFill(){
  echo "Ipfs fill will start each 86400 seconds (24 hours)"
  while [ "false" != "true" ]; do
    sleep 86400
    echo "Ipfs fill start"
    /opt/${BASE_NAME}/ipfs fill
    echo "Ipfs fill end"
  done
}
ipfsFill &
addSomFileToIPFS &
echo "Start ipfs daemon ..."
if [ $# -eq 0 ]
then
  if [[ "${ipfs_debug}" != "1" ]]; then
    /opt/${BASE_NAME}/ipfs daemon | mark "Daemon is ready" "/opt/${BASE_NAME}/.ipfs_ready" >> /opt/${BASE_NAME}/logs/ipfs.log
  else
    /opt/${BASE_NAME}/ipfs daemon --debug | mark "Daemon is ready" "/opt/${BASE_NAME}/.ipfs_ready" >> /opt/${BASE_NAME}/logs/ipfs.log
  fi
else
    exec "$@" | mark "Daemon is ready" "/opt/${BASE_NAME}/.ipfs_ready" >> /opt/${BASE_NAME}/logs/ipfs.log
fi
