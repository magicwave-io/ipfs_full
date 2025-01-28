#!/bin/bash
cd /root/tor/keys 
tor-gencert --create-identity-key > /dev/null 2>&1
# nickname="$(grep 'Nickname' /opt/paidpiper/tmp.txt | awk '{print $2}')"
# ip="$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')"
fingerprint="$(grep fingerprint /root/tor/keys/* | awk '{print $2}')"
if [ ! -f /root/tor/fingerprint ]; then 
    echo "Tor figerprint not exists" >> /root/tor/keys/error
    exit 1
fi 
fingerprint2="$(cat /root/tor/fingerprint | awk '{print $2}')"

TORENV="DirAuthority ${nickname} orport=5037 v3ident=${fingerprint} ${ip}:7001 ${fingerprint2}"
echo "${TORENV}"
echo $TORENV > /root/tor/keys/da.ini

#DirAuthority cont2 orport=5037 v3ident=284F45F49785C7B9F4E07E2D6865D6C262005404 192.168.0.102:7001 6D82FDA088CFD93193B8A27B5CBF5996494E92E3
