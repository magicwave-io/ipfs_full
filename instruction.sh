#!/bin/bash

#ipfsVersion=v0.7.0
ipfsVersionDefault="v0.8.0"

ipfsVersion=$1
echo ${ipfsVersion:=$ipfsVersionDefault}

echo "\n"
echo "For update IPFS to => ${ipfsVersion}"

libp2pCoreVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep libp2p/go-libp2p-core\ v | awk '{print $2}')
libp2pVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep libp2p/go-libp2p\ v | awk '{print $2}')
bitswapVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep ipfs/go-bitswap\ v | awk '{print $2}')
libp2pSwarmVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep libp2p/go-libp2p-swarm\ v | awk '{print $2}')
multiaddrVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep multiformats/go-multiaddr\ v | awk '{print $2}')
ipfsConfigVersion=$(cd go-ipfs && git show refs/tags/${ipfsVersion}:go.mod | grep ipfs/go-ipfs-config\ v | awk '{print $2}')
eventbusVersion=$(cd go-libp2p && git show refs/tags/${libp2pVersion}:go.mod | grep libp2p/go-eventbus\ v | awk '{print $2}')


echo "Need rebase:"

if [ -z $(cd go-ipfs && git tag --merged pp_master | grep ^v${ipfsVersion}$) ]; then echo "go-ipfs => ${ipfsVersion}"; fi
if [ -z $(cd go-libp2p-core && git tag --merged pp_master | grep ^v${libp2pCoreVersion}$) ]; then echo "go-libp2p-core => ${libp2pCoreVersion}"; fi
if [ -z $(cd go-libp2p && git tag --merged pp_master | grep ^v${libp2pVersion}$) ]; then echo "go-libp2p => ${libp2pVersion}"; fi
if [ -z $(cd go-bitswap && git tag --merged pp_master | grep ^v${bitswapVersion}$) ]; then echo "go-bitswap => ${bitswapVersion}"; fi
if [ -z $(cd go-libp2p-swarm && git tag --merged pp_master | grep ^v${libp2pSwarmVersion}$) ]; then echo "go-libp2p-swarm => ${libp2pSwarmVersion}"; fi
if [ -z $(cd go-multiaddr && git tag --merged pp_master | grep ^v${multiaddrVersion}$) ]; then echo "go-multiaddr => ${multiaddrVersion}"; fi
if [ -z $(cd go-ipfs-config && git tag --merged pp_master | grep ^v${ipfsConfigVersion}$) ]; then echo "go-ipfs-config => ${ipfsConfigVersion}"; fi
if [ -z $(cd go-eventbus && git tag --merged pp_master | grep ^v${eventbusVersion}$) ]; then echo "go-eventbus => ${eventbusVersion}"; fi



