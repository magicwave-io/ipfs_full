FROM build_ipfs as build
FROM torplusserviceregistry.azurecr.io/private/paymentgateway:latest AS pg

FROM torplusserviceregistry.azurecr.io/private/haproxy:latest

ENV BASE_NAME application
ENV role hs_client
ENV HOST_PORT 80
ARG IPFS_VERSION IPFS_VERSION
ENV IPFS_VERSION $IPFS_VERSION

COPY --from=pg /opt/${BASE_NAME}/payment-gateway /opt/${BASE_NAME}/payment-gateway
COPY --from=pg /opt/${BASE_NAME}/config.json.tmpl /opt/${BASE_NAME}/config.json.tmpl
COPY --from=pg /pg-docker-entrypoint.sh /pg-docker-entrypoint.sh

ENV PATH="/opt/${BASE_NAME}:${PATH}"
ENV PP_ENV=prod
RUN apt-get update && \
    apt-get install -y curl supervisor gettext-base && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/${BASE_NAME}/
COPY --from=build /opt/${BASE_NAME}/ipfs_full/ipfs ipfs
COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/ipfs.prod.cfg ipfs.prod.cfg
COPY docker/ipfs.stage.cfg ipfs.stage.cfg
COPY docker/ipfs-docker-entrypoint.sh /ipfs-docker-entrypoint.sh
RUN chmod 755 /ipfs-docker-entrypoint.sh
COPY docker/debug-start-haproxy.sh /debug-start.sh
RUN chmod 755 /debug-start.sh

COPY docker/tor-docker-entrypoint.sh /tor-docker-entrypoint.sh
RUN chmod 755 /tor-docker-entrypoint.sh
COPY docker/configs configs
RUN chmod 755 /debug-start.sh

ENTRYPOINT [ "/debug-start.sh" ]
