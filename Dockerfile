FROM ubuntu:latest

MAINTAINER sun <sunfuj@163.com>

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev
ENV BASEDIR /tmp/shadowsocks-libev
ENV VERSION v2.4.1

# Set up building environment
RUN apt-get update \
 && apt-get install -y $DEPENDENCIES

 # Get the latest code, build and install
 RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $BASEDIR
 WORKDIR $BASEDIR
 RUN git checkout $VERSION \
  && ./configure \
   && make \
    && make install

    # Tear down building environment and delete git repository
    WORKDIR /
    RUN rm -rf $BASEDIR/shadowsocks-libev\
     && apt-get --purge autoremove -y $DEPENDENCIES

     # Port in the json config file won't take affect. Instead we'll use 443.
     EXPOSE 443
     CMD ["/usr/local/bin/ss-server", "-s", "0.0.0.0", "-p", "443", "-k", "1230666666", "-m", "aes-256-cfb"]