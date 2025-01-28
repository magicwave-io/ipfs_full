#!/bin/bash

# check role
case "$role" in
 client) sleep 1 && echo CLIENT ;;
 dirauth) sleep 1 && echo DIRAUTH ;;
 exit) sleep 1 && echo EXIT ;;
 hs_client) sleep 1 && echo CLIENT ;;
 *) sleep 1 && echo "role value is not valid" && exit 1 ;;
esac

#logpath=/var/log/supervisor/log.log
logpath=/opt/paidpiper/common/${cname}.log
logpathstart=/opt/paidpiper/common/${cname}_start.log
logpathIpfs=/opt/paidpiper/common/ipfs_${cname}.log

#logpath=/var/log/supervisor/log.log
#/usr/local/bin/tor -f /usr/local/etc/tor/torrc

# run dirauth tor as default 
if [ "$role" = "dirauth" ]; then 
  if [ ! -f /root/tor/fingerprint ]; then 
    cp /opt/paidpiper/script/tor.default.config /usr/local/etc/tor/torrc
    #timeout 3s bash -c "/usr/local/bin/tor -f /usr/local/etc/tor/torrc 2>&1 | tee \"${logpath}\""
    /usr/local/bin/tor --list-fingerprint
  fi
  if [ ! -f /root/tor/fingerprint ]; then 
    echo "Tor fingerprint not created"
    echo "Tor fingerprint not created" >> "${logpathstart}"
    exit 1
  fi 
  dirAuthFingerprint="$(cat /root/tor/fingerprint | awk '{print $2}')"
  echo "Generate fingerprint ${dirAuthFingerprint}" >> "${logpathstart}"
fi

export ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')";
export data_directory="/root/tor"
export nickname="${nickname}"
#cat /opt/paidpiper/conf_template/ppgw/config.json | envsubst > /opt/paidpiper/conf/ppgw/

# Generate keys
if [ "${role}" = "dirauth" ]; then 
  sh /opt/paidpiper/script/checkcert.sh 
  touch /opt/paidpiper/common/.${cname}.keygen
fi
#find . -name '*.ini' | xargs -I {} cat {} >> out.param
for key in dirauth1 dirauth2 dirauth3
do 
  while [ ! -f /opt/paidpiper/common/.${key}.keygen ]
  do
    sleep 2 # or less like 0.2
    echo "Wait ${key}"
  done
done 
export dirAuth1="$(cat /opt/paidpiper/common/key1/da.ini)"
export dirAuth2="$(cat /opt/paidpiper/common/key2/da.ini)"
export dirAuth3="$(cat /opt/paidpiper/common/key3/da.ini)"


export ansible_host="${ip}"
export inventory_hostname="${nickname}"
echo "Generate config ${nickname}"

cat /opt/paidpiper/conf_template/tor/${role}_torrc.j2 | envsubst > /usr/local/etc/tor/torrc

function consensusHandler {
  echo "Wait published ns consensus"
  if [ ! -f "${logpath}" ]; then
    touch ${logpath}
  fi
  tail -f ${logpath} | sed '/Published ns consensus/ q'
  
  
  echo "Wait published microdesc consensus"
  tail -f ${logpath} | sed '/Published microdesc consensus/ q'
  touch /opt/paidpiper/common/.${cname}.consensus 
}

function exitSeldTestHandler {
  if [ ! -f ${logpath} ]; then
    touch ${logpath}
  fi
  tail -f ${logpath} | sed '/Performing bandwidth self-test...done/ q'
  touch /opt/paidpiper/common/.${cname}.consensus 
}

if [[ "${role}" = "dirauth" ]]; then 
  echo "dirauth"
  consensusHandler & 
elif [[ "${role}" = "exit" ]]; then 
  exitSeldTestHandler &
fi 


if [[ "${role}" = "exit" ]]; then 
  for key in dirauth1 dirauth2 dirauth3
  do 
    while [ ! -f /opt/paidpiper/common/.${key}.consensus ]
    do
      sleep 2 # or less like 0.2
      echo "Wait Dirauth Consensus ${key}"
    done
  done 
elif [[ "${role}" = "client" ]]; then 
  for key in exit1 exit2 exit3 exit4 exit5
  do 
    while [ ! -f /opt/paidpiper/common/.${key}.consensus ]
    do
      sleep 2 # or less like 0.2
      echo "Wait Exit Consensus ${key}"
    done
  done 
elif [[ "${role}" = "hs_client" ]]; then 
  for key in exit1 exit2 exit3 exit4 exit5
  do 
    while [ ! -f /opt/paidpiper/common/.${key}.consensus ]
    do
      sleep 2 # or less like 0.2
      echo "Wait Exit Consensus ${key}"
    done
  done 
fi 


chmod u=rwx,g=-,o=- /root/tor
cd /root/tor && ls -I keys -I hidden_service -I fingerprint| xargs rm -rf


/usr/sbin/nginx -c /etc/nginx/nginx.conf -g 'daemon off;' &
if [[ "${role}" = "dirauth" ]]; then 
  if [ ! -f /root/tor/fingerprint ]; then 
      echo "Tor fingerprint not exits"
      echo "Tor fingerprint not exits" >> "${logpathstart}"
      exit 1
  else 
    dirAuthFingerprint="$(cat /root/tor/fingerprint | awk '{print $2}')"
    cp /root/tor/fingerprint /root/tor/fingerprint_store
    echo "Tor fingerprint exists: ${dirAuthFingerprint}" >> "${logpathstart}"
  fi 
fi
/usr/local/bin/tor -f /usr/local/etc/tor/torrc 2>&1 | tee "${logpath}" &

if [[ "${role}" = "dirauth" ]]; then 
  sleep 3
  if [[ "${dirAuthFingerprint}" != "$(cat /root/tor/fingerprint | awk '{print $2}')" ]]; then
    echo "Tor fingerprint change from ${dirAuthFingerprint} to $(cat /root/tor/fingerprint | awk '{print $2}')" >> "${logpathstart}"
    echo "fingerprirnt changed" 
    exit 1 
  else 
    echo "Fingerprint equals" >> "${logpathstart}"
  fi
fi

if [[ "${role}" = "client" ]]; then 
  while [ ! -f /opt/paidpiper/common/hidden_service/hsv3/hostname ]; do 
    sleep 2 # or less like 0.2
  done 
  fullOnionAddress="$(cat /opt/paidpiper/common/hidden_service/hsv3/hostname)"
  hsHostname:="$(sed 's/[.].*$//' /opt/paidpiper/common/hidden_service/hsv3/hostname)"
  torify curl ${fullOnionAddress}/index.html
  response="500" 
  while [[ "${response}" != "200" ]]; do
    echo "Try ping hidden service"
    response="$(torify curl --max-time 5.0 --write-out '%{http_code}' --silent --output /dev/null ${fullOnionAddress}/index.html)"
  done
  touch /opt/paidpiper/common/.ping_hs
fi

#ipfs configuration 
#cat /root/tor/hidden_service/hsv3/hostname
# init ipfs super
while [ ! -f /opt/paidpiper/common/hidden_service/hsv3/hostname ]
do
  sleep 2 # or less like 0.2
  echo "Wait hs hostname"
done
sleep 50000

hsHostname="$(sed 's/[.].*$//' /opt/paidpiper/common/hidden_service/hsv3/hostname)"

if [[ "${role}" = "hs_client" ]]; then 
  /opt/paidpiper/ipfs init --announce=/onion3/${hsHostname}:4001 --torPath=/usr/local/bin/tor --torConfigPath=/usr/local/etc/tor/torrc | tee "${logpathIpfs}"
  grep -v "$(jq '.Bootstrap[]' root/.ipfs/config)" root/.ipfs/config > root/.ipfs/temp && \
  mv root/.ipfs/temp root/.ipfs/config
  echo "$(cat /root/.ipfs/config | jq -r '.Identity.PeerID')" > /opt/paidpiper/common/ipfs_super_peer_id
  /opt/paidpiper/ipfs daemon --debug | tee "${logpathIpfs}"

fi

if [[ "${role}" != "hs_client" ]]; then 
  # #init upfs slave
  while [ ! -f /opt/paidpiper/common/.super_init ]
  do
    sleep 2 # or less like 0.2
    echo "Wait super init ${key}"
  done
  ipfsSuperPeerID="$(cat /opt/paidpiper/common/ipfs_super_peer_id)"
  /opt/paidpiper/ipfs init --announce=/onion3/${hsHostname}:4001 --bootStrap=/onion3/${hsHostname}:4001/p2p/${ipfsSuperPeerID} --torPath=/usr/local/bin/tor --torConfigPath=/usr/local/etc/tor/torrc
  /opt/paidpiper/ipfs daemon  2>&1 | tee "${logpathIpfs}" &
 
fi 

 #tail -f ${logpath} | sed '/Daemon is ready/ q' 
#/usr/bin/supervisord
#/usr/local/bin/tor -f /usr/local/etc/tor/torrc 2>&1 | tee "/opt/paidpiper/common/${cname}.log"

#netstat -tulpn
