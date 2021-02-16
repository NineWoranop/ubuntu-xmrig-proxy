FROM ubuntu:16.04

WORKDIR /tmp

RUN apt-get update \
    && apt-get -y --no-install-recommends install ca-certificates curl build-essential cmake libuv1-dev uuid-dev git openssl libmicrohttpd-dev libssl-dev libhwloc-dev

RUN git clone --depth 1 https://github.com/NineWoranop/xmrig-proxy.git \
    && cd xmrig-proxy \
    && mkdir build \
    && cd build \
    && cmake -DWITH_HTTPD=OFF .. \
    && make \
    && cd ../.. \
    && mv xmrig-proxy/build/xmrig-proxy /usr/local/bin/xmrig-proxy \
    && chmod a+x /usr/local/bin/xmrig-proxy \
    && apt-get -y remove ca-certificates curl build-essential cmake \
    && apt-get clean autoclean \
    && rm -rf /var/lib/{apt,dpkg,cache,log}

RUN groupadd -g 2000 xmrig-proxy && \
    useradd -u 2000 -g xmrig-proxy -m -s /bin/bash xmrig-proxy && \
    echo 'xmrig-proxy:xmrig-proxy' | chpasswd

USER xmrig-proxy

ENTRYPOINT ["xmrig-proxy"]
CMD ["--help"]