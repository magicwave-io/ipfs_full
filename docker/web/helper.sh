cmd=$1
if [ "$cmd" = "start" ];then
    workspace=$PWD
    if [ -f $filePath ];then
        source ./.workspace_confg
    fi 
   

    if [ "seed" = "" ]; then 
        read -p "Enter your seed:" seed
    fi 

    if [ "nickname" = "" ]; then 
        #defaultNickname=$(curl -X GET -u torpluse-api-payment-ny4KQDf3:acbhKTwXnPJRpcAMMXPRNJc7TaWx5busFqFP7beQYZLayYvtmQdEeGvAdRJwTbusNpuCnj7hu2kTSqmzLVQP7Tn4zFep7N2pTXnp https://api-payment.torplus.com/api/backend/randomNickname)"
        #read -p "Enter your nickname($defaultNickname):" nick
        read -p "Enter your nickname:" nick
    fi 
    docker run \
            --name torplusipfs \
            -p 28000:28080 \
            -e nickname=${nickname} \
            -e PP_ENV=stage \
            -e seed=${seed} \
            -v ${workspace}/static:/root/static \
            -v ${workspace}/tor:/root/tor \
            -v ${workspace}/ipfs:/root/.ipfs \
            -v ${workspace}/hidden_service:/root/hidden_service \
            --rm \
            magicwaveio/production:ipfs-latest
    echo "nick=$nick" > ./.workspace_confg
    echo "seed=$seed" > ./.workspace_confg
fi 
if [ "$cmd" = "add" ];then
    if [ -f $filePath ];then
        source ./.workspace_confg
    else 
        echo "workspace_confg not exists"
        exit 1 
    fi  

    filePath=$2

    if [ ! -f $filePath ];then
        echo "File not found"
    fi 

    f="$(basename -- $filePath)"
    cp $filePath ./static/$f
    docker exec ipfs_host ipfs add /root/static/$f
    rm  ./static/$f

fi 




