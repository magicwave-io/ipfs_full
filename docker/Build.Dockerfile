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
