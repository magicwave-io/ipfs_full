#-------
# BUILD
#-------


FROM torplusserviceregistry.azurecr.io/private/ipfs:latest as build

# FROM debian:10 as go_build
# RUN echo deb http://ftp.debian.org/debian buster-backports main >> /etc/apt/sources.list.d/backports.list
# RUN echo deb-src http://ftp.debian.org/debian buster-backports main >> /etc/apt/sources.list.d/backports.list

# #COPY backports.list /etc/apt/sources.list.d/backports.list
# RUN apt update && \
#     apt install -y golang-go -t buster-backports && \
#     rm -rf /var/lib/apt/lists/*

# # Installing Library & Package
# RUN apt-get update && \
# apt-get install -y expect \
#     links jq vim curl \
#     dos2unix git make cmake build-essential \
#     libevent-dev libssl-dev zlib1g-dev autotools-dev \
#     libcurl4 libcurl4-gnutls-dev libjson-c-dev && \
#     rm -rf /var/lib/apt/lists/*
# # Setting working directory
# WORKDIR /opt/paidpiper

# # Building and installing 
# COPY . /opt/paidpiper/ipfs_full/
# RUN go build github.com/ipfs/go-ipfs/cmd/ipfs && \
#             cp ./ipfs /opt/paidpiper/ipfs 
# RUN cd /opt/paidpiper/ipfs_full/go-payment-service && \
#         go build paidpiper.com/payment-gateway && \
#         cp /opt/paidpiper/ipfs_full/go-payment-service/PaymentGateway/payment-gateway /opt/paidpiper/payment-gateway

# #-------
# # TEST
# #-------

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
