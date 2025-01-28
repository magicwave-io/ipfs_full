Install docker

https://www.docker.com/products/docker-desktop

Docker minimal requirements:
Memory: 512MB RAM (2GB Recommended)
CPU: 2 CORE

Login to docker regestry:
    echo 'ide!$QjNSF@e$8xX' | docker login --username torplusdev --password-stdin

Run ipfs and tor and haproxy:

1) Get image:

    docker pull torplusdev/production:ipfs_haproxy-latest

2) Save the certificate from the server to a folder:

    ./ssl
    
3) Run docker:
    docker run \
    --name torplus \
    -e nickname=tum332 \
    -e seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ \
    -e role=hs_client \
    -e HOST_PORT=80 \
    -e PP_ENV=prod \
    -e WWW_IP=smartapi.ru \
    -p 80:80 \
    -v ${PWD}/tor:/root/tor \
    -v ${PWD}/ipfs:/root/.ipfs \
    -v ${PWD}/ssl:/etc/ssl/torplus/ \
    -v ${PWD}/hidden_service:/root/hidden_service \
    --rm \
    torplusdev/production:ipfs_haproxy-latest

Description:

-e nickname=tum332  - nickname in tor
-e PP_ENV=prod - stage or prod 
-e seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ -  payment gateway seed
-e HOST_PORT=80  - port haproxy
-e WWW_IP=smartapi.ru -  web site wihch we host 
-p 80:80 - local port for haproxy
-v ${PWD}/tor:/root/tor  - save keys of tor 
-v ${PWD}/ipfs:/root/.ipfs - save repo data
-v ${PWD}/ssl:/etc/ssl/torplus/ - ssl directory for haproxy 
-v ${PWD}/hidden_service:/root/hidden_service - onion address store 
--rm  -- remove docker container when stop 


4) Take hostname (onion address is created when docker starts):

    cat hidden_service/hsv3/hostname

    Add TXT record to DNS:
        torplus={hostname}


