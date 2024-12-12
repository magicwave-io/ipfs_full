FROM build_ipfs as build

FROM torplusserviceregistry.azurecr.io/private/paymentgateway:latest

ARG IPFS_VERSION IPFS_VERSION
ENV IPFS_VERSION $IPFS_VERSION
ARG PP_ENV
ENV PP_ENV $PP_ENV
#----------
RUN apt-get update && \
    apt-get install -y curl supervisor gettext-base && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/paidpiper/
COPY --from=build /opt/paidpiper/ipfs_full/ipfs ipfs
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/ipfs.prod.cfg ipfs.prod.cfg
COPY docker/ipfs.stage.cfg ipfs.stage.cfg

COPY docker/ipfs-docker-entrypoint.sh /ipfs-docker-entrypoint.sh
RUN chmod 755 /ipfs-docker-entrypoint.sh
COPY docker/debug-start.sh /debug-start.sh
RUN chmod 755 /debug-start.sh
ENTRYPOINT [ "/debug-start.sh" ]
#ENTRYPOINT ["/usr/bin/supervisord"]

