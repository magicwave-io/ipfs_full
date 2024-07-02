# Preparing

## Install docker:

       curl -fsSL https://get.docker.com -o get-docker.sh
       sh get-docker.sh
       chmod +x /usr/bin/docker

Docker minimal requirements:
    
Memory: 512MB RAM (2GB Recommended)
CPU: 2 CORE


## Create workspace directory:

        mkdir -p <pathofworkspace>
        cd <pathofworkspace>

## Login to docker regestry:

use login and password is secret

    REGESTRY_USER=<username>
    REGESTRY_PASSWORD=<password>
    docker login --username "${REGESTRY_USER}" --password "${REGESTRY_PASSWORD}" torplusserviceregistry.azurecr.io 
    

# Run ipfs client
    
## Pull image 

    docker pull torplusserviceregistry.azurecr.io/private/ipfs:latest

## Run torplus container with ipfs: 

    # create workspace
    cd ${torplusworkspace}

    nickname=tunick21

    # run docker container
    docker run \
        --name topplusipfs
        -e nickname=${nickname} \
        -e PP_ENV=stage \
        -e seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ \
        -v ${PWD}/tor:/root/tor \
        -v ${PWD}/ipfs:/root/.ipfs \
        -v ${PWD}/hidden_service:/root/hidden_service \
        --entrypoint /bin/bash -it \
        --rm \
        torplusserviceregistry.azurecr.io/private/ipfs:latest


# Run web site hoster

## Create folder for ssl and copy ssl to dir

    torplusworkspace=<yourworkspacedir>
    cd ${torplusworkspace}
    mkdir -p ssl
### If use let's encrypt:
    
    # install certbot:
    apt update && apt install -y certbot
    
    domain=<yourdomains>
    email=<youremail>
    certbot certonly --standalone -d ${domain} \
                    --non-interactive --agree-tos --email ${email} \
                    --http-01-port=80

    cat /etc/letsencrypt/live/${domain}/fullchain.pem /etc/letsencrypt/live/${domain}/privkey.pem | ${torplusworkspace}/ssl/${domain}.pem
          

## Pull docker image:

     docker pull torplusserviceregistry.azurecr.io/private/ipfs_haproxy:latest

## For host static files

### Set static files:

        cd ${torplusworkspace}
        mkdir static 
        echo "Hello" >> ./static/index.html # or copy your static files

### Run docker image:

    cd ${torplusworkspace}

    seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ 

    nickname=tum332

    docker run \
        --name torplus \
        -e nickname=${nickname} \
        -e seed=${seed} \
        -e role=hs_client \
        -e HOST_PORT=80 \
        -e PP_ENV=prod \
        -e WWW_IP=127.0.0.1:80 \
        -e useNginx=1 \
        -p 80:80 \
        -v ${PWD}/tor:/root/tor \
        -v ${PWD}/ipfs:/root/.ipfs \
        -v ${PWD}/ssl:/etc/ssl/torplus/ \
        -v ${PWD}/hidden_service:/root/hidden_service \
        -v ${PWD}/static:/var/www/html \
        --rm \
        torplusserviceregistry.azurecr.io/private/ipfs_haproxy:latest

### Add Txt record to dns:
    
    torplus=<onion address without .onion suffix>

## Host from another ip or host or localhost site:

4) Run docker container: 

        cd ${torplusworkspace}

        seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ # set your seed

        nickname=tum332

        domain=smartapi.ru
        
        docker run \
            --name torplus \
            -e nickname=${nickname} \
            -e seed=${seed} \
            -e role=hs_client \
            -e HOST_PORT=80 \
            -e PP_ENV=prod \
            -e WWW_IP=${domain} \
            -p 80:80 \
            -v ${PWD}/tor:/root/tor \
            -v ${PWD}/ipfs:/root/.ipfs \
            -v ${PWD}/ssl:/etc/ssl/torplus/ \
            -v ${PWD}/hidden_service:/root/hidden_service \
            --add-host host.docker.internal:host-gateway \
            --rm \
            torplusserviceregistry.azurecr.io/private/ipfs_haproxy:latest

