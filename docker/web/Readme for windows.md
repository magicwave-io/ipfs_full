Установить docker 

https://www.docker.com/products/docker-desktop

Login to docker regestry:
    docker login --username "your_username" --password "your_password" torplusserviceregistry.azurecr.io 
    - use login and password

Run ipfs and tor and haproxy:

1) Получить image:

    docker pull torplusserviceregistry.azurecr.io/private/ipfs_haproxy:latest

2) Сохранить сертификат с сервера в папку

    ./ssl

3) Запустить docker:
    docker run --name torplus -e nickname=tunick -e PP_ENV=prod -e seed=SCR27IGKMKXSOKUV7AC4T3HBTBVBL2MI45HHFSDNRYJFFVKWQAWBBKKZ -e role=hs_client -e HOST_PORT=80 -e WWW_IP=smartapi.ru -p 80:80 -v %cd%/tor:/root/tor -v %cd%/ipfs:/root/.ipfs -v %cd%/ssl:/etc/ssl/torplus/ -v %cd%/hidden_service:/root/hidden_service --rm torplusserviceregistry.azurecr.io/private/ipfs_haproxy:latest

Описание:

-e nickname=tunick  - nickname в tor
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



4) Взять hostname (onion адресс создается при старте dockera):

    cat hidden_service/hsv3/hostname
    Добавить TXT запись в DNS:
        torplus={hostname}

