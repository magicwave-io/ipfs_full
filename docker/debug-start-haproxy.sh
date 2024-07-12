#!/bin/bash

if [[ "${useNginx}" == "1" ]]; then
        nginx
fi

function checkPEM {
        domain=$1
        echo "checkPEM ${domain}"
        if [[ "$domain" != "" ]]; then
                domFromFile="$(openssl x509 -noout -subject -in /etc/ssl/${BASE_NAME}/${domain}.pem | awk -F = '{print $3}' | awk '{$1=$1};1')"
                if [[ "${domFromFile}" != "${domain}" ]]; then
                        echo "Certificate for ${domain} != ${domFromFile}  not valid."
                        exit 1
                fi
        fi
}
if [ -z "$(ls -A /etc/ssl/${BASE_NAME}/)" ]; then
   echo "ssl directory empty"
   exit 1
fi

#for file in /etc/ssl/${BASE_NAME}/*; do
#       checkPEM "$(echo -n $file | sed -r "s/.+\/(.+)\..+/\1/" )"
#done

curl --connect-timeout 3 --max-time 5 -d '{"dns_record":"'$MY_DNS_NAME'"}' -H "Content-Type: application/json" -X POST https://dns-records-manager.magicwave.io/api/record >/dev/null 2>/dev/null || true

set -m
(
        (/pg-docker-entrypoint.sh || kill 0) &
        (/tor-docker-entrypoint.sh || kill 0) &
        (/haproxy-docker-entrypoint.sh || kill 0) &
        (/ipfs-docker-entrypoint.sh || kill 0) &
        wait
)
