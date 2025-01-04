
#!/bin/bash

#ipfsVersion=v0.7.0
ipfsVersionDefault="v0.8.0"

ipfsVersion=$1
echo ${ipfsVersion:=$ipfsVersionDefault}

echo "\n"
echo "Updating IPFS to => ${ipfsVersion} \n"

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


for folder in go-ipfs go-libp2p-core go-libp2p go-bitswap go-libp2p-swarm go-multiaddr go-ipfs-config go-eventbus; 
do
    cd ${folder}
    pp_master_hash=$(git rev-parse pp_master)
    pp_master_prev_hash=$(git rev-parse pp_master_prev)
    
    if [[ "$pp_master_hash" != "$pp_master_prev_hash" ]]; then
        echo "${folder} pp_master!=pp_master_prev not equal ${pp_master_hash}!=${pp_master_prev_hash}";
        return
    fi
    cd ../
done
if [ -z $(cd go-ipfs && git tag --merged pp_master | grep ^v${ipfsVersion}$) ]; 
  then echo "go-ipfs => ${ipfsVersion}"; fi
if [ -z $(cd go-libp2p-core && git tag --merged pp_master | grep ^v${libp2pCoreVersion}$) ]; 
  then echo "go-libp2p-core => ${libp2pCoreVersion}"; fi
if [ -z $(cd go-libp2p && git tag --merged pp_master | grep ^v${libp2pVersion}$) ]; 
  then echo "go-libp2p => ${libp2pVersion}"; fi
if [ -z $(cd go-bitswap && git tag --merged pp_master | grep ^v${bitswapVersion}$) ]; 
  then echo "go-bitswap => ${bitswapVersion}"; fi
if [ -z $(cd go-libp2p-swarm && git tag --merged pp_master | grep ^v${libp2pSwarmVersion}$) ]; 
  then echo "go-libp2p-swarm => ${libp2pSwarmVersion}"; fi
if [ -z $(cd go-multiaddr && git tag --merged pp_master | grep ^v${multiaddrVersion}$) ]; 
  then echo "go-multiaddr => ${multiaddrVersion}"; fi
if [ -z $(cd go-ipfs-config && git tag --merged pp_master | grep ^v${ipfsConfigVersion}$) ]; 
  then echo "go-ipfs-config => ${ipfsConfigVersion}"; fi
if [ -z $(cd go-eventbus && git tag --merged pp_master | grep ^v${eventbusVersion}$) ]; 
  then echo "go-eventbus => ${eventbusVersion}"; fi

(cd go-ipfs && git rebase ${ipfsVersion} && cd ../  )
(cd go-libp2p-core && git rebase ${libp2pCoreVersion} && cd ../  )
(cd go-libp2p && git rebase ${libp2pVersion} && cd ../  )
(cd go-bitswap && git rebase ${bitswapVersion} && cd ../  )
(cd go-libp2p-swarm && git rebase ${libp2pSwarmVersion} && cd ../  )
(cd go-multiaddr && git rebase ${multiaddrVersion} && cd ../  )
(cd go-ipfs-config && git rebase ${ipfsConfigVersion} && cd ../  )
(cd go-eventbus && git rebase ${eventbusVersion} && cd ../  )
echo "--------------------------------------------"
for folder in go-ipfs go-libp2p-core go-libp2p go-bitswap go-libp2p-swarm go-multiaddr go-ipfs-config go-eventbus; 
do
  cd ${folder}
  (test -d ".git/rebase-merge" || test -d ".git/rebase-apply" && echo "fix conflict in ${folder}") || echo "${folder} has not conflict"  
  cd ../
done
echo "run update complete"
for folder in go-ipfs go-libp2p-core go-libp2p go-bitswap go-libp2p-swarm go-multiaddr go-ipfs-config go-eventbus; 
do
git tag p_v0.8.
done
