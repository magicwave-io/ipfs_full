#!/bin/sh
if [[ "${useNginx}" != "1" ]]; then
    nginx   
fi
/pg-docker-entrypoint.sh &
/tor-docker-entrypoint.sh &
/haproxy-docker-entrypoint.sh &
/ipfs-docker-entrypoint.sh 
