
file="ipfs.${PP_ENV}.cfg"

if [[ "${PP_ENV}" = "stage" ]]; then
    hostNamePath=/var/lib/tor/hidden_service_v3/hostname
    bootstrapServer="edikk202@13.95.67.71"
fi

if [[ "${PP_ENV}" = "prod" ]]; then
    hostNamePath=/var/lib/tor/hidden_service_v3/hostname
    bootstrapServer="TorPlus@172.104.247.185"
fi
ssh ${bootstrapServer} "touch ~/.hushlogin"

echo "${PP_ENV}"

#cat /var/lib/tor/hidden_service_v3/hostname
#/var/lib/tor/hidden_service_paidpiper/
fullOnionAddress=$(ssh ${bootstrapServer} "cat ${hostNamePath}")
hsHostname=$(ssh ${bootstrapServer} "sed 's/[.].*$//' ${hostNamePath}")
ipfsSuperPeerID=$(ssh ${bootstrapServer} "cat ~/.ipfs/config | jq -r '.Identity.PeerID'")


echo "hsHostname=${hsHostname}" > $file
echo "ipfsSuperPeerID=${ipfsSuperPeerID}" >> $file
echo "fullOnionAddress=$fullOnionAddress" >> $file
