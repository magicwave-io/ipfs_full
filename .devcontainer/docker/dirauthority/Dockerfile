#-------
# BUILD
#-------

FROM debian:10 as build

COPY backports.list /etc/apt/sources.list.d/backports.list
RUN apt update && \
apt install -y golang-go -t buster-backports && \
rm -rf /var/lib/apt/lists/*

# Installing Library & Package
RUN apt-get update && \
apt-get install -y expect torsocks links nginx vsftpd ftp jq vim curl dos2unix git make cmake build-essential libevent-dev libssl-dev zlib1g-dev autotools-dev libcurl4 libcurl4-gnutls-dev libjson-c-dev automake supervisor && \
rm -rf /var/lib/apt/lists/*

# Setting working directory
WORKDIR /opt/paidpiper

# Building and installing 
RUN cd /opt/paidpiper && \
git clone https://xfxj4tqvw6tdxhaafrjo7tjcwqgof7bulth4mlevikpujdmazlzq@dev.azure.com/paidpiper2020/PaidPiper/_git/PaymentServices /opt/paidpiper/PaymentServices && \
cd /opt/paidpiper/PaymentServices/PaymentGateway && \
go build paidpiper.com/payment-gateway && \
cd /opt/paidpiper && \
git clone https://xfxj4tqvw6tdxhaafrjo7tjcwqgof7bulth4mlevikpujdmazlzq@dev.azure.com/paidpiper2020/PaidPiper/_git/tor_rest_lib  /opt/paidpiper/tor_rest_lib && \
cd /opt/paidpiper/tor_rest_lib && \
mkdir build && \
cd build && \
cmake .. && \
make && \
cd /opt/paidpiper && \
git clone https://xfxj4tqvw6tdxhaafrjo7tjcwqgof7bulth4mlevikpujdmazlzq@dev.azure.com/paidpiper2020/PaidPiper/_git/tor_plus  /opt/paidpiper/tor_plus && \
cd /opt/paidpiper/tor_plus && \
sh autogen.sh && \
autoreconf -f -i && \
./configure  --disable-asciidoc && \
make && \
make install && \
git clone --recurse-submodules https://xfxj4tqvw6tdxhaafrjo7tjcwqgof7bulth4mlevikpujdmazlzq@dev.azure.com/paidpiper2020/PaidPiper/_git/ipfs_full /opt/paidpiper/ipfs_full && \
cd /opt/paidpiper/ipfs_full && \
cd go-bitswap && \
git pull origin ppmaster && \
cd ../go-libp2p && \
git pull origin ppmaster && \
cd ../go-libp2p-core && \
git pull origin ppmaster && \
cd ../go-libp2p-onion-transport && \
git pull origin ppmaster && \
cd ../go-ipfs && \
git pull origin ppmaster && \
go build github.com/ipfs/go-ipfs/cmd/ipfs && \
cp ./ipfs /opt/paidpiper/



#-------
# TEST
#-------

FROM debian:10

RUN mkdir -p /opt/paidpiper/PaymentServices/PaymentGateway && \
mkdir -p /opt/paidpiper/conf/ppgw && \
touch /opt/paidpiper/conf/ppgw/config.json && \
ln -s /opt/paidpiper/conf/ppgw/config.json /opt/paidpiper/PaymentServices/PaymentGateway/config.json && \
mkdir -m 700 -p /root/tor/hidden_service/hsv3 && \
apt-get update && \
apt-get install -y libevent-dev libssl-dev zlib1g-dev libcurl4 libcurl4-gnutls-dev libjson-c-dev expect torsocks links nginx vsftpd ftp vim curl supervisor && \
rm -rf /var/lib/apt/lists/*

#############################
## Copy artefacts from build
#############################
COPY --from=build /opt/paidpiper/PaymentServices/PaymentGateway/payment-gateway /opt/paidpiper/PaymentServices/PaymentGateway/payment-gateway
COPY --from=build /usr/local/bin/tor /usr/local/bin/tor

#####################
## Copy config files
#####################
COPY vsftpd.conf /etc/vsftpd.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /opt/www/index.html
COPY config.json /opt/paidpiper/conf/ppgw/config.json
COPY ./conf/tor/torrc /usr/local/etc/tor/torrc
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
