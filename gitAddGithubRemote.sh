#!/bin/zsh

declare -A repos=(
[go-ipfs]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-ipfs"
[go-libp2p-core]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p-core"
[go-libp2p]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p"
[go-bitswap]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-bitswap"
[go-libp2p-swarm]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p-swarm"
[go-multiaddr]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-multiaddr"
[go-ipfs-config]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-ipfs-config"
[go-multiaddr-net]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-multiaddr-net"
[go-eventbus]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-eventbus"
[go-libp2p-kad-dht]="git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p-kad-dht"
);

declare -A gitHubRepos=(
[go-ipfs]="git@github.com:ipfs/go-ipfs.git"
[go-libp2p-core]="git@github.com:libp2p/go-libp2p-core.git"
[go-libp2p]="git@github.com:libp2p/go-libp2p.git"
[go-bitswap]="git@github.com:ipfs/go-bitswap.git"
[go-libp2p-swarm]="git@github.com:libp2p/go-libp2p-swarm.git"
[go-multiaddr]="git@github.com:multiformats/go-multiaddr.git"
[go-ipfs-config]="git@github.com:ipfs/go-ipfs-config.git"
[go-multiaddr-net]="git@github.com:multiformats/go-multiaddr-net.git"
[go-eventbus]="git@github.com:libp2p/go-eventbus.gits"
[go-libp2p-kad-dht]="git@github.com:libp2p/go-libp2p-kad-dht.git"
)

set +H
for key value in ${(kv)gitHubRepos}; do
    #echo "cd $key && git remote add github $value && cd ../"
    echo "cd $key && git fetch github && cd ../"
done

