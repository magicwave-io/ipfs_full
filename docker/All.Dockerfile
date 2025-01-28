FROM debian:10 AS cache
WORKDIR /app
# find . -regex '.*\/go\.sum'
# find . -regex '.*\/go\.mod'
COPY . .
RUN rm -rf docker

FROM golang:latest as build
WORKDIR /opt/paidpiper/ipfs_full
RUN apt-get update && apt-get install -y build-essential manpages-dev
#COPY . .
COPY --from=cache /app .
WORKDIR /opt/paidpiper/ipfs_full
RUN make build_linux

#-----------
FROM torplusserviceregistry.azurecr.io/private/paymentgateway AS pg

FROM torplusserviceregistry.azurecr.io/private/haproxy
COPY --from=pg /opt/paidpiper/payment-gateway /opt/paidpiper/payment-gateway
COPY --from=pg /opt/paidpiper/config.json.tmpl /opt/paidpiper/config.json.tmpl
COPY --from=pg /pg-docker-entrypoint.sh /pg-docker-entrypoint.sh


RUN apt-get update && \
    apt-get install -y curl supervisor gettext-base && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/paidpiper/
COPY --from=build /opt/paidpiper/ipfs_full/ipfs ipfs
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/ipfs.prod.cfg ipfs.prod.cfg
COPY docker/ipfs.stage.cfg ipfs.stage.cfg
COPY docker/init.sh init.sh
RUN bash init.sh
COPY docker/ipfs-docker-entrypoint.sh /ipfs-docker-entrypoint.sh
RUN chmod 755 /ipfs-docker-entrypoint.sh
COPY docker/debug-start.sh /debug-start.sh
RUN chmod 755 /debug-start.sh
ENTRYPOINT ["/usr/bin/supervisord"]

