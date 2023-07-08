FROM ubuntu:focal
LABEL maintainer="Ufintek"

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y gnupg ca-certificates && rm -rf /var/lib/apt/lists/* 

RUN apt-get update && apt-get install -y build-essential libtool automake git tree rpm libboost-all-dev \
	libpcap-dev libsndfile1-dev libapr1-dev libspeex-dev liblog4cxx-dev libace-dev libcap-dev \
	libopus-dev libxerces-c3-dev libssl-dev cmake libdw-dev liblzma-dev libunwind-dev curl \
	&& rm -rf /var/lib/apt/lists/* 

#silk
RUN mkdir -p /opt/silk && chmod 777 /opt/silk \
	&& git clone --depth 1 https://github.com/gaozehua/SILKCodec.git /opt/silk/SILKCodec \
	&& cd /opt/silk/SILKCodec/SILK_SDK_SRC_FIX \
	&& CFLAGS='-fPIC' make all 

#opus
RUN mkdir -p /opt/opus && chmod 777 /opt/opus \
	&& git clone  https://github.com/xiph/opus.git /opt/opus \
	&& cd /opt/opus \
	&& git checkout v1.2.1 \
	&& ./autogen.sh \
	&& ./configure --enable-shared --with-pic --enable-static \
	&& make \
	&& make install \
	&& ln -s /usr/local/lib/libopus.so /usr/local/lib/libopusstatic.so \
	&& ln -s /usr/include/opus /opt/opus/include/opus

#g729
RUN mkdir -p /opt/bcg729 && chmod 777 /opt/bcg729 \
	&& git clone --depth 1 https://github.com/BelledonneCommunications/bcg729.git /opt/bcg729 \
	&& cd /opt/bcg729 \
	&& cmake . -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib \
	&& make \
	&& make install

#backward-cpp
RUN mkdir -p /opt/backward-cpp && chmod 777 /opt/backward-cpp \
	&& git clone --depth 1 https://github.com/bombela/backward-cpp.git /opt/backward-cpp \
	&& ln -s /opt/backward-cpp/backward.hpp /usr/local/include/backward.hpp
  
RUN mkdir -p /opt/oreka
