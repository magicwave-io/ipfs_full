#-------
# BUILD
#-------


FROM torplusserviceregistry.azurecr.io/private/ipfs:latest as build

FROM debian:10

RUN mkdir -p /opt/paidpiper/PaymentServices/PaymentGateway && \
mkdir -p /opt/paidpiper/conf/ppgw && \
touch /opt/paidpiper/conf/ppgw/config.json && \
ln -s /opt/paidpiper/conf/ppgw/config.json /opt/paidpiper/PaymentServices/PaymentGateway/config.json && \
mkdir -m 700 -p /root/tor/hidden_service/hsv3 && \
apt-get update && \
apt-get install -y libevent-dev libssl-dev zlib1g-dev libcurl4 libcurl4-gnutls-dev \
                    libjson-c-dev expect torsocks links nginx curl \
                    supervisor gettext-base net-tools jq && \
rm -rf /var/lib/apt/lists/*
#############################
## Copy artefacts from build
#############################

COPY --from=build /usr/local/bin/tor /usr/local/bin/tor
COPY --from=build /opt/paidpiper/ipfs /opt/paidpiper/ipfs
COPY --from=build /opt/paidpiper/payment-gateway /opt/paidpiper/payment-gateway
#####################
## Copy config files
#####################

COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /opt/www/index.html
COPY config.json /opt/paidpiper/conf/ppgw/config.json
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
