#!/bin/bash
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
) 
set +H
for x in "${\!repos[@]}"; do printf "[%s]=%s\n" "$x" "${repos[$x]}" ; done
   
   

ARRAY=( 
"go-ipfs|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-ipfs"
"go-libp2p-core|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p-core"
"go-libp2p|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p"
"go-bitswap|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-bitswap"
"go-libp2p-swarm|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-libp2p-swarm"
"go-multiaddr|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-multiaddr"
"go-ipfs-config|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-ipfs-config"
"go-multiaddr-net|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-multiaddr-net" 
"go-eventbus|git@ssh.dev.azure.com:v3/paidpiper2020/PaidPiper/go-eventbus"
)
reposlist=(go-ipfs go-libp2p-core go-libp2p go-bitswap go-libp2p-swarm go-multiaddr go-ipfs-config go-eventbus)

reposlistFull=("${reposlist[@]}" go-multiaddr-net)
for folder in "${reposlist[@]}"; 
do
    cd ${folder}
    #git checkout pp_master
    #echo -e "${folder}\t$(git rev-parse --abbrev-ref HEAD)"
    echo -e "${folder}\t$(git remote get-url origin)"
    
    #git push -u origin pp_master
    cd ../
done

array=( one two three )
for i in "${array[@]}"
do
   echo $i
done

for key in "${repos[@]}"; do echo $key; done

for folder in "${repos[@]}"; 
do 
    echo "$folder - ${repos[$folder]}"; 
done
for folder in ${reposlistFull[@]}; 
do
    cd ${folder}
    echo -e "[${folder}]=\"$(git remote get-url origin)\""
    cd ../
done
for folder in ${reposlistFull[@]}; 
do
    cd ${folder}
    git remote set-url origin ${repos[$folder]}
    cd ../
done



for row in "${ARRAY[@]}" ; do
    KEY="${row%%|*}"
    VALUE="${row##*|}"
    cd ${KEY}
    echo -e "${folder}\t$(git rev-parse --abbrev-ref HEAD)"
    cd ../
done;
#git push -u origin pp_master
#git remote set-url origin ${VALUE}
# rebase cancel
for folder in ${reposlist[@]}; 
do
    cd ${folder}
    git rebase --abort
    git checkout pp_master_prev
    git branch -f pp_master pp_master_prev
    cd ../
done
# go-ipfs go-bitswap go-multiaddr go-ipfs-config go-eventbus
# go-libp2p-core go-libp2p go-libp2p-swarm  go-ipfs-config
for folder in ${reposlist[@]}; 
do  
    cd ${folder}
    git reset --soft $(git merge-base pp_master github/master)
    cd ../
done
for folder in ${reposlist[@]}; 
do
    cd ${folder}
    git reset --soft pp_master_prev
    cd ../
done


if [[ $(ls -A) ]]; then
    echo "there are files"
else
    echo "no files found"
fi
if [ -z $(git tag --merged pp_master | grep ^v0.6.0$) ]; then echo need update; fi




for folder in go-ipfs go-libp2p-core go-libp2p go-bitswap go-libp2p-swarm go-multiaddr go-ipfs-config go-eventbus; 
do
    cd ${folder}
    git checkout pp_master
    git branch pp_master_prev
    cd ../
done
