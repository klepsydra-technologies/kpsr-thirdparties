FROM ubuntu:18.04 AS builder
ARG third_party_flags='-y -z'
 
# System Dependencies.
ARG BUILD_ID='local'
LABEL kpsr-thirdparties=builder
LABEL BUILD_ID=${BUILD_ID}

RUN apt update && apt-get install libssl-dev libcurl4-gnutls-dev build-essential git cmake -y 

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /var/tmp

# Klepsydra
COPY . kpsr-thirdparties

RUN cd kpsr-thirdparties \ 
    && echo $third_party_flags \
    && ./build_3parties.sh $third_party_flags


FROM ubuntu:18.04

COPY --from=builder /opt/ /opt/
WORKDIR /opt/
